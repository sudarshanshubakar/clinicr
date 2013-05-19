require 'sinatra/base'

class Clinicr_base < Sinatra::Base
  get '/' do
    erb :homepage_modular
  end
end