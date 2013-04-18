require 'test/unit'
require '/home/sudarshan/work/rubywork/myClinic/details.rb'
require 'redgreen'
require 'json'

class Test_details < MiniTest::Unit::TestCase
  def test_get
    details = Details.new
    test_id = "000001"
    result = details.get(test_id)
    parsed_result = JSON.parse(result)
    keys = parsed_result.keys
    keycheck = keys.include?("name") && keys.include?("id") && keys.include?("age")
    assert_equal(true, keycheck)
    name = parsed_result["name"]
    age = parsed_result["age"]
    id = parsed_result["id"]
    
    assert_equal("myname", name)
    assert_equal("31", age)
    assert_equal("000001", id)
  end
  
  
end