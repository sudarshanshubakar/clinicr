require_relative 'database/factory.rb'

class Auto_generator
  include DB_factory
  def generate_id
    db = db_instance
    db.generate_id
  end
end