class Configuration < ApplicationRecord
  belongs_to :user
  has_many :component_selections, dependent: :destroy
  has_many :wizard_sessions, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 3, maximum: 200 }
  validates :status, presence: true, inclusion: { in: %w[draft in_progress completed] }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :recent, -> { order(updated_at: :desc) }
  scope :active, -> { where(status: ['draft', 'in_progress']) }
  scope :completed, -> { where(status: 'completed') }
  scope :by_system_type, ->(type) { where("system_specifications->>'system_type' = ?", type) }

  # Callbacks
  before_save :calculate_total_price
  before_save :update_completion_date

  # Instance methods
  def component_count
    component_selections.count
  end

  def total_components
    component_selections.sum(:quantity)
  end

  def calculate_total_price
    self.total_price = component_selections.sum('price * quantity')
  end

  def update_completion_date
    self.completed_at = Time.current if status_changed? && status == 'completed'
  end

  def progress_percentage
    return 0 if wizard_sessions.empty?
    
    current_step = wizard_sessions.last.current_step
    total_steps = wizard_sessions.last.total_steps
    ((current_step.to_f / total_steps) * 100).round
  end

  def can_continue?
    status == 'draft' || status == 'in_progress'
  end

  def can_complete?
    component_selections.any? && status != 'completed'
  end

  def system_type
    system_specifications['system_type']
  end
  
  def export_data
    {
      id: id,
      name: name,
      description: description,
      system_type: system_type,
      status: status,
      total_price: total_price,
      created_at: created_at,
      updated_at: updated_at,
      components: component_selections.map(&:export_data),
      specifications: system_specifications
    }
  end
end 