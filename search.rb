require 'redis'
require 'json'
require_relative 'finders.rb'

class Search
 include Detail_finder, Reference_finder
  def initialize
    @redis = Redis.new
  end

  # get keys from patient:details, patient:reference:phone, patient:reference:name
  # check existence of criteria in each.
  # if exists in patient:details, get the corresponding value and return as a hash
  # if exists in a reference hash, get the corresponding value and
  #  get the data from the patient:details hash and return as a hash
  def search(criteria_string)
    result = find_details(criteria_string)# get_result_from_details(criteria_string)

    if (result.empty?)
      result = find_reference(criteria_string)
    end
    puts "RESULT == #{result}"
    return result

  end

end




