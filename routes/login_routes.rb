require File.join(File.dirname(__FILE__),'..', 'clinicr_server.rb')
require File.join(File.dirname(__FILE__),'../model', 'user_management.rb')
require 'oauth2'

class Login_routes < Clinicr_base

  get '/loginWithGoogle' do
    # puts "BEGIN /login/loginWithGoogle session id -> #{session.id}"
    redirect_url = client.auth_code.authorize_url(:redirect_uri => redirect_uri,:scope => SCOPES,:access_type => "offline")
    # puts "/login/loginWithGoogle redirect_URL -> #{redirect_url}"
    redirect redirect_url
  end


  get '/oauth2callback' do
    access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    # session[:access_token_string] = access_token.token
    session[:access_token] = access_token

    print_debug("INSIDE /oauth2callback", session)

    user_info = access_token.get('https://www.googleapis.com/oauth2/v3/userinfo').parsed
    
    user_admin = User_admin.new
    
    user = user_admin.process_user user_info
    session[:user] = user
    
    # @email = access_token.get('https://www.googleapis.com/oauth2/v3/userinfo').parsed['name']
    redirect '/'
  end

  # Scopes are space separated strings
  SCOPES = [
    'https://mail.google.com/',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile'
    ].join(' ')

    G_API_CLIENT = "153497584587-0r1n36j0i62d9udkgfbt4m2rorvnvgd4.apps.googleusercontent.com"
    G_API_SECRET = "ScDXfSw3IrZ7OjcmCzD8oO8N"

    private
    def print_debug(context, session)
      ap session
      puts "#{context} session[:access_token].expires? == #{session[:access_token].expires?}"
      puts "#{context} session[:access_token].expired? == #{session[:access_token].expired?}"
      puts "#{context} Time.at(session[:access_token].expires_at) == #{Time.at(session[:access_token].expires_at)}"
      puts "#{context} session -> #{session}"
      ap session
      puts "#{context} session id -> #{session.id}"
      puts "#{context} userinfo -> #{session[:access_token].get('https://www.googleapis.com/oauth2/v3/userinfo').parsed}"
    end

    def redirect_uri
      uri = URI.parse(request.url)
      uri.path = '/login/oauth2callback'
      uri.query = nil
      uri.to_s
    end

    def client
      client ||= OAuth2::Client.new(G_API_CLIENT, G_API_SECRET, {
        :site => 'https://accounts.google.com',
        :authorize_url => "/o/oauth2/auth",
        :token_url => "/o/oauth2/token"
        })
      end

    end