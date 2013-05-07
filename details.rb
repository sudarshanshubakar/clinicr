require_relative 'database/database.rb'

class Details
  def initialize
    @db = Database.new
  end
  
  def get(id)
    details = @db.get_patient_details(id)
  end
end