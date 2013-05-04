require_relative 'history.rb'
require_relative 'update.rb'
require_relative 'database.rb'
require_relative 'autogenerator.rb'

class Add_patient
  
  def initialize
    @auto_gen = Auto_generator.new
    @db = Database.new
  end
  
  def do(params)
    id = @auto_gen.generate_id
    
    @db.add_patient id, params
    
    history_entry = generate_history_entry id
    
    update_history history_entry

    return id
  end
  
  private
  def generate_history_entry(id)
    history_entry = Hash.new
    history_entry["id"] = id
    history_entry["notes"] = "Added patient. First visit."
    return history_entry
  end
  
  def update_history history_entry
    update_hist = Update_history.new
    update_hist.do history_entry
  end
  
end