class DevController < ApplicationController
  layout 'grid', only: %i[grid misc cutout_test]

  def grid; end

  def misc; end

  def cutout_test; end

  # Handle dynamic routes for any dev/[testpage]
  def show
    testpage = params[:testpage]
    view_path = Rails.root.join('app', 'views', 'dev', "#{testpage}.html.erb")

    if File.exist?(view_path)
      render testpage
    else
      # If view doesn't exist, render a 404 or redirect
      render plain: "Development page '#{testpage}' not found", status: :not_found
    end
  end

  # Dynamic routing for any dev/[testpage] URL
  def method_missing(method_name, *args, &block)
    # Check if the method name corresponds to a view file
    view_path = Rails.root.join('app', 'views', 'dev', "#{method_name}.html.erb")

    if File.exist?(view_path)
      # Render the view if it exists
      render method_name.to_s
    else
      # Call super to handle the method_missing properly
      super
    end
  end

  # Ensure respond_to works with dynamic methods
  def respond_to_missing?(method_name, include_private = false)
    view_path = Rails.root.join('app', 'views', 'dev', "#{method_name}.html.erb")
    File.exist?(view_path) || super
  end
end
