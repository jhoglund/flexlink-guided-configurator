class SupabaseService
  include HTTParty

  def initialize
    @base_url = ENV['SUPABASE_URL']
    @api_key = ENV['SUPABASE_ANON_KEY']
    @headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@api_key}",
      'apikey' => @api_key,
      'Accept' => 'application/json',
      'Accept-Encoding' => 'gzip, deflate'
    }
    
    # Debug logging
    Rails.logger.info "SupabaseService initialized with URL: #{@base_url}"
    Rails.logger.info "SupabaseService API key present: #{@api_key.present?}"
  end

  # Conveyor Systems
  def get_conveyor_systems(filters = {})
    query = build_query('conveyor_systems', filters)
    response = HTTParty.get("#{@base_url}/rest/v1/conveyor_systems#{query}", headers: @headers)
    handle_response(response)
  end

  def get_conveyor_system(id)
    response = HTTParty.get("#{@base_url}/rest/v1/conveyor_systems?id=eq.#{id}", headers: @headers)
    handle_response(response).first
  end

  # Component Specifications
  def get_component_specifications(filters = {})
    query = build_query('component_specifications', filters)
    response = HTTParty.get("#{@base_url}/rest/v1/component_specifications#{query}", headers: @headers)
    handle_response(response)
  end

  def get_component_specification(id)
    response = HTTParty.get("#{@base_url}/rest/v1/component_specifications?id=eq.#{id}", headers: @headers)
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
    cache_key = "supabase:component_types"
    Rails.cache.fetch(cache_key, expires_in: 6.hours) do
      url = "#{@base_url}/rest/v1/component_specifications?select=component_type&component_type=not.is.null"
      Rails.logger.info "Making Supabase request to: #{url}"
      
      response = HTTParty.get(url, headers: @headers)
      Rails.logger.info "Supabase response code: #{response.code}"
      Rails.logger.info "Supabase response body: #{response.body[0..200]}"
      
      data = handle_response(response)
      data.map { |item| item['component_type'] }.uniq.sort
    end
  end

  # System specifications
  def get_system_specifications
    cache_key = "supabase:system_specifications"
    Rails.cache.fetch(cache_key, expires_in: 6.hours) do
      response = HTTParty.get("#{@base_url}/rest/v1/conveyor_systems?select=system_type,system_category&system_type=not.is.null", headers: @headers)
      data = handle_response(response)
      data.group_by { |item| item['system_category'] }.transform_values { |items| items.map { |item| item['system_type'] }.uniq }
    end
  end

  private

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
        if value[:gte]
          query_parts << "#{key}=gte.#{value[:gte]}"
        end
        if value[:lte]
          query_parts << "#{key}=lte.#{value[:lte]}"
        end
      else
        query_parts << "#{key}=eq.#{value}"
      end
    end

    "?#{query_parts.join('&')}"
  end

  def handle_response(response)
    case response.code
    when 200
      # Try to parse as JSON, but handle potential encoding issues
      begin
        JSON.parse(response.body)
      rescue JSON::ParserError => e
        Rails.logger.error "JSON parse error: #{e.message}"
        Rails.logger.error "Response body preview: #{response.body[0..500]}"
        # Try to decode if it's compressed
        begin
          decoded_body = response.body.force_encoding('UTF-8')
          JSON.parse(decoded_body)
        rescue => e2
          Rails.logger.error "Failed to decode response: #{e2.message}"
          raise "Invalid response from Supabase"
        end
      end
    when 401
      Rails.logger.error "Supabase authentication failed: #{response.body}"
      raise "Supabase authentication failed"
    when 404
      Rails.logger.warn "Supabase resource not found: #{response.body}"
      []
    else
      Rails.logger.error "Supabase API error (#{response.code}): #{response.body}"
      raise "Supabase API error: #{response.code}"
    end
  rescue => e
    Rails.logger.error "Failed to handle Supabase response: #{e.message}"
    raise "Invalid response from Supabase"
  end
end 