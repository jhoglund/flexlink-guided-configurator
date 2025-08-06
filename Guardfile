# Guardfile for FlexLink Guided Configurator - Auto-reload only
# More info at https://github.com/guard/guard#readme

# LiveReload guard for auto-reloading browser
guard :livereload do
  # Rails views
  watch(%r{app/views/.+\.erb})
  watch(%r{app/helpers/.+\.rb})

  # Assets
  watch(%r{app/assets/.+\.(css|js)})
  watch(%r{app/assets/images/.+\.(png|jpg|jpeg|gif|svg)})

  # Controllers and models
  watch(%r{app/controllers/.+\.rb})
  watch(%r{app/models/.+\.rb})

  # Configuration
  watch(%r{config/locales/.+\.yml})
  watch(%r{config/routes\.rb})
  watch(%r{config/application\.rb})

  # Layouts
  watch(%r{app/views/layouts/.+\.erb})
end
