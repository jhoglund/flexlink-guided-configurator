class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :company])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :company])
  end

  def not_found
    render json: { error: 'Resource not found' }, status: :not_found
  end

  def bad_request
    render json: { error: 'Bad request' }, status: :bad_request
  end

  def current_wizard_session
    @current_wizard_session ||= WizardSession.find_by(user: current_user, status: 'active')
  end

  def supabase_service
    @supabase_service ||= SupabaseService.new
  end
end 