class Wizard::StepsController < ApplicationController
  before_action :ensure_wizard_session
  before_action :validate_step, only: [:show, :update]
  
  # Step definitions
  STEPS = {
    1 => { name: 'system_type', title: 'System Type Selection' },
    2 => { name: 'system_specifications', title: 'System Specifications' },
    3 => { name: 'component_types', title: 'Component Type Selection' },
    4 => { name: 'component_selection_1', title: 'Component Selection 1' },
    5 => { name: 'component_selection_2', title: 'Component Selection 2' },
    6 => { name: 'component_selection_3', title: 'Component Selection 3' },
    7 => { name: 'component_selection_4', title: 'Component Selection 4' },
    8 => { name: 'review', title: 'Review and Complete' }
  }
  
  TOTAL_STEPS = STEPS.length

  def show
    @step = params[:step].to_i
    @step_data = @wizard_session.step_data(@step)
    @step_config = STEPS[@step]
    
    # Load data based on step
    case @step
    when 1
      @system_types = supabase_service.get_system_specifications
    when 2
      @system_type = @wizard_session.get_data('system_type')
      @system_specs = supabase_service.get_conveyor_systems(system_type: @system_type)
    when 3
      @component_types = supabase_service.get_component_types
    when 4..7
      @component_type = get_component_type_for_step(@step)
      @components = supabase_service.get_components_by_type(@component_type)
    when 8
      @configuration_summary = build_configuration_summary
    end
    
    render "wizard/steps/step_#{@step}"
  end

  def update
    @step = params[:step].to_i
    step_params = params[:wizard_step] || {}
    
    # Validate step data
    if valid_step_data?(@step, step_params)
      @wizard_session.update_step_data(@step, step_params)
      @wizard_session.update(current_step: @step)
      
      # Move to next step or complete
      if @step < TOTAL_STEPS
        redirect_to wizard_step_path(@step + 1)
      else
        redirect_to wizard_summary_path
      end
    else
      @step_data = step_params
      @step_config = STEPS[@step]
      flash.now[:error] = "Please correct the errors below."
      render "wizard/steps/step_#{@step}"
    end
  end

  def summary
    @configuration_summary = build_configuration_summary
    @total_price = calculate_total_price
    @component_count = @wizard_session.component_selections.count
  end

  def complete
    # Create configuration from wizard session
    configuration = current_user.configurations.create!(
      name: @wizard_session.get_data('configuration_name') || "Configuration #{Time.current.strftime('%Y%m%d_%H%M%S')}",
      system_type: @wizard_session.get_data('system_type'),
      status: 'completed',
      total_price: calculate_total_price,
      system_specifications: @wizard_session.get_data('system_specifications'),
      completed_at: Time.current
    )
    
    # Create component selections
    @wizard_session.component_selections.each do |selection_data|
      configuration.component_selections.create!(
        component_id: selection_data['component_id'],
        component_name: selection_data['component_name'],
        component_type: selection_data['component_type'],
        quantity: selection_data['quantity'],
        price: selection_data['price'],
        notes: selection_data['notes']
      )
    end
    
    # Mark wizard session as completed
    @wizard_session.update(status: 'completed')
    
    flash[:success] = "Configuration '#{configuration.name}' completed successfully!"
    redirect_to configuration_path(configuration)
  end

  def reset
    @wizard_session.destroy
    redirect_to root_path, notice: "Configuration wizard reset. You can start a new configuration."
  end

  private

  def ensure_wizard_session
    @wizard_session = current_wizard_session || create_wizard_session
  end

  def create_wizard_session
    current_user.wizard_sessions.create!(
      status: 'active',
      current_step: 1,
      total_steps: TOTAL_STEPS
    )
  end

  def validate_step
    step = params[:step].to_i
    unless STEPS.key?(step)
      redirect_to wizard_step_path(1), alert: "Invalid step."
    end
  end

  def valid_step_data?(step, data)
    case step
    when 1
      data['system_type'].present?
    when 2
      data['system_specifications'].present?
    when 3
      data['component_types'].present? && data['component_types'].is_a?(Array)
    when 4..7
      data['selected_components'].present? && data['selected_components'].is_a?(Array)
    when 8
      data['configuration_name'].present?
    else
      true
    end
  end

  def get_component_type_for_step(step)
    component_types = @wizard_session.get_data('component_types') || []
    component_types[step - 4] # Steps 4-7 correspond to component types 0-3
  end

  def build_configuration_summary
    {
      system_type: @wizard_session.get_data('system_type'),
      system_specifications: @wizard_session.get_data('system_specifications'),
      component_types: @wizard_session.get_data('component_types'),
      component_selections: @wizard_session.component_selections,
      total_price: calculate_total_price
    }
  end

  def calculate_total_price
    @wizard_session.component_selections.sum { |selection| selection['price'] * selection['quantity'] }
  end
end 