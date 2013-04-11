require 'sinatra'

get '/myClinic/getSearchForm' do
  erb :search_form
end

post '/myClinic/search' do
  search_criteria = params[:search_field]
  "searching for #{search_criteria}"
end

