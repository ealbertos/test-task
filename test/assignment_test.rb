require 'minitest/autorun'
require_relative '../lib/models/assignment'
require_relative '../lib/models/building'
require_relative '../lib/models/employee'
require_relative '../lib/models/schedule'

class AssignmentTest < Minitest::Test
  def setup
    @building = Building.new(:single_story, "123 Address st")
    @employee = Employee.new(:certified, "Eduardo")
    @assignment = Assignment.new(0, @building, [@employee])
  end
end

