# frozen_string_literal: true

class Schedule
  DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"].freeze
  
  attr_reader :unscheduled_buildings
  
  def initialize
    @assignments = Array.new(5) { [] }
    @unscheduled_buildings = []
  end
  
  def add_assignment(assignment)
    @assignments[assignment.day_index] << assignment
  end
  
  def assignments_for_day(day_index)
    @assignments[day_index]
  end
  
  def add_unscheduled_building(building)
    @unscheduled_buildings << building
  end
  
  def to_s
    SchedulePresenter.new(self).to_text
  end
end

