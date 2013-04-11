require 'test/unit'
require '/home/sudarshan/work/rubywork/myClinic/search.rb'
require 'redgreen'

class Test_search < MiniTest::Unit::TestCase
  
  def test_search
    search = Search.new
    criteria_value = "test_criteria"
    
    search_result = search.search(criteria_value)
    
    correct_result = search_result.has_key?(:name)
    
    assert_equal(true, correct_result)
  end
end