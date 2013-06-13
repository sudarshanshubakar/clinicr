module Setup
  @@visit_history_fields = ["problem:Problem", "diagnosis:Diagnosis", "prescription:Prescription", "notes:Notes", "date:Date"]
  @@add_patient_form_fields = ["name:Name", "age:Age", "contact:Contact", "notes:Notes"]
  @@patient_details_form_fields = ["name:Name", "age:Age", "contact:Contact", "notes:Notes"]
  def setup_user(id)
    @redis.rpush "#{id}:visit_history:fields", @@visit_history_fields
    @redis.rpush "#{id}:add_patient_form:fields", @@add_patient_form_fields
    @redis.rpush "#{id}:patient_details_form:fields", @@patient_details_form_fields
    patient_search_result_fields = Hash.new
    patient_search_result_fields["name"] = "Name"
    patient_search_result_fields["age"] = "Age"
    patient_search_result_fields["contact"] = "Contact"
    patient_search_result_fields["id"] = "Patient Id"
    @redis.mapped_hmset("#{id}:patient_search_result:fields", patient_search_result_fields)
  end
end