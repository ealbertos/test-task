require 'minitest/autorun'
require_relative '../lib/models/employee'

class EmployeeTest < Minitest::Test
  def test_employee_creation
    availability = [true, false, true, false, true]
    employee = Employee.new(:pending, "EDuardo", availability: availability)
    assert_equal availability, employee.availability
  end

  def test_invalid_type
    assert_raises(ArgumentError) do
      Employee.new(:invalid_type, "John")
    end
  end

  def test_invalid_availability_length
    assert_raises(ArgumentError) do
      Employee.new(:certified, "John", availability: [true, false, true])
    end
  end

  def test_available_on
    availability = [true, false, true, false, true]
    employee = Employee.new(:laborer, "Tom", availability: availability)
    
    assert employee.available_on?(0)
    refute employee.available_on?(1)
    assert employee.available_on?(2)
    refute employee.available_on?(3)
    assert employee.available_on?(4)
  end

  def test_to_string
    employee = Employee.new(:certified, "John")
    assert_equal "John (certified)", employee.to_s
  end
end

