# frozen_string_literal: true

class Building
  attr_reader :type, :name, :requirements

  VALID_TYPES = [:single_story, :two_story, :commercial].freeze

  EMPLOYEE_REQUIREMENTS = {
    single_story: {
      certified: 1,
      pending_or_laborer: 0,
      any: 0
    },
    two_story: {
      certified: 1,
      pending_or_laborer: 1,
      any: 0
    },
    commercial: {
      certified: 2,
      pending: 2,
      any: 4
    }
  }.freeze

  def initialize(type, name)
    unless VALID_TYPES.include?(type)
      raise ArgumentError, "invalid building type: #{type}. valid types: #{VALID_TYPES.join(', ')}"
    end

    @type = type
    @name = name
    @requirements = EMPLOYEE_REQUIREMENTS[type]
  end

  def to_s
    "#{@name} (#{@type})"
  end
end

