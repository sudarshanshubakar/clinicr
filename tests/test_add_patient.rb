require 'test/unit'
require_relative '../model/add.rb'
require_relative '../model/details.rb'
#require 'redgreen'
require 'json'

class Test_add_patient < MiniTest::Unit::TestCase

  def test_add
    # require 'debugger'; debugger
    params = Hash.new
    params["name"] = "test_Add_name"
    params["age"] = "test_ADD_age"
    params["previous_history"] = "test_previous_history"
    params["current_problem"] = "test_current_problem"
    
    add_patient = Add_patient.new
    id = add_patient.do(params)

    details = Details.new
    test_id = id
    result = details.get(test_id)
    parsed_result = JSON.parse(result)
    name = parsed_result["name"]
    age = parsed_result["age"]
    previous_history = parsed_result["previous_history"]
    current_problem = parsed_result["current_problem"]
    
    
    assert_equal("test_Add_name", name)
    assert_equal("test_ADD_age", age)
    assert_equal("test_previous_history", previous_history)
    assert_equal("test_current_problem", current_problem)    
  end
  
end