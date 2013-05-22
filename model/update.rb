require_relative '../database/factory.rb'

class Update_patient
  include DB_factory
  def initialize
    @db = db_instance
  end
  
  def do(user_id, params)
    patient_id = params['id']
    params.delete("id")
    @db.update_patient(user_id, patient_id, params)
    "#{patient_id}"
  end
  
end



class Update_history
  include DB_factory
  def initialize
    @db = db_instance
  end
  
  def do(user_id, params)
    id = params["id"]
    date = Time.now.strftime("%d-%b-%Y %I.%M%p")

    history_entry = form_history_entry(params)
    @db.add_history_entry(user_id, id, date, history_entry)

  end

  private
  def form_history_entry(params)
    params.delete("id")
    history_entry = params.to_s
    history_entry = history_entry.gsub '=>', ':'
    return history_entry
  end
end