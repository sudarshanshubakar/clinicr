require_relative 'database/database.rb'

class Search
  def initialize
    @db = Database.new
  end

  def search(criteria_string)
    result = @db.find_patient(criteria_string)
    return result
  end
end




