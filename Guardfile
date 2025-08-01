# Guardfile for FlexLink Guided Configurator
# More info at https://github.com/guard/guard#readme

# Watch specific directories for changes
directories %w[app config test]

guard :minitest do
  # Rails models and controllers
  watch(%r{^app/models/(.+)\.rb$})                    { |m| "test/models/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/(.+)\.rb$})               { |m| "test/controllers/#{m[1]}_test.rb" }
  watch(%r{^app/services/(.+)\.rb$})                  { |m| "test/services/#{m[1]}_test.rb" }

  # Test files
  watch(%r{^test/(.+)\.rb$})
  watch(%r{^test/test_helper\.rb$})                   { 'test' }

  # Configuration changes
  watch(%r{^config/(.+)\.rb$})                        { 'test' }
  watch(%r{^config/routes\.rb$})                      { 'test' }

  # Database changes
  watch(%r{^db/migrate/(.+)\.rb$})                    { 'test' }
  watch(%r{^db/schema\.rb$})                          { 'test' }
end

# Rails server guard - DISABLED since running in Docker
# guard 'rails' do
#   watch('Gemfile.lock')
#   watch(%r{^(config|app)/.*})
#   watch(%r{^app/.*\.rb$})
#   watch(%r{^db/.*\.rb$})
# end

# RSpec guard (if you decide to use RSpec in the future)
guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w[erb haml slim])
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  watch(rails.controllers) do |m|
    [
      rspec.spec.call("routing/#{m[1]}_routing"),
      rspec.spec.call("controllers/#{m[1]}_controller"),
      rspec.spec.call("acceptance/#{m[1]}")
    ]
  end

  # Rails config changes
  watch(rails.spec_helper)     { rspec.spec_dir }
  watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
  watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

  # Capybara features specs
  watch(rails.view_dirs)     { |m| rspec.spec.call("features/#{m[1]}") }
  watch(rails.layouts)       { |m| rspec.spec.call("features/#{m[1]}") }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance'
  end
end
