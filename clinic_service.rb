require 'sinatra'
require '/home/sudarshan/work/rubywork/myClinic/search.rb'
require 'json'

get '/myClinic/getSearchForm' do
  erb :search_form
end

post '/myClinic/search' do
  search_criteria = params[:search_field]
  "searching for #{search_criteria}"
  search = Search.new
  search_result = search.search(search_criteria)
  @result_for_display = []
  if (search_result != nil)
    search_result.each do |result|
      hash_result = JSON.parse(result)
      @result_for_display << hash_result
    end
  end
  erb :search_result
end

get '/myClinic/' do
  erb :home
end






helpers do
  def convert_to_json(return_value)
    content_type :json
    { :result => "#{return_value}" }.to_json
  end
end




