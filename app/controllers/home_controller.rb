class HomeController < ApplicationController
  def index
    # Load data for the homepage
    @recent_configurations = ::Configuration.order(created_at: :desc).limit(5)
    @completed_configurations = ::Configuration.where(status: 'completed')
    @active_configurations = ::Configuration.where(status: 'active')
    @total_value = @completed_configurations.joins(:component_selections).sum('component_selections.price * component_selections.quantity')

    # Load system specifications and component types for display
    @system_specifications = {
      'conveyor' => %w[belt_conveyor roller_conveyor chain_conveyor],
      'material_handling' => %w[pallet_conveyor overhead_conveyor sorting_conveyor],
      'packaging' => %w[accumulation_conveyor divert_conveyor merge_conveyor]
    }

    @component_types = %w[belt roller motor sensor controller frame accessory chain drive_unit]
  end

  def dashboard
    # Use the first user for demo purposes (no authentication)
    user = User.first

    @configurations_count = user&.configurations&.count || 0
    @completed_count = user&.completed_configurations&.count || 0
    @active_count = user&.active_configurations&.count || 0

    @recent_activity = user&.configurations&.recent&.limit(10) || []

    # Component statistics
    @total_components_selected = user&.configurations&.joins(:component_selections)&.count || 0

    # Price statistics
    @total_value = user&.configurations&.joins(:component_selections)&.sum('component_selections.price * component_selections.quantity') || 0

    respond_to do |format|
      format.html
      format.json do
        render json: {
          configurations_count: @configurations_count,
          completed_count: @completed_count,
          active_count: @active_count,
          total_components: @total_components_selected,
          total_value: @total_value
        }
      end
    end
  end
end
