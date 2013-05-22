require_relative 'history.rb'
require_relative 'update.rb'
require_relative '../database/factory.rb'
require_relative 'autogenerator.rb'

class Add_patient
  include DB_factory
  def initialize
    @auto_gen = Auto_generator.new
    @db = db_instance
  end
  
  def do(user_id, params)
    id = @auto_gen.generate_id(user_id)
    
    @db.add_patient user_id, id, params
    
    history_entry = generate_history_entry id
    
    update_history user_id, history_entry

    return id
  end
  
  private
  def generate_history_entry(id)
    history_entry = Hash.new
    history_entry["id"] = id
    history_entry["notes"] = "Added patient. First visit."
    return history_entry
  end
  
  def update_history user_id, history_entry
    update_hist = Update_history.new
    update_hist.do user_id, history_entry
  end
  
end