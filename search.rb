require 'redis'
require 'json'
class Search

  def initialize
    @redis = Redis.new
  end
  
  # def search(criteria_string)
  #   result = Hash.new
  # end

  # get keys from patient:details, patient:reference:phone, patient:reference:name
  # check existence of criteria in each.
  # if exists in patient:details, get the corresponding value and return as a hash
  # if exists in a reference hash, get the corresponding value and 
  #  get the data from the patient:details hash and return as a hash
  def search(criteria_string)
    result = get_result_from_details(criteria_string)
    
    if (result.empty?)
      result = get_result_from_reference(criteria_string)
    end
    puts "RESULT == #{result}"
    return result
    
   end
  
  def get_result_from_details(criteria_string)
    details_keys = @redis.hkeys("patient:details")
    puts "details_keys == #{details_keys}"
    # match_string = "/^#{criteria_string}$/"
    # puts "match_string == #{match_string}"
    matching_keys = details_keys.grep(/^#{criteria_string}/)
    puts "matching_keys == #{matching_keys}"
    matching_values = []
    matching_keys.each do |key|
      value = @redis.hget("patient:details", key)
      #matching_values << JSON.parse(value)
      matching_values << value
    end
    puts "matching_values == #{matching_values}"
    return matching_values
  end
    
  
  def get_result_from_reference(criteria_string)
    reference_keys = @redis.hkeys("patient:reference")
    matching_keys = reference_keys.grep(/^#{criteria_string}/)
    matching_values = []
    matching_keys.each do |key|
      patient_id = @redis.hget("patient:reference", key)
      details = @redis.hget("patient:details", patient_id)
      matching_values << details
    end
    return matching_values
    
  end
  
  
 end