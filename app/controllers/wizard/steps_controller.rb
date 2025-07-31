class Wizard::StepsController < ApplicationController
  before_action :ensure_wizard_session
  before_action :validate_step, only: %i[show update]

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
    @step_data = @wizard_session.get_step_data(@step)
    @step_config = STEPS[@step]

    Rails.logger.info "Showing step #{@step} for wizard session #{@wizard_session.id}"
    Rails.logger.info "Step data: #{@step_data.inspect}"

    # Load data based on step
    case @step
    when 1
      @system_types = get_fallback_system_types
    when 2
      @system_type = @wizard_session.get_data('system_type')
      @system_specs = get_fallback_system_specs(@system_type)
    when 3
      @component_types = get_fallback_component_types
    when 4..7
      @component_type = get_component_type_for_step(@step)
      @components = get_fallback_components(@component_type)
    when 8
      @configuration_summary = build_configuration_summary
    end

    render "wizard/steps/step_#{@step}"
  end

  def update
    Rails.logger.info '=== UPDATE ACTION CALLED ==='
    Rails.logger.info "Params: #{params.inspect}"

    @step = params[:step].to_i
    step_params = params[:wizard_step] || {}

    Rails.logger.info "Wizard update called for step #{@step}"
    Rails.logger.info "Step params: #{step_params.inspect}"

    # Validate step data
    if valid_step_data?(@step, step_params)
      Rails.logger.info 'Step data is valid, updating wizard session'
      @wizard_session.update_step_data(@step, step_params)
      @wizard_session.update(current_step: @step)

      # Move to next step or complete
      if @step < TOTAL_STEPS
        Rails.logger.info "Redirecting to step #{@step + 1}"
        redirect_to wizard_step_path(@step + 1)
      else
        Rails.logger.info 'Redirecting to summary'
        redirect_to wizard_summary_path
      end
    else
      Rails.logger.info "Step data is invalid, re-rendering step #{@step}"
      @step_data = step_params
      @step_config = STEPS[@step]
      flash.now[:error] = 'Please correct the errors below.'
      render "wizard/steps/step_#{@step}"
    end
  rescue StandardError => e
    Rails.logger.error "Error in update action: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise e
  end

  def summary
    @configuration_summary = build_configuration_summary
    @total_price = calculate_total_price
    @component_count = @wizard_session.component_selections.count
  end

  def complete
    # Create configuration from wizard session
    user = User.first
    configuration = user.configurations.create!(
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
    redirect_to root_path, notice: 'Configuration wizard reset. You can start a new configuration.'
  end

  private

  def ensure_wizard_session
    # Temporarily disable authentication for testing
    # unless current_user
    #   redirect_to root_path, alert: "Please log in to access the configuration wizard."
    #   return
    # end

    # Use the first user for testing
    @current_user = User.first
    Rails.logger.info "Current user: #{@current_user.inspect}"

    @wizard_session = current_wizard_session || create_wizard_session
    Rails.logger.info "Wizard session: #{@wizard_session.inspect}"
  end

  def create_wizard_session
    user = User.first
    user.wizard_sessions.create!(
      status: 'active',
      current_step: 1
    )
  rescue StandardError => e
    Rails.logger.error "Failed to create wizard session: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise e
  end

  def validate_step
    Rails.logger.info '=== VALIDATE_STEP CALLED ==='
    Rails.logger.info "Step param: #{params[:step]}"
    step = params[:step].to_i
    Rails.logger.info "Step as integer: #{step}"
    Rails.logger.info "STEPS keys: #{STEPS.keys}"
    if STEPS.key?(step)
      Rails.logger.info 'Step validation passed'
    else
      Rails.logger.info 'Invalid step, redirecting to step 1'
      redirect_to wizard_step_path(1), alert: 'Invalid step.'
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
      component_selections: @wizard_session.get_data('component_selections') || [],
      total_price: calculate_total_price
    }
  end

  def calculate_total_price
    component_selections = @wizard_session.get_data('component_selections') || []
    component_selections.sum { |selection| selection['price'] * selection['quantity'] }
  end

  # Fallback data methods for when Supabase is not available
  def get_fallback_system_types
    {
      'Belt Conveyors' => %w[belt_conveyor modular_belt chain_conveyor],
      'Roller Conveyors' => %w[roller_conveyor gravity_roller powered_roller],
      'Specialty Conveyors' => %w[screw_conveyor pneumatic_conveyor overhead_conveyor]
    }
  end

  def get_fallback_system_specs(system_type)
    [
      {
        'id' => 1,
        'name' => "#{system_type&.humanize} System A",
        'description' => "Standard #{system_type&.humanize} configuration",
        'price' => 2500.00,
        'specifications' => ['Length: 10m', 'Width: 0.5m', 'Speed: 0.5 m/s']
      },
      {
        'id' => 2,
        'name' => "#{system_type&.humanize} System B",
        'description' => "Premium #{system_type&.humanize} configuration",
        'price' => 3500.00,
        'specifications' => ['Length: 15m', 'Width: 0.6m', 'Speed: 0.8 m/s']
      }
    ]
  end

  def get_fallback_component_types
    %w[belt roller motor sensor controller frame accessory]
  end

  def get_fallback_components(component_type)
    [
      {
        'id' => 1,
        'name' => "Standard #{component_type&.humanize}",
        'description' => "High-quality #{component_type&.humanize} component",
        'price' => 150.00,
        'brand' => 'FlexLink',
        'specifications' => ['Material: Steel', 'Size: Standard', 'Quality: Premium'],
        'image_url' => nil
      },
      {
        'id' => 2,
        'name' => "Premium #{component_type&.humanize}",
        'description' => "Premium #{component_type&.humanize} component with advanced features",
        'price' => 250.00,
        'brand' => 'FlexLink',
        'specifications' => ['Material: Stainless Steel', 'Size: Large', 'Quality: Premium'],
        'image_url' => nil
      },
      {
        'id' => 3,
        'name' => "Economy #{component_type&.humanize}",
        'description' => "Cost-effective #{component_type&.humanize} component",
        'price' => 75.00,
        'brand' => 'Generic',
        'specifications' => ['Material: Plastic', 'Size: Standard', 'Quality: Standard'],
        'image_url' => nil
      }
    ]
  end
end
