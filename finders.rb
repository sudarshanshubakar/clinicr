require 'redis'

module Finder
  def get_matching_keys(location, criteria)
    details_keys = @redis.hkeys("patient:#{location}")
    matching_keys = details_keys.grep(/^#{criteria}/)
  end
end


module Detail_finder 
  include Finder
  def find_details(criteria_string)
    matching_keys = get_matching_keys("details", criteria_string)
    matching_values = []
    matching_keys.each do |key|
      value = @redis.hget("patient:details", key)
      matching_values << value
    end
    return matching_values
  end
end

module Reference_finder
  include Finder
  def find_reference(criteria_string)
    matching_keys = get_matching_keys("reference", criteria_string)
    matching_values = []
    matching_keys.each do |key|
      patient_id = @redis.hget("patient:reference", key)
      details = @redis.hget("patient:details", patient_id)
      matching_values << details
    end
    return matching_values
  end
end