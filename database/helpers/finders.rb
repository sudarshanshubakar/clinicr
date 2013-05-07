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
      puts "#{key} === #{value}"
      hash_result = JSON.parse(value)
      hash_result["id"] = key
      matching_values << hash_result
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
      hash_result = JSON.parse(details)
      hash_result["id"] = patient_id
      matching_values << hash_result
    end
    return matching_values
  end
end