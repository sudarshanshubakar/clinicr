require 'redis'
class Configuration_redis
  def initialize
    @red = Redis.new
  end
  
  def find_add_form_fields
    fields = get_all_from_range("add_patient_form:fields")
    return fields
  end

  def find_history_fields
    fields = get_all_from_range("visit_history:fields")
    return fields
  end

  def get_all_from_range(range_name)
    @red.lrange(range_name, 0, -1)
  end
  
  def find_patient_details_labels
    labels = get_all_from_range("patient_details_form:fields")
  end
  
  def find_search_result_headers
    header_keys = @red.hkeys("patient_search_result:fields")
    result_hash = Hash.new
    header_keys.each do |header_key|
      result_hash[header_key] = @red.hget("patient_search_result:fields", header_key)
    end
    return result_hash
  end

end