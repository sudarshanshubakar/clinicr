require_relative 'database.rb'

class Auto_generator
  def generate_id
    db = Database.new
    db.generate_id
  end
end