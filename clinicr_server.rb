require 'sinatra/base'
require 'rack/session/pool'
require 'awesome_print'

class Clinicr_base < Sinatra::Base

  before do
    action = request.path_info

    print_debug_info("BEFORE in Clinicr_base")
    
    unless bypass_login_check? action then
      unless session[:access_token] == nil then
        if session[:access_token].expired? then
          redirect "/login_page"
        end
      else
        redirect "/login_page"
      end
    end
  end

  get '/login_page' do
    erb :login_page
  end

  get '/' do
    erb :homepage_modular
  end
  
  private
  
  def print_debug_info(context)
    puts "#{context} session -> #{session}"
    # session[:par_1] = "test"
    puts "#{context} action -> #{request.path_info}"
    puts "#{context} session[:access_token] -> #{session[:access_token].inspect}"
    puts "#{context} session -> #{session}"
    ap session
    unless session[:access_token] == nil
      puts "#{context} session[:access_token].expired? -> #{session[:access_token].expired?}"
    end
    puts "#{context} session keys -> #{session.keys}"
    puts "#{context} session id -> #{session.id}"
  end
  
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