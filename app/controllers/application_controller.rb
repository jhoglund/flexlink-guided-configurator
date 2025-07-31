class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def not_found
    render json: { error: 'Resource not found' }, status: :not_found
  end

  def bad_request
    render json: { error: 'Bad request' }, status: :bad_request
  end

  def current_user
    # For development/testing without authentication, always return the first user
    User.first
  end

  def current_wizard_session
    return nil unless current_user

    @current_wizard_session ||= WizardSession.find_by(user: current_user, status: 'active')
  end

  def supabase_service
    @supabase_service ||= SupabaseService.new
  end
end
