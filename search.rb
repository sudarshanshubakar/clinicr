require 'redis'
require 'json'
require_relative 'finders.rb'

class Search
 include Detail_finder, Reference_finder
  def initialize
    @redis = Redis.new
  end

  def search(criteria_string)
    result = find_details(criteria_string)# get_result_from_details(criteria_string)
    if (result.empty?)
      result = find_reference(criteria_string)
    end
    puts "RESULT == #{result}"
    return result
  end
end




