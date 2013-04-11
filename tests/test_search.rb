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

  def test_search_invalid_data
    search = Search.new
    criteria_value = "invalid data"

    search_result = search.search(criteria_value)

    assert_equal(true, search_result.empty?)
  end

end