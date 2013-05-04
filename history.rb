class History
  def initialize
    @entry = Hash.new
  end
  
  def set_entry(entry_name, entry_value)
    @entry[entry_name] = entry_value
  end
  
  def fetch_entry_value(entry_name)
    @entry[entry_name]
  end
  
  def fetch_all_entry_names
    @entry.keys
  end
  
end

class History_converter
  def to_json(history)
    result = ""
    entry_names = history.fetch_all_entry_names
    entry_names.each do |entry_name|
      entry_value = history.fetch_entry_value(entry_name)
      unless result == ""
        result += ","
      else
        result += "{"
      end
      result += "\"#{entry_name}\": \"#{entry_value}\""
    end
    result += "}"
    return result
  end
  
  def json_to_history(json_string)
    hash_history = JSON.parse(json_string)
    history_keys = hash_history.keys
    history = History.new
    history_keys.each do |history_key|
      history.set_entry(history_key, hash_history[history_key])
    end
    return history
  end
end