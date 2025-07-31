require 'test_helper'

class BasicTest < ActiveSupport::TestCase
  test 'should create system from data' do
    system_data = {
      'system_code' => 'X45',
      'system_name' => 'X45 Chain System',
      'category' => 'Chain Conveyor',
      'load_capacity' => 'Light duty'
    }

    system = System.new(system_data)
    assert_equal 'X45', system.system_code
    assert_equal 'X45 Chain System', system.system_name
    assert_equal 'Chain Conveyor', system.category
    assert_equal 'Light duty', system.load_capacity
  end

  test 'should create component from data' do
    component_data = {
      'system_code' => 'X45',
      'component_type' => 'chain',
      'name' => 'X45 Chain Link',
      'price' => 150.00
    }

    component = Component.new(component_data)
    assert_equal 'X45', component.system_code
    assert_equal 'chain', component.component_type
    assert_equal 'X45 Chain Link', component.name
    assert_equal 150.00, component.price
  end

  test 'should validate system required fields' do
    system = System.new
    assert_not system.valid?
    assert_includes system.errors[:system_code], "can't be blank"
    assert_includes system.errors[:system_name], "can't be blank"
  end

  test 'should validate component required fields' do
    component = Component.new
    assert_not component.valid?
    assert_includes component.errors[:system_code], "can't be blank"
    assert_includes component.errors[:component_type], "can't be blank"
    assert_includes component.errors[:name], "can't be blank"
  end

  test 'should format component price' do
    component = Component.new(price: 150.00, currency: 'USD')
    assert_equal '$150.00', component.price_formatted
  end

  test 'should identify system types' do
    system = System.new(load_capacity: 'Light duty')
    assert system.light_duty?
    assert_not system.heavy_duty?
  end

  test 'should identify component types' do
    component = Component.new(component_type: 'chain')
    assert component.chain_component?
    assert_not component.drive_component?
  end
end
