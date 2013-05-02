require 'test/unit'
require '/home/sudarshan/work/rubywork/myClinic/update.rb'
require '/home/sudarshan/work/rubywork/myClinic/visit.rb'
require 'redgreen'
require 'json'

class Test_Update_visit < MiniTest::Unit::TestCase

  def test_update
    test_id = "000002"
    params = Hash.new
    params["problem"] = "test_problem"
    params["diagnosis"] = "test_diagnosis"
    params["prescription"] = "test_prescription"
    params["notes"] = "test_notes"
    params["id"] = test_id
    update_visit = Update_history.new
    update_visit.do(params)

    visit = Visit.new
    result = []
    result = visit.get(test_id)
    # parsed_result = JSON.parse(result[0])
    unless result.empty? then
      parsed_result = result[0]
      problem = parsed_result["problem"]
      diagnosis = parsed_result["diagnosis"]
      prescription = parsed_result["prescription"]
      notes = parsed_result["notes"]
      assert_equal("test_problem", problem)
      assert_equal("test_diagnosis", diagnosis)
      assert_equal("test_prescription", prescription)
      assert_equal("test_notes", notes)
    else
      assert(false, "empty result returned")
    end

  end

end