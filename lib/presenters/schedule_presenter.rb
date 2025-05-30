# frozen_string_literal: true

class SchedulePresenter
  def initialize(schedule)
    @schedule = schedule
  end
  
  def to_text
    result = ""
    
    Schedule::DAYS.each_with_index do |day, index|
      result += "-- #{day} --\n"
      
      assignments = @schedule.assignments_for_day(index)
      if assignments.empty?
        result += "  no installations scheduled\n"
      else
        assignments.each do |assignment|
          result += "  #{assignment.building}\n"
          result += "    employees: #{assignment.employees.map(&:to_s).join(', ')}\n"
        end
      end
      
      result += "\n"
    end
    
    unless @schedule.unscheduled_buildings.empty?
      result += "-- Unscheduled Buildings --\n"
      @schedule.unscheduled_buildings.each do |building|
        result += "  #{building}\n"
      end
    end
    
    result
  end
end

