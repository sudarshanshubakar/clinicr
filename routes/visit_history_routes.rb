require File.join(File.dirname(__FILE__),'..', 'clinicr_server.rb')
require File.join(File.dirname(__FILE__),'../model', 'visit.rb')
require File.join(File.dirname(__FILE__),'../model', 'update.rb')
require File.join(File.dirname(__FILE__),'../database', 'factory.rb')


class Visit_history_routes < Clinicr_base
  include Config_factory

  get '/getVisitHistory' do
    @id = params[:id]
    user_id = get_user_id
    history_field_conflist = get_history_field_keys(user_id)
    @history_headers = get_history_headers(history_field_conflist)
    @history_keys = get_history_keys(history_field_conflist)
    @no_history = false
    @visit_history_for_display = get_visit_history(user_id, @id)
    puts "no history == #{@no_history}"
    puts "history headers == #{@history_headers}"
    erb :visit_history_page
  end

  get '/getUpdateHistoryForm' do
    
    user_id = get_user_id
    history_field_conflist = get_history_field_keys(user_id)
    @fields_array_display = get_history_headers(history_field_conflist)
    @fields_array_actual = get_history_keys(history_field_conflist)
    @fields_array_display.delete("Date")
    @title = "Record this visit"
    @field_type = "textarea"
    @form_action = "/visitHistory/updateHistory"
    @form_id = "update_form"
    @post_submit_location = "update_form"
    @submit_button_text = "Record visit" 
    id = params["id"]
    hidden_field = Hash.new
    hidden_field[:name] = "id"
    hidden_field[:value] = id
    @hidden_fields = [hidden_field]
    # puts "fields #{@fields_array}"
    # erb :update_history_form
    erb :overlay_form
  end

  post '/updateHistory' do
    user_id = get_user_id
    perform_update_history(user_id, params)
    "done"
  end


  private
  def get_user_id
    user_id = session[:user].get("email")
    return user_id
  end
  
  def get_visit_history(user_id, id)
    visit_history = Visit.new
    visit_history_result = visit_history.get(user_id, id)
    # result = JSON.parse(visit_history_result)
  end

  def get_history_field_keys(user_id)
    visit_history_fields = config_instance.find_history_fields(user_id)
  end

  def get_history_headers(history_field_conflist)
    get_histrory_conf(history_field_conflist, 1)
  end

  def get_histrory_conf(visit_history_fields, index)
    headers = []
    visit_history_fields.each do |visit_history_field|
      headers << visit_history_field.split(":")[index]
    end
    return headers
  end


  def get_history_keys(history_field_conflist)
    get_histrory_conf(history_field_conflist, 0)
  end

  def perform_update_history(user_id, params)
    update_visit = Update_history.new
    update_visit.do(user_id, params)
  end

end