class ConfigurationsController < ApplicationController
  before_action :set_configuration, only: [:show, :edit, :update, :destroy, :export, :duplicate, :status]

  def index
    @configurations = current_user.configurations
      .includes(:component_selections)
      .order(updated_at: :desc)
      .page(params[:page])
      .per(20)
    
    @stats = {
      total: current_user.configurations.count,
      completed: current_user.configurations.completed.count,
      active: current_user.configurations.active.count,
      total_value: current_user.configurations.joins(:component_selections).sum('component_selections.price * component_selections.quantity')
    }
  end

  def show
    @component_selections = @configuration.component_selections.order(:component_type, :created_at)
    @total_price = @configuration.total_price
    @component_count = @component_selections.count
  end

  def new
    @configuration = current_user.configurations.build
  end

  def create
    @configuration = current_user.configurations.build(configuration_params)
    
    if @configuration.save
      redirect_to @configuration, notice: 'Configuration created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @configuration.update(configuration_params)
      redirect_to @configuration, notice: 'Configuration updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @configuration.destroy
    redirect_to configurations_path, notice: 'Configuration deleted successfully.'
  end

  def export
    respond_to do |format|
      format.json do
        render json: @configuration.export_data
      end
      format.pdf do
        # Generate PDF export
        pdf_data = generate_pdf_export(@configuration)
        send_data pdf_data, filename: "#{@configuration.name.parameterize}.pdf", type: 'application/pdf'
      end
      format.csv do
        # Generate CSV export
        csv_data = generate_csv_export(@configuration)
        send_data csv_data, filename: "#{@configuration.name.parameterize}.csv", type: 'text/csv'
      end
    end
  end

  def duplicate
    new_configuration = @configuration.dup
    new_configuration.name = "#{@configuration.name} (Copy)"
    new_configuration.status = 'draft'
    new_configuration.completed_at = nil
    
    if new_configuration.save
      # Duplicate component selections
      @configuration.component_selections.each do |selection|
        new_configuration.component_selections.create!(
          component_id: selection.component_id,
          component_name: selection.component_name,
          component_type: selection.component_type,
          quantity: selection.quantity,
          price: selection.price,
          notes: selection.notes
        )
      end
      
      redirect_to new_configuration, notice: 'Configuration duplicated successfully.'
    else
      redirect_to @configuration, alert: 'Failed to duplicate configuration.'
    end
  end

  def status
    new_status = params[:status]
    
    if %w[draft in_progress completed].include?(new_status)
      @configuration.update(status: new_status)
      redirect_to @configuration, notice: "Configuration status updated to #{new_status.humanize}."
    else
      redirect_to @configuration, alert: 'Invalid status.'
    end
  end

  def templates
    @templates = current_user.configurations.completed.limit(10)
  end

  def from_template
    template = current_user.configurations.find(params[:template_id])
    
    new_configuration = template.dup
    new_configuration.name = "Configuration from #{template.name}"
    new_configuration.status = 'draft'
    new_configuration.completed_at = nil
    
    if new_configuration.save
      # Copy component selections
      template.component_selections.each do |selection|
        new_configuration.component_selections.create!(
          component_id: selection.component_id,
          component_name: selection.component_name,
          component_type: selection.component_type,
          quantity: selection.quantity,
          price: selection.price,
          notes: selection.notes
        )
      end
      
      redirect_to new_configuration, notice: 'Configuration created from template successfully.'
    else
      redirect_to templates_configurations_path, alert: 'Failed to create configuration from template.'
    end
  end

  private

  def set_configuration
    @configuration = current_user.configurations.find(params[:id])
  end

  def configuration_params
    params.require(:configuration).permit(:name, :description, :system_type, :status, :system_specifications)
  end

  def generate_pdf_export(configuration)
    # Simple PDF generation using Prawn or similar
    # This is a placeholder - you'd implement actual PDF generation
    "PDF content for #{configuration.name}"
  end

  def generate_csv_export(configuration)
    require 'csv'
    
    CSV.generate do |csv|
      csv << ['Configuration', configuration.name]
      csv << ['System Type', configuration.system_type]
      csv << ['Status', configuration.status]
      csv << ['Total Price', configuration.total_price]
      csv << []
      csv << ['Component', 'Type', 'Quantity', 'Price', 'Notes']
      
      configuration.component_selections.each do |selection|
        csv << [
          selection.component_name,
          selection.component_type,
          selection.quantity,
          selection.price,
          selection.notes
        ]
      end
    end
  end
end 