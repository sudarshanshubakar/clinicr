require 'test/unit'
require '/home/sudarshan/work/rubywork/myClinic/visit.rb'
require 'redgreen'
require 'json'

class Test_details < MiniTest::Unit::TestCase
  def test_get
    visit = Visit.new
    test_id = "000001"
    result = visit.get(test_id)
    # parsed_result = JSON.parse(result[0])
    parsed_result = result.last
    keys = parsed_result.fetch_all_entry_names
    keycheck = keys.include?("date") \
            && keys.include?("problem") \
            && keys.include?("diagnosis") \
            && keys.include?("prescription") \
            && keys.include?("notes")
    assert_equal(true, keycheck)
    problem = parsed_result.fetch_entry_value("problem")
    diagnosis = parsed_result.fetch_entry_value("diagnosis")
    prescription = parsed_result.fetch_entry_value("prescription")
    notes = parsed_result.fetch_entry_value("notes")
    assert_equal("his problem", problem)
    assert_equal("my diag", diagnosis)
    assert_equal("my pres", prescription)
    assert_equal("my notes", notes)
  end
  
  
end