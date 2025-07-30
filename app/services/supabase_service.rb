class SupabaseService
  require 'net/http'
  require 'uri'
  require 'json'

    def initialize
    # Try to load environment variables if not present
    if ENV['SUPABASE_URL'].blank?
      load_env_file
    end
    
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

  # Conveyor Systems
  def get_conveyor_systems(filters = {})
    query = build_query('conveyor_systems', filters)
    response = make_request("conveyor_systems#{query}")
    handle_response(response)
  end

  def get_conveyor_system(id)
    response = make_request("conveyor_systems?id=eq.#{id}")
    handle_response(response).first
  end

  # Component Specifications
  def get_component_specifications(filters = {})
    query = build_query('component_specifications', filters)
    response = make_request("component_specifications#{query}")
    handle_response(response)
  end

  def get_component_specification(id)
    response = make_request("component_specifications?id=eq.#{id}")
    handle_response(response).first
  end

  def search_components(query, filters = {})
    search_filters = filters.merge({ search: query })
    get_component_specifications(search_filters)
  end

  def get_components_by_type(component_type, filters = {})
    type_filters = filters.merge({ component_type: component_type })
    get_component_specifications(type_filters)
  end

  # Caching methods
  def get_cached_component_specifications(filters = {})
    cache_key = "supabase:components:#{filters.hash}"
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      get_component_specifications(filters)
    end
  end

  def get_cached_conveyor_systems(filters = {})
    cache_key = "supabase:conveyors:#{filters.hash}"
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      get_conveyor_systems(filters)
    end
  end

  # Component types
  def get_component_types
    cache_key = 'supabase:component_types'
    Rails.cache.fetch(cache_key, expires_in: 6.hours) do
      Rails.logger.info 'Making Supabase request for component types'

      response = make_request('component_specifications?select=component_type&component_type=not.is.null')
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
      response = make_request('conveyor_systems?select=code,name,description,features,applications&is_active=eq.true')
      data = handle_response(response)
      # Group by applications to create categories
      data.group_by { |item| item['applications']&.first || 'General' }.transform_values do |items|
        items.map { |item| item['name'] }.uniq
      end
    end
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
