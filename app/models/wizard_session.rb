class WizardSession < ApplicationRecord
  belongs_to :user
  belongs_to :configuration

  # Validations
  validates :session_id, presence: true, uniqueness: true
  validates :current_step, numericality: { greater_than: 0, less_than_or_equal_to: 8 }
  validates :status, inclusion: { in: %w[active completed abandoned] }

  # Callbacks
  before_create :generate_session_id
  before_save :update_last_activity

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
  scope :recent, -> { order(updated_at: :desc) }

  # Status methods
  def active?
    status == 'active'
  end

  def completed?
    status == 'completed'
  end

  def abandoned?
    status == 'abandoned'
  end

  # Step navigation methods
  def next_step
    return nil if current_step >= total_steps
    current_step + 1
  end

  def previous_step
    return nil if current_step <= 1
    current_step - 1
  end

  def can_proceed_to_next?
    step_data["step_#{current_step}"].present? && validation_errors.empty?
  end

  def can_go_back?
    current_step > 1
  end

  # Progress methods
  def progress_percentage
    (current_step.to_f / total_steps * 100).round
  end

  def total_steps
    8 # Adjust based on your wizard structure
  end

  # Data management methods
  def save_step_data(step, data)
    step_data["step_#{step}"] = data
    save!
  end

  def get_step_data(step)
    step_data["step_#{step}"] || {}
  end

  def clear_step_data(step)
    step_data.delete("step_#{step}")
    save!
  end

  def add_validation_error(step, field, message)
    validation_errors["step_#{step}"] ||= {}
    validation_errors["step_#{step}"][field] = message
    save!
  end

  def clear_validation_errors(step)
    validation_errors.delete("step_#{step}")
    save!
  end

  def get_validation_errors(step)
    validation_errors["step_#{step}"] || {}
  end

  # Session management methods
  def complete!
    update!(
      status: 'completed',
      completed_at: Time.current,
      current_step: total_steps
    )
  end

  def abandon!
    update!(status: 'abandoned')
  end

  def restart!
    update!(
      status: 'active',
      current_step: 1,
      step_data: {},
      validation_errors: {},
      completed_at: nil
    )
  end

  private

  def generate_session_id
    self.session_id = SecureRandom.uuid if session_id.blank?
  end

  def update_last_activity
    self.last_activity_at = Time.current
  end
end 