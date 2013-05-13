require 'sinatra'
require_relative 'search.rb'
require_relative 'visit.rb'
require_relative 'update.rb'
require_relative 'details.rb'
require_relative 'add.rb'
require_relative 'database/factory.rb'
require 'json'

######## Routes

post '/myClinic/updatePatient' do
  perform_update_patient(params)
end

get '/myClinic/getUpdatePatientDetailsForm' do
  @id = params[:id]
  @details_for_display = get_details(@id)
  @details_labels = get_details_view_labels
  @details_keys = get_details_keys
  erb :update_patient_details_form  
end

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
  @id = params["id"]
  @fields_array_display = get_history_headers
  @fields_array_actual = get_history_keys
  @fields_array_display.delete("Date")
  puts "fields #{@fields_array}"
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
  @details_labels = get_details_view_labels
  @details_keys = get_details_keys
  erb :details_page
end

get '/myClinic/visitHistory' do
  @id = params[:id]
  @history_headers = get_history_headers
  @history_keys = get_history_keys
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
helpers Config_factory do
  
  def perform_update_patient(params)
    update_patient = Update_patient.new
    update_patient.do(params)
  end
  
  def get_details_keys
    get_details_conf(0)
  end
  
  def get_details_view_labels
    get_details_conf(1)
  end
  
  
  def get_details_conf(index)
    labels = config_instance.find_patient_details_labels
    display_keys = []
    labels.each do |label|
      display_keys << label.split(":")[index]
    end
    return display_keys
  end
  
  def get_update_form_fields
    form_fields = get_add_form_fields
  end
  
  def get_history_headers
    get_histrory_conf(1)
  end
  
  def get_histrory_conf(index)
    visit_history_fields = config_instance.find_history_fields
    headers = []
    visit_history_fields.each do |visit_history_field|
      headers << visit_history_field.split(":")[index]
    end
    return headers
  end
  
  
  def get_history_keys
    get_histrory_conf(0)
  end  
  
  def get_add_form_fields
    form_fields = config_instance.find_add_form_fields
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




