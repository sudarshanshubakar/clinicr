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

end