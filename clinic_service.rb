require 'sinatra'
require_relative 'search.rb'
require_relative 'visit.rb'
require_relative 'update.rb'
require_relative 'details.rb'
require_relative 'add.rb'
require_relative 'configuration.rb'
require 'json'

######## Routes

get '/myClinic/getAddPatientForm' do
  @fields_array = get_add_form_fields
  erb :add_patient_form
end

post '/myClinic/addPatient' do
  id = perform_add_patient(params)
  "#{id}"
end

post '/myClinic/updateHistory' do
  perform_update(params)
  "done"
end

get '/myClinic/getSearchForm' do
  erb :search_form
end

get '/myClinic/getUpdateHistoryForm' do
  fields = params["fields"]
  @id = params["id"]
  @fields_array = fields.split("!")
  @fields_array.delete("date")
  puts "fields #{fields}"
  erb :update_history_form
end

post '/myClinic/search' do
  search_criteria = params[:search_field]
  # @result_for_display = perform_search(search_criteria)

  @headers = []
  @no_search_result = false
  @result_for_display = perform_search(search_criteria)
  if @result_for_display.empty? then
    @no_search_result = true
  else
    @headers = @result_for_display[0].keys
  end
  puts "search headers == #{@headers}"

  erb :search_result
end

get '/myClinic' do
  # erb :home
  erb :homepage
end

get '/myClinic/details' do
  @id = params[:id]
  @details_for_display = get_details(@id)
  erb :details_page
end

get '/myClinic/visitHistory' do
  @id = params[:id]
  @history_headers = get_history_headers
  @no_history = false
  @visit_history_for_display = get_visit_history(@id)
  # if @visit_history_for_display.empty? then
  #   @no_history = true
  # end
  puts "no history == #{@no_history}"
  puts "history headers == #{@history_headers}"
  erb :visit_history_page
end


######## Helpers
helpers Configuration do
  
  def get_history_headers
    history_headers = find_history_fields
  end
  
  def get_add_form_fields
    form_fields = find_add_form_fields
  end

  def perform_add_patient(params)
    add_patient = Add_patient.new
    add_patient.do(params)
  end
  
  def perform_update(params)
    update_visit = Update_history.new
    update_visit.do(params)
  end

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
        # hash_result = JSON.parse(result)
        result_for_display << result
      end
    end
    return result_for_display
  end

  def convert_to_json(return_value)
    content_type :json
    { :result => "#{return_value}" }.to_json
  end
end




