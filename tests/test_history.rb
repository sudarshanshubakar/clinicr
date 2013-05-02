require_relative '../history.rb'
require 'test/unit'
require 'redgreen'
require 'json'

class Test_history < MiniTest::Unit::TestCase
  def test_History_set_entry
    history = History.new
    entry_name = "Test entry"
    entry_value = "Test entry value"
    history.set_entry(entry_name, entry_value)

    assert_equal(entry_value, history.fetch_entry_value(entry_name))

  end

  def test_history_fetch_all_entry_names
    history = History.new
    entry_names = ['one', 'two', 'three', 'four']
    entry_names.each do |entry_name|
      history.set_entry entry_name, entry_names.index(entry_name).to_s
    end

    history_names = history.fetch_all_entry_names

    history_names.each do |history_entry_name|
      assert_equal entry_names.include?(history_entry_name), true
      assert_equal entry_names.index(history_entry_name).to_s,history.fetch_entry_value(history_entry_name)
    end

  end

  def test_history_converter_to_json
    history = History.new
    entry_names = ['one', 'two', 'three', 'four']
    entry_names.each do |entry_name|
      history.set_entry entry_name, entry_names.index(entry_name).to_s
    end

    history_conv = History_converter.new
    json_history = history_conv.to_json(history)

    assert_equal valid_json?(json_history), true

  end

  private
  def valid_json? json_
    puts "#{json_}"
    JSON.parse(json_)
    return true
  rescue JSON::ParserError
    return false
  end

end