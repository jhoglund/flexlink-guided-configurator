class HealthController < ApplicationController
  skip_before_action :authenticate_user!
  
  def index
    health_status = {
      status: 'healthy',
      timestamp: Time.current.iso8601,
      version: '1.0.0',
      services: {
        database: database_healthy?,
        redis: redis_healthy?,
        supabase: supabase_healthy?
      }
    }
    
    status_code = health_status[:services].values.all? ? :ok : :service_unavailable
    health_status[:status] = status_code == :ok ? 'healthy' : 'unhealthy'
    
    render json: health_status, status: status_code
  end

  private

  def database_healthy?
    ActiveRecord::Base.connection.execute('SELECT 1')
    true
  rescue => e
    Rails.logger.error "Database health check failed: #{e.message}"
    false
  end

  def redis_healthy?
    Rails.cache.redis.ping == 'PONG'
  rescue => e
    Rails.logger.error "Redis health check failed: #{e.message}"
    false
  end

  def supabase_healthy?
    # Test Supabase connection by making a simple API call
    supabase_service = SupabaseService.new
    supabase_service.get_component_types
    true
  rescue => e
    Rails.logger.error "Supabase health check failed: #{e.message}"
    false
  end
end 