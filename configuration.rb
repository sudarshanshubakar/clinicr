require 'redis'
module Configuration
  Red = Redis.new

  def find_add_form_fields
    fields = get_all_from_range("add_patient_form:fields")
    return fields
  end
  
  def find_history_fields
    fields = get_all_from_range("visit_history:fields")
    return fields
  end
  
  def get_all_from_range(range_name)
    Red.lrange(range_name, 0, -1)
  end
  
end