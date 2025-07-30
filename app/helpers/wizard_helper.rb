module WizardHelper
  def get_system_type_description(system_type)
    descriptions = {
      'belt_conveyor' => 'Standard belt conveyor system for general material handling',
      'roller_conveyor' => 'Roller-based system for heavy-duty applications',
      'chain_conveyor' => 'Chain-driven system for high-capacity operations',
      'screw_conveyor' => 'Screw-based system for bulk material handling',
      'pneumatic_conveyor' => 'Air-powered system for fine material transport',
      'modular_belt' => 'Modular plastic belt system for food and packaging',
      'overhead_conveyor' => 'Suspended system for space-efficient transport',
      'vertical_conveyor' => 'Lift system for multi-level operations'
    }
    
    descriptions[system_type] || 'Custom conveyor system configuration'
  end

  def wizard_progress_percentage(current_step, total_steps = 8)
    ((current_step.to_f / total_steps) * 100).round
  end

  def wizard_step_title(step)
    titles = {
      1 => 'System Type Selection',
      2 => 'System Specifications',
      3 => 'Component Type Selection',
      4 => 'Component Selection 1',
      5 => 'Component Selection 2',
      6 => 'Component Selection 3',
      7 => 'Component Selection 4',
      8 => 'Review and Complete'
    }
    
    titles[step] || "Step #{step}"
  end

  def wizard_step_description(step)
    descriptions = {
      1 => 'Choose the type of conveyor system you want to configure',
      2 => 'Specify the system parameters and requirements',
      3 => 'Select the types of components you need',
      4 => 'Choose the first component type',
      5 => 'Choose the second component type',
      6 => 'Choose the third component type',
      7 => 'Choose the fourth component type',
      8 => 'Review your configuration and complete the setup'
    }
    
    descriptions[step] || "Complete step #{step}"
  end

  def component_type_display_name(component_type)
    component_type.humanize.gsub('_', ' ')
  end

  def format_price(price)
    number_to_currency(price, unit: '$', precision: 2)
  end

  def format_quantity(quantity)
    quantity.to_i == quantity ? quantity.to_i : quantity
  end

  def wizard_navigation_links(current_step)
    links = []
    
    if current_step > 1
      links << link_to("← Previous", wizard_step_path(current_step - 1), class: "btn btn-outline-secondary")
    end
    
    if current_step < 8
      links << link_to("Next →", wizard_step_path(current_step + 1), class: "btn btn-primary")
    end
    
    links.join(' ').html_safe
  end

  def wizard_breadcrumb(current_step)
    steps = (1..8).map do |step|
      if step < current_step
        content_tag(:span, step, class: "breadcrumb-step completed")
      elsif step == current_step
        content_tag(:span, step, class: "breadcrumb-step current")
      else
        content_tag(:span, step, class: "breadcrumb-step")
      end
    end
    
    content_tag(:div, steps.join.html_safe, class: "wizard-breadcrumb")
  end
end 