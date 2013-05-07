require_relative 'database/factory.rb'
require_relative 'history.rb'
class Visit
  include DB_factory

  def initialize
    @db = db_instance
  end

  def get(id)
    history_entries_db = @db.get_visit_history(id)
    history_entries = []
    history_conv = History_converter.new
    history_entries_db.each do |history_entry_db|
      history_entry_db_values = history_entry_db.split("||")
      history_date = history_entry_db_values[0]
      history_json = history_entry_db_values[1]
      history = history_conv.json_to_history(history_json)
      history.set_entry("date", history_date)
      history_entries << history
    end

    return history_entries
  end
end