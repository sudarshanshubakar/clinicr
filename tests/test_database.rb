require 'test/unit'
require_relative '../database/factory.rb'
# require 'turn/autorun'
require 'json'

class Test_database < MiniTest::Unit::TestCase
  include DB_factory
  
  def test_user_collection_exists
    @db = db_instance
    assert_equal true, @db.user_collection_exists?
  end
  
end