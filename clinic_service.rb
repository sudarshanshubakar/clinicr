require 'sinatra'
require '/home/sudarshan/work/rubywork/myClinic/search.rb'

get '/myClinic/getSearchForm' do
  erb :search_form
end

post '/myClinic/search' do
  search_criteria = params[:search_field]
  "searching for #{search_criteria}"
  search = Search.new
  search_result = search.search(search_criteria)
  # json_result = convert_to_json(search_result)
end

helpers do
  def convert_to_json(return_value)
    content_type :json
    { :result => "#{return_value}" }.to_json
  end
end




