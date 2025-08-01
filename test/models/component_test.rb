require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  test 'should create component from hash data' do
    component_data = {
      'id' => 1,
      'system_code' => 'X45',
      'component_type' => 'chain',
      'name' => 'X45 Chain Link',
      'specifications' => '{"pitch": "45mm", "width": "45mm"}',
      'compatibility' => %w[X45 XS],
      'price' => 150.00,
      'currency' => 'USD',
      'description' => 'High-quality chain link',
      'manufacturer' => 'FlexLink',
      'part_number' => 'XL45-001',
      'dimensions' => '{"length": 100, "width": 50, "height": 25}',
      'weight' => 0.5,
      'material' => 'Stainless Steel',
      'color' => 'Silver'
    }

    component = Component.new(component_data)

    assert_equal 1, component.id
    assert_equal 'X45', component.system_code
    assert_equal 'chain', component.component_type
    assert_equal 'X45 Chain Link', component.name
    assert_equal '{"pitch": "45mm", "width": "45mm"}', component.specifications
    assert_equal %w[X45 XS], component.compatibility
    assert_equal 150.00, component.price
    assert_equal 'USD', component.currency
    assert_equal 'High-quality chain link', component.description
    assert_equal 'FlexLink', component.manufacturer
    assert_equal 'XL45-001', component.part_number
    assert_equal '{"length": 100, "width": 50, "height": 25}', component.dimensions
    assert_equal 0.5, component.weight
    assert_equal 'Stainless Steel', component.material
    assert_equal 'Silver', component.color
  end

  test 'should validate required fields' do
    component = Component.new
    assert_not component.valid?
    assert_includes component.errors[:system_code], "can't be blank"
    assert_includes component.errors[:component_type], "can't be blank"
    assert_includes component.errors[:name], "can't be blank"
  end

  test 'should validate system_code length' do
    component = Component.new(
      system_code: 'X1234567890',
      component_type: 'chain',
      name: 'Test Component'
    )
    assert_not component.valid?
    assert_includes component.errors[:system_code], 'is too long (maximum is 10 characters)'
  end

  test 'should validate price is non-negative' do
    component = Component.new(
      system_code: 'X45',
      component_type: 'chain',
      name: 'Test Component',
      price: -10
    )
    assert_not component.valid?
    assert_includes component.errors[:price], 'must be greater than or equal to 0'
  end

  test 'should format price correctly' do
    component = Component.new(price: 150.00, currency: 'USD')
    assert_equal '$150.00', component.price_formatted

    component = Component.new(price: nil)
    assert_equal 'N/A', component.price_formatted
  end

  test 'should format weight correctly' do
    component = Component.new(weight: 0.5)
    assert_equal '0.5 kg', component.weight_formatted

    component = Component.new(weight: nil)
    assert_equal 'N/A', component.weight_formatted
  end

  test 'should format dimensions correctly' do
    component = Component.new(
      dimensions: '{"length": 100, "width": 50, "height": 25}'
    )
    assert_equal '100 × 50 × 25 mm', component.dimensions_formatted

    component = Component.new(dimensions: '{"length": 100, "width": 50}')
    assert_equal '100 × 50 mm', component.dimensions_formatted

    component = Component.new(dimensions: '{}')
    assert_equal 'See specifications', component.dimensions_formatted

    component = Component.new(dimensions: nil)
    assert_equal 'N/A', component.dimensions_formatted
  end

  test 'should format specifications correctly' do
    component = Component.new(
      specifications: '{"pitch": "45mm", "width": "45mm", "material": "Steel"}'
    )
    assert_equal 'Pitch: 45mm, Width: 45mm, Material: Steel', component.specifications_formatted

    component = Component.new(specifications: '{}')
    assert_equal '', component.specifications_formatted

    component = Component.new(specifications: nil)
    assert_equal 'N/A', component.specifications_formatted
  end

  test 'should identify component types' do
    component = Component.new(component_type: 'chain')
    assert component.chain_component?
    assert_not component.drive_component?

    component = Component.new(component_type: 'drive_unit')
    assert component.drive_component?
    assert_not component.chain_component?

    component = Component.new(component_type: 'motor')
    assert component.motor_component?

    component = Component.new(component_type: 'sensor')
    assert component.sensor_component?

    component = Component.new(component_type: 'frame')
    assert component.frame_component?

    component = Component.new(component_type: 'accessory')
    assert component.accessory_component?

    component = Component.new(component_type: 'belt')
    assert component.belt_component?

    component = Component.new(component_type: 'roller')
    assert component.roller_component?

    component = Component.new(component_type: 'controller')
    assert component.controller_component?
  end

  test 'should check for price' do
    component = Component.new(price: 150.00)
    assert component.has_price?

    component = Component.new(price: nil)
    assert_not component.has_price?

    component = Component.new(price: 0)
    assert_not component.has_price?
  end

  test 'should check for specifications' do
    component = Component.new(specifications: '{"pitch": "45mm"}')
    assert component.has_specifications?

    component = Component.new(specifications: '{}')
    assert_not component.has_specifications?

    component = Component.new(specifications: nil)
    assert_not component.has_specifications?
  end

  test 'should check for dimensions' do
    component = Component.new(dimensions: '{"length": 100}')
    assert component.has_dimensions?

    component = Component.new(dimensions: '{}')
    assert_not component.has_dimensions?

    component = Component.new(dimensions: nil)
    assert_not component.has_dimensions?
  end

  test 'should check for weight' do
    component = Component.new(weight: 0.5)
    assert component.has_weight?

    component = Component.new(weight: nil)
    assert_not component.has_weight?

    component = Component.new(weight: 0)
    assert_not component.has_weight?
  end

  test 'should generate display name' do
    component = Component.new(name: 'Chain Link', part_number: 'XL45-001')
    assert_equal 'Chain Link (XL45-001)', component.display_name

    component = Component.new(name: 'Chain Link', part_number: nil)
    assert_equal 'Chain Link', component.display_name
  end

  test 'should generate summary' do
    component = Component.new(
      id: 1,
      name: 'Chain Link',
      component_type: 'chain',
      system_code: 'X45',
      price: 150.00,
      manufacturer: 'FlexLink',
      part_number: 'XL45-001'
    )

    summary = component.summary
    assert_equal 1, summary[:id]
    assert_equal 'Chain Link', summary[:name]
    assert_equal 'chain', summary[:component_type]
    assert_equal 'X45', summary[:system_code]
    assert_equal '$150.00', summary[:price]
    assert_equal 'FlexLink', summary[:manufacturer]
    assert_equal 'XL45-001', summary[:part_number]
  end

  test 'should generate detailed info' do
    component = Component.new(
      id: 1,
      name: 'Chain Link',
      component_type: 'chain',
      system_code: 'X45',
      description: 'High-quality chain link',
      price: 150.00,
      manufacturer: 'FlexLink',
      part_number: 'XL45-001',
      dimensions: '{"length": 100, "width": 50}',
      weight: 0.5,
      material: 'Stainless Steel',
      color: 'Silver',
      specifications: '{"pitch": "45mm"}',
      compatibility: %w[X45 XS]
    )

    details = component.detailed_info
    assert_equal 1, details[:id]
    assert_equal 'Chain Link', details[:name]
    assert_equal 'chain', details[:component_type]
    assert_equal 'X45', details[:system_code]
    assert_equal 'High-quality chain link', details[:description]
    assert_equal '$150.00', details[:price]
    assert_equal 'FlexLink', details[:manufacturer]
    assert_equal 'XL45-001', details[:part_number]
    assert_equal '100 × 50 mm', details[:dimensions]
    assert_equal '0.5 kg', details[:weight]
    assert_equal 'Stainless Steel', details[:material]
    assert_equal 'Silver', details[:color]
    assert_equal 'Pitch: 45mm', details[:specifications]
    assert_equal %w[X45 XS], details[:compatibility]
  end

  test 'should use id as param' do
    component = Component.new(id: 123)
    assert_equal '123', component.to_param
  end

  test 'should use name as string representation' do
    component = Component.new(name: 'Chain Link')
    assert_equal 'Chain Link', component.to_s
  end
end
