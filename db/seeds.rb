# Create a default admin user
admin_user = User.find_or_create_by(email: 'admin@flexlink.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.company = 'FlexLink'
  user.phone = '+1-555-0123'
end

puts "Created admin user: #{admin_user.email}"

# Create a sample configuration
sample_config = Configuration.find_or_create_by(name: 'Sample Configuration', user: admin_user) do |config|
  config.description = 'A sample configuration for demonstration purposes'
  config.status = 'draft'
  config.system_specifications = {
    system_type: 'Belt Conveyor',
    length: 10,
    width: 0.5,
    speed: 0.5
  }
end

puts "Created sample configuration: #{sample_config.name}"

# Create sample component selections
if sample_config.component_selections.empty?
  sample_config.component_selections.create!(
    component_type: 'Belt',
    component_id: 'BELT-001',
    component_name: 'Standard Belt',
    specifications: { material: 'PVC', thickness: '2mm' },
    price: 150.00,
    quantity: 1,
    status: 'selected'
  )

  sample_config.component_selections.create!(
    component_type: 'Motor',
    component_id: 'MOTOR-001',
    component_name: '0.5 HP Motor',
    specifications: { power: '0.5 HP', voltage: '230V' },
    price: 450.00,
    quantity: 1,
    status: 'selected'
  )

  puts "Created sample component selections"
end

puts "Database seeding completed!" 