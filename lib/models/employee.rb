# frozen_string_literal: true

class Employee
  attr_reader :type, :name, :availability

  VALID_TYPES = [:certified, :pending, :laborer].freeze

  def initialize(type, name, availability: Array.new(5, true))
    unless VALID_TYPES.include?(type)
      raise ArgumentError, "invalid employee type: #{type}. valid types: #{VALID_TYPES.join(', ')}"
    end

    unless availability.size == 5
      raise ArgumentError, "availability must be for 5 days"
    end

    @type = type
    @name = name
    @availability = availability
  end

  def available_on?(day_index)
    @availability[day_index]
  end

  def certified?
    @type == :certified
  end

  def pending?
    @type == :pending
  end

  def laborer?
    @type == :laborer
  end

  def to_s
    "#{@name} (#{@type})"
  end
end

