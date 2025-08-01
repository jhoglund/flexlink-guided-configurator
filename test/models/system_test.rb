require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  test 'should create system from hash data' do
    system_data = {
      'id' => 1,
      'system_code' => 'X45',
      'system_name' => 'X45 Chain System',
      'category' => 'Chain Conveyor',
      'description' => 'Compact chain conveyor system',
      'load_capacity' => 'Light duty',
      'speed_range' => 'Up to 20 m/min',
      'key_features' => ['Compact design', 'Space efficient'],
      'applications' => %w[Packaging Assembly],
      'advantages' => ['Low maintenance', 'High reliability'],
      'materials' => ['Aluminium', 'Stainless steel'],
      'technical_specs' => '{"chain_pitch": "45mm"}'
    }

    system = System.new(system_data)

    assert_equal 'X45', system.system_code
    assert_equal 'X45 Chain System', system.system_name
    assert_equal 'Chain Conveyor', system.category
    assert_equal 'Light duty', system.load_capacity
    assert_equal ['Compact design', 'Space efficient'], system.key_features
    assert_equal %w[Packaging Assembly], system.applications
    assert_equal ['Low maintenance', 'High reliability'], system.advantages
    assert_equal ['Aluminium', 'Stainless steel'], system.materials
    assert_equal '{"chain_pitch": "45mm"}', system.technical_specs
  end

  test 'should validate system_code presence' do
    system = System.new
    assert_not system.valid?
    assert_includes system.errors[:system_code], "can't be blank"
  end

  test 'should validate system_name presence' do
    system = System.new
    assert_not system.valid?
    assert_includes system.errors[:system_name], "can't be blank"
  end

  test 'should validate system_code length' do
    system = System.new(system_code: 'X1234567890', system_name: 'Test System')
    assert_not system.valid?
    assert_includes system.errors[:system_code], 'is too long (maximum is 10 characters)'
  end

  test 'should identify light duty systems' do
    system = System.new(load_capacity: 'Light duty')
    assert system.light_duty?
    assert_not system.medium_duty?
    assert_not system.heavy_duty?
  end

  test 'should identify medium duty systems' do
    system = System.new(load_capacity: 'Medium duty')
    assert_not system.light_duty?
    assert system.medium_duty?
    assert_not system.heavy_duty?
  end

  test 'should identify heavy duty systems' do
    system = System.new(load_capacity: 'Heavy duty')
    assert_not system.light_duty?
    assert_not system.medium_duty?
    assert system.heavy_duty?
  end

  test 'should identify chain systems' do
    system = System.new(category: 'Chain Conveyor')
    assert system.chain_system?
    assert_not system.belt_system?
    assert_not system.pallet_system?
  end

  test 'should identify belt systems' do
    system = System.new(category: 'Belt Conveyor')
    assert_not system.chain_system?
    assert system.belt_system?
    assert_not system.pallet_system?
  end

  test 'should identify pallet systems' do
    system = System.new(category: 'Pallet Conveyor')
    assert_not system.chain_system?
    assert_not system.belt_system?
    assert system.pallet_system?
  end

  test 'should generate display name' do
    system = System.new(system_code: 'X45', system_name: 'X45 Chain System')
    assert_equal 'X45 - X45 Chain System', system.display_name
  end

  test 'should generate summary' do
    system = System.new(
      system_code: 'X45',
      system_name: 'X45 Chain System',
      category: 'Chain Conveyor',
      load_capacity: 'Light duty',
      speed_range: 'Up to 20 m/min'
    )

    # Mock the components and images methods to avoid API calls
    def system.components
      []
    end

    def system.images
      []
    end

    summary = system.summary
    assert_equal 'X45', summary[:system_code]
    assert_equal 'X45 Chain System', summary[:system_name]
    assert_equal 'Chain Conveyor', summary[:category]
    assert_equal 'Light duty', summary[:load_capacity]
    assert_equal 'Up to 20 m/min', summary[:speed_range]
    assert_equal 0, summary[:components_count]
    assert_equal 0, summary[:images_count]
  end

  test 'should handle missing technical specs' do
    system = System.new
    assert_equal({}, system.technical_specifications)
  end

  test 'should check for images' do
    system = System.new
    # Mock the images method to return an empty array
    def system.images
      []
    end
    assert_not system.has_images?
  end

  test 'should check for components' do
    system = System.new
    # Mock the components method to return an empty array
    def system.components
      []
    end
    assert_not system.has_components?
  end

  test 'should use system_code as param' do
    system = System.new(system_code: 'X45')
    assert_equal 'X45', system.to_param
  end

  test 'should use system_name as string representation' do
    system = System.new(system_name: 'X45 Chain System')
    assert_equal 'X45 Chain System', system.to_s
  end
end
