require_relative '../database/factory.rb'

class Search
  include DB_factory
  def initialize
    @db = db_instance
  end

  def search(user_id, criteria_string)
    result = @db.find_patient(user_id, criteria_string)
    return result
  end
end




