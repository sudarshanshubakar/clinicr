require File.join(File.dirname(__FILE__),'..', 'clinicr_server.rb')
require 'oauth2'

class Login_routes < Clinicr_base

  # Scopes are space separated strings
  SCOPES = [
    'https://mail.google.com/',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile'
    ].join(' ')

    G_API_CLIENT = "153497584587-0r1n36j0i62d9udkgfbt4m2rorvnvgd4.apps.googleusercontent.com"
    G_API_SECRET = "ScDXfSw3IrZ7OjcmCzD8oO8N"

    get '/loginWithGoogle' do
      # session_id = params[:session_id]
      # puts "/login/loginWithGoogle pool[session_id] -> #{$pool[session_id]}"
      # @session = session
      puts "BEGIN /login/loginWithGoogle session id -> #{session.id}"
      redirect_url = client.auth_code.authorize_url(:redirect_uri => redirect_uri,:scope => SCOPES,:access_type => "offline")
      puts "/login/loginWithGoogle redirect_URL -> #{redirect_url}"
      redirect redirect_url
    end


    get '/oauth2callback' do
      access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
      puts "BEGIN /oauth2callback session id -> #{session.id}"
      session[:access_token_string] = access_token.token
      session[:access_token] = access_token
      puts "/oauth2callback expires? == #{access_token.expires?}"
      puts "/oauth2callback expired? == #{access_token.expired?}"
      puts "/oauth2callback expires_at == #{Time.at(access_token.expires_at)}"
      puts "/oauth2callback session -> #{session}"
      ap session
      puts "/oauth2callback session id -> #{session.id}"
      # puts "/oauth2callback pool.get_session -> "
      # ap $pool[session.id]
      # parsed is a handy method on an OAuth2::Response object that will
      # intelligently try and parse the response.body
      @email = access_token.get('https://www.googleapis.com/oauth2/v3/userinfo').parsed['name']
      # erb :success
      # session = @session
      puts "redirecting to /"
      redirect '/'
      # erb :homepage_modular
    end

    private
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