require_relative '../database/factory.rb'
require 'json'

class User_admin
  include DB_factory
  
  def initialize
    @db = db_instance
  end
  
  def process_user(auth_provider_user_details_hash)
    email = auth_provider_user_details_hash["email"]
    unless @db.user_collection_exists?
      @db.add_user(email)
    end
    @db.update_user email, format_user_details(auth_provider_user_details_hash)
    user = User.new(email)
    return user
  end
  
  private
  def format_user_details(auth_provider_user_details_hash)
    auth_provider_user_details_hash.keys.each do |key|
      puts "#{key} -->> #{auth_provider_user_details_hash[key]}"
    end
    return auth_provider_user_details_hash
  end
end

class User
  include DB_factory
  
  def initialize email
    user_details = db_instance.get_user_info email
    @user_details = JSON.parse(user_details)
  end
  
  def get(key)
    return @user_details[key]
  end
  
  def print
    result = ""
    @user_details.keys.each do |key|
      result += "#{key} -> #{@user_details[key]} "
    end
    return result
  end
end