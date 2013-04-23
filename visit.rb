require 'redis'
class Visit

  def get(id)
    redis = Redis.new
    history_references = redis.zrevrange("visit_history:#{id}", 0, -1)
    history_entries = []
    puts "#{history_references}"
    history_references.each do |hist_ref_id|
      date = hist_ref_id.split(":")[2]
      history_value = redis.get(hist_ref_id)
      if (valid_json? history_value)
        hash_history = JSON.parse(history_value)
        hash_history["date"] = date
        history_entries << hash_history
      else
        history = Hash.new
        history["date"] = date
        history["Start"] = history_value
      end
    end

    return history_entries
  end

  def valid_json?(json_string)
    JSON.parse(json_string)
    return true
  rescue JSON::ParserError
    return false
  end

end