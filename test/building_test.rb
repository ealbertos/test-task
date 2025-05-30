require 'minitest/autorun'
require_relative '../lib/models/building'

class BuildingTest < Minitest::Test
  def test_invalid_type
    assert_raises(ArgumentError) do
      Building.new(:invalid_type, "123 Address st")
    end
  end

  def test_to_string
    building = Building.new(:single_story, "123 Address st")
    assert_equal "123 Address st (single_story)", building.to_s
  end
end

