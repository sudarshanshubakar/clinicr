require 'redis'
class Visit

  def get(id)

    redis = Redis.new
    history_references = redis.zrevrange("visit_history:#{id}", 0, -1)
    history_entries = []
    history_references.each do |hist_ref_id|
      hash_history = JSON.parse(redis.get(hist_ref_id))
      date = hist_ref_id.split(":")[2]
      hash_history["date"] = date
      history_entries << hash_history
    end

    return history_entries
  end

end