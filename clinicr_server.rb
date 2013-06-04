require 'sinatra/base'

class Clinicr_base < Sinatra::Base
  use Rack::Session::Pool
  before do
    puts "BEFORE in Clinicr_base begin"
    action = request.path_info
    puts "action -> #{action}"
    unless ['/login'].include?(action) then
      unless session[:access_token] == nil then
        if session[:access_token].expired? then
          redirect "/login"
        end
      else
        redirect "/login"
      end
    end
    puts "BEFORE in Clinicr_base end"
  end

  get '/' do
    erb :homepage_modular
  end
end