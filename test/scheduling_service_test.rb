require 'minitest/autorun'
require_relative '../lib/services/scheduling_service'
require_relative '../lib/models/building'
require_relative '../lib/models/employee'
require_relative '../lib/models/assignment'
require_relative '../lib/models/schedule'
require_relative '../lib/presenters/schedule_presenter'

class SchedulingServiceTest < Minitest::Test
  def setup
    @scheduler = SchedulingService.new
  end

  def test_schedule_single_story
    buildings = [Building.new(:single_story, "123 Address st")]
    employees = [Employee.new(:certified, "John")]
    
    schedule = @scheduler.schedule(buildings, employees)
    assignments = schedule.assignments_for_day(0)
    
    assert_equal 1, assignments.size
    assert_equal "123 Address st", assignments[0].building.name
    assert_equal "John", assignments[0].employees[0].name
    assert_empty schedule.unscheduled_buildings
  end

  def test_schedule_two_story
    buildings = [Building.new(:two_story, "456 Address st")]
    employees = [
      Employee.new(:certified, "John"),
      Employee.new(:pending, "Sarah")
    ]
    
    schedule = @scheduler.schedule(buildings, employees)
    assignments = schedule.assignments_for_day(0)
    
    assert_equal 1, assignments.size
    assert_equal "456 Address st", assignments[0].building.name
    assert_equal 2, assignments[0].employees.size
    assert_empty schedule.unscheduled_buildings
  end

  def test_schedule_commercial
    buildings = [Building.new(:commercial, " 789 Address st")]
    employees = [
      Employee.new(:certified, "John"),
      Employee.new(:pending, "Sarah"),
      Employee.new(:certified, "Mike"),
      Employee.new(:pending, "Lisa"),
      Employee.new(:laborer, "Eduardo"),
      Employee.new(:laborer, "David"),
      Employee.new(:laborer, "Emma"),
      Employee.new(:laborer, "Tom"),
      Employee.new(:laborer, "Anna"),
    ]
    
    schedule = @scheduler.schedule(buildings, employees)
    assignments = schedule.assignments_for_day(0)
    
    assert_equal 1, assignments.size
    assert_equal " 789 Address st", assignments[0].building.name
    assert_equal 8, assignments[0].employees.size
    assert_empty schedule.unscheduled_buildings
  end

  def test_insufficient_employees
    buildings = [Building.new(:commercial, " 789 Address st")]
    employees = [
      Employee.new(:certified, "John"),
      Employee.new(:pending, "Eduardo")
    ]
    
    schedule = @scheduler.schedule(buildings, employees)
    
    assert_empty schedule.assignments_for_day(0)
    assert_equal 1, schedule.unscheduled_buildings.size
    assert_equal " 789 Address st", schedule.unscheduled_buildings[0].name
  end

  def test_employee_unavailability
    buildings = [Building.new(:single_story, "123 Address st")]
    employees = [
      Employee.new(:certified, "John", availability: [false, true, true, true, true])
    ]
    
    schedule = @scheduler.schedule(buildings, employees)
    
    assert_empty schedule.assignments_for_day(0)
    assert_equal 1, schedule.assignments_for_day(1).size
    assert_equal "123 Address st", schedule.assignments_for_day(1)[0].building.name
    assert_empty schedule.unscheduled_buildings
  end

  def test_multiple_buildings_priority_order
    buildings = [
      Building.new(:single_story, "123 Address st"),
      Building.new(:two_story, "456 Address st")
    ]
    
    employees = [
      Employee.new(:certified, "John"),
      Employee.new(:pending, "Sarah"),
      Employee.new(:certified, "Mike")
    ]
    
    schedule = @scheduler.schedule(buildings, employees)
    
    assert_equal 2, schedule.assignments_for_day(0).size
    assert_equal "123 Address st", schedule.assignments_for_day(0)[0].building.name
    assert_equal "456 Address st", schedule.assignments_for_day(0)[1].building.name
  end

  def test_not_enough_days
    buildings = []
    6.times { |i| buildings << Building.new(:commercial, "Commercial #{i}") }
    
    employees = []
    2.times { |i| employees << Employee.new(:certified, "Certified #{i}") }
    2.times { |i| employees << Employee.new(:pending, "Pending #{i}") }
    4.times { |i| employees << Employee.new(:laborer, "Laborer #{i}") }
    
    schedule = @scheduler.schedule(buildings, employees)
    
    assert_equal 1, schedule.assignments_for_day(0).size
    assert_equal 1, schedule.assignments_for_day(1).size
    assert_equal 1, schedule.assignments_for_day(2).size
    assert_equal 1, schedule.assignments_for_day(3).size
    assert_equal 1, schedule.assignments_for_day(4).size
    assert_equal 1, schedule.unscheduled_buildings.size
  end
end

