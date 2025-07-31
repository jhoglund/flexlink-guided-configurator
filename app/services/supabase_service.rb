class SupabaseService
  require 'net/http'
  require 'uri'
  require 'json'

  def initialize
    # Try to load environment variables if not present
    load_env_file if ENV['SUPABASE_URL'].blank?

    @base_url = ENV['SUPABASE_URL']
    @api_key = ENV['SUPABASE_ANON_KEY']
    @headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@api_key}",
      'apikey' => @api_key,
      'Accept' => 'application/json'
    }

    # Enhanced debug logging
    Rails.logger.info "SupabaseService initialized with URL: #{@base_url}"
    Rails.logger.info "SupabaseService API key present: #{@api_key.present?}"
    Rails.logger.info "All ENV keys: #{ENV.keys.grep(/SUPABASE/).join(', ')}"
    Rails.logger.info "ENV['SUPABASE_URL']: #{ENV['SUPABASE_URL']}"
    Rails.logger.info "ENV['SUPABASE_ANON_KEY']: #{ENV['SUPABASE_ANON_KEY']&.slice(0, 20)}..."
  end

  # Systems (NEW - replaces conveyor_systems)
  def get_systems(filters = {})
    query = build_query('systems', filters)
    response = make_request("systems#{query}")
    handle_response(response)
  end

  def get_system(system_code)
    response = make_request("systems?system_code=eq.#{system_code}")
    handle_response(response).first
  end

  def search_systems(search_term, filters = {})
    # Use the new search_systems function
    query_params = { search_term: search_term }.merge(filters)
    query = build_query('rpc/search_systems', query_params)
    response = make_request("rpc/search_systems#{query}")
    handle_response(response)
  end

  def get_system_stats
    response = make_request('rpc/get_system_stats')
    handle_response(response).first
  end

  # Components (RENAMED from component_specifications)
  def get_components(filters = {})
    query = build_query('components', filters)
    response = make_request("components#{query}")
    handle_response(response)
  end

  def get_component(id)
    response = make_request("components?id=eq.#{id}")
    handle_response(response).first
  end

  def search_components(query, filters = {})
    search_filters = filters.merge({ search: query })
    get_components(search_filters)
  end

  def get_components_by_type(component_type, filters = {})
    type_filters = filters.merge({ component_type: component_type })
    get_components(type_filters)
  end

  def get_components_by_system(system_code, filters = {})
    system_filters = filters.merge({ system_code: system_code })
    get_components(system_filters)
  end

  # Product Images
  def get_product_images(filters = {})
    query = build_query('product_images', filters)
    response = make_request("product_images#{query}")
    handle_response(response)
  end

  def get_images_by_system(system_code)
    response = make_request("product_images?system_code=eq.#{system_code}")
    handle_response(response)
  end

  # Views
  def get_system_overview
    response = make_request('system_overview')
    handle_response(response)
  end

  def get_component_compatibility
    response = make_request('component_compatibility')
    handle_response(response)
  end

  def get_system_statistics
    response = make_request('system_stats')
    handle_response(response).first
  end

  # Legacy methods for backward compatibility
  def get_conveyor_systems(filters = {})
    # Redirect to new systems table
    get_systems(filters)
  end

  def get_conveyor_system(id)
    # Try to find by system_code first, then by id
    system = get_system(id)
    return system if system

    # Fallback to id lookup
    response = make_request("systems?id=eq.#{id}")
    handle_response(response).first
  end

  def get_component_specifications(filters = {})
    # Redirect to new components table
    get_components(filters)
  end

  def get_component_specification(id)
    get_component(id)
  end

  # Caching methods
  def get_cached_components(filters = {})
    cache_key = "supabase:components:#{filters.hash}"
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      get_components(filters)
    end
  end

  def get_cached_systems(filters = {})
    cache_key = "supabase:systems:#{filters.hash}"
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      get_systems(filters)
    end
  end

  def get_cached_system_overview
    cache_key = 'supabase:system_overview'
    Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      get_system_overview
    end
  end

  # Component types
  def get_component_types
    cache_key = 'supabase:component_types'
    Rails.cache.fetch(cache_key, expires_in: 6.hours) do
      Rails.logger.info 'Making Supabase request for component types'

      response = make_request('components?select=component_type&component_type=not.is.null')
      Rails.logger.info "Supabase response code: #{response.code}"
      Rails.logger.info "Supabase response body: #{response.body[0..200]}"

      data = handle_response(response)
      data.map { |item| item['component_type'] }.uniq.sort
    end
  end

  # System specifications
  def get_system_specifications
    cache_key = 'supabase:system_specifications'
    Rails.cache.fetch(cache_key, expires_in: 6.hours) do
      response = make_request('systems?select=system_code,system_name,category,description,key_features,applications&is_active=eq.true')
      data = handle_response(response)
      # Group by category to create specifications
      data.group_by { |item| item['category'] || 'General' }.transform_values do |items|
        items.map { |item| item['system_name'] }.uniq
      end
    end
  end

  # New methods for enhanced functionality
  def get_systems_by_category(category)
    response = make_request("systems?category=eq.#{category}")
    handle_response(response)
  end

  def get_systems_by_load_capacity(load_capacity)
    response = make_request("systems?load_capacity=ilike.*#{load_capacity}*")
    handle_response(response)
  end

  def get_compatible_components(system_code)
    response = make_request("components?compatibility=cs.{#{system_code}}")
    handle_response(response)
  end

  def get_system_with_components(system_code)
    system = get_system(system_code)
    return nil unless system

    components = get_components_by_system(system_code)
    images = get_images_by_system(system_code)

    {
      system: system,
      components: components,
      images: images
    }
  end

  private

  def load_env_file
    env_file = Rails.root.join('.env')
    if File.exist?(env_file)
      Rails.logger.info "Loading environment variables from #{env_file}"
      File.readlines(env_file).each do |line|
        next if line.strip.empty? || line.start_with?('#')

        key, value = line.split('=', 2)
        next unless key && value

        key = key.strip
        value = value.strip.gsub(/^["']|["']$/, '') # Remove quotes

        ENV[key] = value
        Rails.logger.info "Loaded ENV[#{key}] = #{value[0..20]}..."
      end
    else
      Rails.logger.error "Environment file not found: #{env_file}"
    end
  end

  def make_request(endpoint)
    uri = URI("#{@base_url}/rest/v1/#{endpoint}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    @headers.each { |key, value| request[key] = value }

    # Add debug logging
    Rails.logger.info "Making request to: #{uri}"

    response = http.request(request)

    # Debug logging
    Rails.logger.info "Response code: #{response.code}"
    Rails.logger.info "Response body preview: #{response.body[0..200]}"

    # Handle compression if present
    if response['content-encoding'] == 'gzip'
      require 'zlib'
      Rails.logger.info 'Decompressing gzipped response...'
      decompressed_body = Zlib::GzipReader.new(StringIO.new(response.body)).read
      response.body = decompressed_body
      Rails.logger.info "Decompressed response preview: #{decompressed_body[0..200]}"
    end

    response
  end

  def build_query(table, filters)
    return '' if filters.empty?

    query_parts = []
    filters.each do |key, value|
      if value.is_a?(Array)
        value.each_with_index do |v, i|
          query_parts << "#{key}=in.(#{v})"
        end
      elsif value.is_a?(Hash)
        # Handle range queries
        query_parts << "#{key}=gte.#{value[:gte]}" if value[:gte]
        query_parts << "#{key}=lte.#{value[:lte]}" if value[:lte]
      else
        query_parts << "#{key}=eq.#{value}"
      end
    end

    "?#{query_parts.join('&')}"
  end

  def handle_response(response)
    case response.code.to_i
    when 200
      # Try to parse as JSON
      begin
        Rails.logger.info 'Parsing JSON response...'
        parsed_response = JSON.parse(response.body)
        Rails.logger.info "Successfully parsed JSON with #{parsed_response.length} items"
        parsed_response
      rescue JSON::ParserError => e
        Rails.logger.error "JSON parse error: #{e.message}"
        Rails.logger.error "Response body preview: #{response.body[0..500]}"
        raise 'Invalid response from Supabase'
      end
    when 401
      Rails.logger.error "Supabase authentication failed: #{response.body}"
      raise 'Supabase authentication failed'
    when 404
      Rails.logger.warn "Supabase resource not found: #{response.body}"
      []
    else
      Rails.logger.error "Supabase API error (#{response.code}): #{response.body}"
      raise "Supabase API error: #{response.code}"
    end
  rescue StandardError => e
    Rails.logger.error "Failed to handle Supabase response: #{e.message}"
    raise 'Invalid response from Supabase'
  end
end
