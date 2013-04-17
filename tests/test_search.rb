require 'test/unit'
require '/home/sudarshan/work/rubywork/myClinic/search.rb'
require 'redgreen'
require 'json'

class Test_search < MiniTest::Unit::TestCase

  def test_search_id
    criteria_value = "000001"
    perform_search_test(criteria_value)
  end

  def test_search_phone
    criteria_value = "90110"
    perform_search_test(criteria_value)
  end

  def test_search_name
    criteria_value = "myname"
    perform_search_test(criteria_value)
  end

  def perform_search_test(criteria_value)
    search = Search.new
    search_result = search.search(criteria_value)
    parsed_result = JSON.parse(search_result[0])
    sample_result = parsed_result["name"]
    assert_equal("myname", sample_result)
  end


  def test_search_invalid_data
    search = Search.new
    criteria_value = "invalid data"
    search_result = search.search(criteria_value)
    assert_equal(true, search_result.empty?)
  end

end