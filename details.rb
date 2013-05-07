require_relative 'database/factory.rb'

class Details
  include DB_factory
  def initialize
    @db = db_instance
  end
  
  def get(id)
    details = @db.get_patient_details(id)
  end
end