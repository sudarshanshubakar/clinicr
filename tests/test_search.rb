require 'test/unit'
require '/home/sudarshan/work/rubywork/myClinic/search.rb'
require 'redgreen'
require 'json'

class Test_search < MiniTest::Unit::TestCase

  def test_search_id
    search = Search.new
    criteria_value = "000001"

    search_result = search.search(criteria_value)

    #correct_result = search_result.has_key?(:name)
    # puts "#{search_result}"
    parsed_result = JSON.parse(search_result[0])
    
    sample_result = parsed_result["name"]
    # puts "sample result = #{sample_result}"
    # puts "HASH = #{eval(sample_result)}"

    assert_equal("myname", sample_result)
  end

  def test_search_phone
    search = Search.new
    criteria_value = "90110"

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