require File.join(File.dirname(__FILE__),'..', 'clinicr_server.rb')
require File.join(File.dirname(__FILE__),'../model', 'search.rb')
require File.join(File.dirname(__FILE__),'../database', 'factory.rb')

class Search_patient_routes < Clinicr_base
  include Config_factory

  post '/performSearch' do
    user_id = "test_id"
    search_criteria = params[:search_field]
    # @result_for_display = perform_search(search_criteria)

    @headers = []
    @no_search_result = false
    @result_for_display = perform_search(user_id, search_criteria)
    puts "seearch result = #{@result_for_display}"
    if @result_for_display.empty? then
      @no_search_result = true
    else
      @headers = get_search_result_headers(user_id)
    end
    puts "search headers == #{@headers}"

    erb :search_result
  end


  private
  def perform_search(user_id, search_criteria)
    search = Search.new
    search_result = search.search(user_id, search_criteria)
    result_for_display = []
    if (search_result != nil)
      search_result.each do |result|
        result_for_display << result
      end
    end
    return result_for_display
  end

  def get_search_result_headers(user_id)
    config_instance.find_search_result_headers(user_id)
  end

end