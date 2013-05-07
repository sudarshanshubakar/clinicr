require_relative 'database/factory.rb'
class Update_history
  include DB_factory
  def initialize
    @db = db_instance
  end
  
  def do(params)
    id = params["id"]
    date = Time.now.strftime("%d-%b-%Y %I.%M%p")

    history_entry = get_history_entry(params)
    @db.add_history_entry(id, date, history_entry)

  end

  private
  def get_history_entry(params)
    params.delete("id")
    history_entry = params.to_s
    history_entry = history_entry.gsub '=>', ':'
    return history_entry
  end
end