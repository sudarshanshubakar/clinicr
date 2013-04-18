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
    parsed_result = result[0]
    keys = parsed_result.keys
    keycheck = keys.include?("date") \
            && keys.include?("problem") \
            && keys.include?("diagnosis") \
            && keys.include?("prescription") \
            && keys.include?("notes")
    assert_equal(true, keycheck)
    problem = parsed_result["problem"]
    diagnosis = parsed_result["diagnosis"]
    prescription = parsed_result["prescription"]
    notes = parsed_result["notes"]
    assert_equal("his new problem", problem)
    assert_equal("my new diag", diagnosis)
    assert_equal("my new pres", prescription)
    assert_equal("my new notes", notes)
  end
  
  
end