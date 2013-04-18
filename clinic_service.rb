require 'sinatra'
require '/home/sudarshan/work/rubywork/myClinic/search.rb'
require '/home/sudarshan/work/rubywork/myClinic/details.rb'
require '/home/sudarshan/work/rubywork/myClinic/visit.rb'
require 'json'

######## Routes
get '/myClinic/getSearchForm' do
  erb :search_form
end

get '/myClinic/getUpdateHistoryForm' do
  fields = params["fields"]
  @fields_array = fields.split("!")
  @fields_array.delete("date")
  puts "fields #{fields}"
  erb :update_history_form
end

post '/myClinic/search' do
  search_criteria = params[:search_field]
  @result_for_display = perform_search(search_criteria)
  erb :search_result
end

get '/myClinic' do
  erb :home
end

get '/myClinic/details' do
  @id = params[:id]
  @details_for_display = get_details(@id)
  erb :details_page
end

get '/myClinic/visitHistory' do
  @id = params[:id]
  @history_headers = []
  @no_history = false
  @visit_history_for_display = get_visit_history(@id)
  if @visit_history_for_display.empty? then
    @no_history = true
  else
    @history_headers = @visit_history_for_display[0].keys
  end
  puts "history headers == #{@history_headers}"
  erb :visit_history_page
end


######## Helpers
helpers do

  def get_visit_history(id)
    visit_history = Visit.new
    visit_history_result = visit_history.get(id)
    # result = JSON.parse(visit_history_result)
  end
  
  def get_details(id)
    details = Details.new
    details_result = details.get(id)
    result = JSON.parse(details_result)
  end
  
  def perform_search(search_criteria)
    search = Search.new
    search_result = search.search(search_criteria)
    result_for_display = []
    if (search_result != nil)
      search_result.each do |result|
        hash_result = JSON.parse(result)
        result_for_display << hash_result
      end
    end
    return result_for_display
  end

  def convert_to_json(return_value)
    content_type :json
    { :result => "#{return_value}" }.to_json
  end
end




