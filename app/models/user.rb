class User < ApplicationRecord
  # Associations
  has_many :configurations, dependent: :destroy
  has_many :wizard_sessions, dependent: :destroy
  has_many :component_selections, through: :configurations

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :company, length: { maximum: 200 }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip.presence || email.split('@').first
  end

  def name
    full_name
  end

  def active_configurations
    configurations.where(status: %w[draft in_progress])
  end

  def completed_configurations
    configurations.where(status: 'completed')
  end

  def current_wizard_session
    wizard_sessions.find_by(status: 'active')
  end

  def total_configurations_value
    configurations.joins(:component_selections).sum('component_selections.price * component_selections.quantity')
  end

  def configurations_count
    configurations.count
  end

  def components_count
    component_selections.count
  end
end
