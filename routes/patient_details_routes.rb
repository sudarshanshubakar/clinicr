require File.join(File.dirname(__FILE__),'..', 'clinicr_server.rb')
require File.join(File.dirname(__FILE__),'..', 'details.rb')
require File.join(File.dirname(__FILE__),'..', 'update.rb')
require File.join(File.dirname(__FILE__),'../database', 'factory.rb')
require 'json'

class Patient_details_routes < Clinicr_base
  include Config_factory

  get '/getDetails' do
    @id = params[:id]
    user_id = "test_id"
    prepare_details_display(user_id)
    erb :details_page
  end

  get '/getUpdatePatientDetailsForm' do
    @id = params[:id]
    user_id = "test_id"
    prepare_details_display(user_id)
    erb :update_patient_details_form
  end

  post '/updatePatient' do
    user_id = "test_id"
    perform_update_patient(user_id, params)
  end


  private
  def prepare_details_display(user_id)
    details_field_keys = get_details_field_keys("test_id")
    @details_for_display = get_details("test_id", @id)
    @details_labels = get_details_fields_display(details_field_keys)
    @details_keys = get_details_fields_actual(details_field_keys)
  end

  def get_details(user_id, patient_id)
    details = Details.new
    details_result = details.get(user_id, patient_id)
    result = JSON.parse(details_result)
  end

  def get_details_field_keys(user_id)
    labels = config_instance.find_patient_details_labels(user_id)
  end

  def get_details_fields_actual(details_field_keys)
    get_details_conf(details_field_keys,0)
  end

  def get_details_fields_display(details_field_keys)
    get_details_conf(details_field_keys, 1)
  end


  def get_details_conf(details_field_keys, index)
    # labels = config_instance.find_patient_details_labels
    display_keys = []
    details_field_keys.each do |label|
      display_keys << label.split(":")[index]
    end
    return display_keys
  end

  def perform_update_patient(user_id, params)
    update_patient = Update_patient.new
    update_patient.do(user_id, params)
  end


end