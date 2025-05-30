#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'optparse'
require_relative 'lib/models/employee'
require_relative 'lib/models/building'
require_relative 'lib/models/assignment'
require_relative 'lib/models/schedule'
require_relative 'lib/presenters/schedule_presenter'
require_relative 'lib/services/scheduling_service'

def load_example_data
  buildings = [
    Building.new(:single_story, "12 Address st"),
    Building.new(:two_story, "22 Address st"),
    Building.new(:commercial, "13 Address st"),
    Building.new(:single_story, "28 Address st"),
    Building.new(:two_story, "43 Address st"),
    Building.new(:commercial, "90 Address st"),
    Building.new(:single_story, "41 Address st"),
    Building.new(:commercial, ""),
    Building.new(:two_story, "99 Address st"),
    Building.new(:single_story, "29 Address st"),
    Building.new(:commercial, "821 Address st"),
    Building.new(:two_story, "354 Address st"),
  ]
  
  employees = [
    Employee.new(:certified, "John", availability: [true, true, true, true, true]),
    Employee.new(:certified, "Sarah", availability: [true, true, false, true, true]),
    Employee.new(:certified, "Mike", availability: [false, true, true, true, false]),
    Employee.new(:pending, "Lisa", availability: [true, false, true, true, true]),
    Employee.new(:pending, "Eduardo", availability: [false, true, true, true, false]),
    Employee.new(:pending, "David", availability: [true, true, true, false, true]),
    Employee.new(:pending, "Emma", availability: [true, true, true, true, false]),
    Employee.new(:laborer, "Tom", availability: [false, true, true, true, true]),
    Employee.new(:laborer, "Anna", availability: [true, true, false, true, true]),
    Employee.new(:laborer, "Chris", availability: [true, false, true, true, true]),
    Employee.new(:laborer, "Jessica", availability: [true, true, true, true, true])
  ]
  
  [buildings, employees]
end

def load_data_from_file(file_path)
  data = JSON.parse(File.read(file_path))
  
  buildings = data["buildings"].map do |b|
    Building.new(b["type"].to_sym, b["name"])
  end
  
  employees = data["employees"].map do |e|
    Employee.new(e["type"].to_sym, e["name"], availability: e["availability"])
  end
  
  [buildings, employees]
end

options = {}
OptionParser.new do |opts|
  opts.on("--data FILE", "Load data from JSON file") do |file|
    options[:data_file] = file
  end
end.parse!

if options[:data_file]
  buildings, employees = load_data_from_file(options[:data_file])
else
  buildings, employees = load_example_data
end

scheduler = SchedulingService.new
result = scheduler.schedule(buildings, employees)

puts result.to_s

