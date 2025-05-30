# frozen_string_literal: true

class Assignment
  attr_reader :day_index, :building, :employees
  
  def initialize(day_index, building, employees)
    @day_index = day_index
    @building = building
    @employees = employees
  end
end

