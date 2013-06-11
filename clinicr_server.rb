require 'sinatra/base'
require 'rack/session/pool'
require 'awesome_print'

class Clinicr_base < Sinatra::Base

  before do
    puts "BEFORE in Clinicr_base begin"
    action = request.path_info
    puts "session -> #{session}"
    session[:par_1] = "test"
    puts "action -> #{action}"
    puts "session[:access_token] -> #{session[:access_token]}"
    puts "session -> #{session}"
    ap session
    puts "session keys -> #{session.keys}"
    puts "session id -> #{session.id}"

    unless bypass_login_check? action then
      puts "access token => #{session[:access_token].inspect}"
      unless session[:access_token] == nil then
        if session[:access_token].expired? then
          redirect "/login_page"
        end
      else
        puts "access token == nill"
        redirect "/login_page"
      end
    end
    puts "BEFORE in Clinicr_base end"
  end

  get '/login_page' do
    # @session_id = params[:session_id]
    erb :login_page
  end

  get '/' do
    erb :homepage_modular
  end
  
  private
  def bypass_login_check?(action)
    bypass_routes = ['/login_page', '/loginWithGoogle', '/oauth2callback']
    bypass_routes.each do |bypass_route|
      if action.start_with? bypass_route
        return true
      end
    end
    return false
  end
end