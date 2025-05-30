require 'minitest/autorun'
require_relative '../lib/models/schedule'
require_relative '../lib/models/building'
require_relative '../lib/models/employee'
require_relative '../lib/models/assignment'
require_relative '../lib/presenters/schedule_presenter'

class ScheduleTest < Minitest::Test
  def setup
    @schedule = Schedule.new
    @building = Building.new(:single_story, "123 Main St")
    @employee = Employee.new(:certified, "Eduardo")
    @assignment = Assignment.new(0, @building, [@employee])
  end

  def test_add_assignment
    @schedule.add_assignment(@assignment)
    
    assert_equal [@assignment], @schedule.assignments_for_day(0)
    assert_empty @schedule.assignments_for_day(1)
  end

  def test_add_unscheduled_building
    @schedule.add_unscheduled_building(@building)
    
    assert_equal [@building], @schedule.unscheduled_buildings
  end
end

