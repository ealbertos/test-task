# frozen_string_literal: true

require_relative '../models/schedule'
require_relative '../models/assignment'

class SchedulingService
  def schedule(buildings, employees)
    schedule = Schedule.new
    remaining_buildings = buildings.dup
    
    5.times do |day_index|
      available_employees = employees.select { |e| e.available_on?(day_index) }
      remaining_employees = available_employees.dup
      
      remaining_buildings.dup.each do |building|
        assigned_employees = assign_employees_to_building(building, remaining_employees)
        
        if assigned_employees
          assignment = Assignment.new(day_index, building, assigned_employees)
          schedule.add_assignment(assignment)
          assigned_employees.each { |e| remaining_employees.delete(e) }
          remaining_buildings.delete(building)
        end
      end
    end
    
    remaining_buildings.each { |b| schedule.add_unscheduled_building(b) }
    
    schedule
  end
  
  private
  
  def assign_employees_to_building(building, available_employees)
    case building.type
    when :single_story
      assign_to_single_story(building, available_employees)
    when :two_story
      assign_to_two_story(building, available_employees)
    when :commercial
      assign_to_commercial(building, available_employees)
    end
  end
  
  def assign_to_single_story(building, available_employees)
    certified = available_employees.select(&:certified?).first
    
    return nil unless certified
    
    [certified]
  end
  
  def assign_to_two_story(building, available_employees)
    certified = available_employees.select(&:certified?).first
    pending_or_laborer = available_employees.find { |e| e.pending? || e.laborer? }
    
    return nil unless certified && pending_or_laborer
    
    [certified, pending_or_laborer]
  end
  
  def assign_to_commercial(building, available_employees)
    certified = available_employees.select(&:certified?).take(2)
    remaining = available_employees - certified
    
    return nil if certified.size < 2
    
    pending = remaining.select(&:pending?).take(2)
    remaining = remaining - pending
    
    return nil if pending.size < 2
    
    any_type = remaining.take(4)
    
    return nil if any_type.size < 4
    
    certified + pending + any_type
  end
end

