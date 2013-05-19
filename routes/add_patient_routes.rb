require File.join(File.dirname(__FILE__),'..', 'clinicr_server.rb')
require File.join(File.dirname(__FILE__),'..', 'add.rb')
require File.join(File.dirname(__FILE__),'../database', 'factory.rb')

class Add_patient_routes < Clinicr_base
  include Config_factory
  get '/getAddPatientForm' do
    fields_array = get_add_form_fields("test_id")
    @fields_array_display = get_add_form_fields_display(fields_array)
    @fields_array_actual = get_add_form_fields_actual(fields_array)
    erb :add_patient_form
  end

  post '/doAddPatient' do
    id = perform_add_patient("test_id",params)
    "#{id}"
  end

  private
  def get_add_form_fields(user_id)
    form_fields = config_instance.find_add_form_fields(user_id)
  end

  def get_add_form_fields_display(form_fields)
    get_add_form_fields_conf(form_fields, 1)
  end

  def get_add_form_fields_actual(form_fields)
    get_add_form_fields_conf(form_fields, 0)
  end

  def get_add_form_fields_conf(form_fields, index)
    display_keys = []
    form_fields.each do |form_field|
      display_keys << form_field.split(":")[index]
    end
    return display_keys
  end


  def perform_add_patient(user_id, params)
    add_patient = Add_patient.new
    add_patient.do(user_id, params)
  end

end