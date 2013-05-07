require_relative 'database/factory.rb'

class Search
  include DB_factory
  def initialize
    @db = db_instance
  end

  def search(criteria_string)
    result = @db.find_patient(criteria_string)
    return result
  end
end




