require_relative 'database/factory.rb'

class Details
  include DB_factory
  def initialize
    @db = db_instance
  end
  
  def get(user_id, patient_id)
    details = @db.get_patient_details(user_id, patient_id)
  end
end