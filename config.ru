require './clinicr_server.rb'
require './routes/add_patient_routes.rb'
require './routes/patient_details_routes.rb'
require './routes/visit_history_routes.rb'
require './routes/search_patient_routes.rb'
require './routes/login_routes.rb'

use Rack::Session::Pool, :key => "settings.session_key", :secret => "settings.session_secret"

map '/' do
  run Clinicr_base
end

map '/addPatient' do
  run Add_patient_routes
end

map '/details' do
  run Patient_details_routes
end

map '/visitHistory' do
  run Visit_history_routes
end

map '/search' do
  run Search_patient_routes
end

map '/login' do
  run Login_routes
end