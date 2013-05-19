require './clinicr_server.rb'
require './routes/add_patient_routes.rb'
require './routes/patient_details_routes.rb'

map '/' do
  run Clinicr_base
end

map '/addPatient' do
  run Add_patient_routes
end

map '/details' do
  run Patient_details_routes
end