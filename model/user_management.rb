require_relative '../database/factory.rb'

class User_admin
  include DB_factory
  
  def initialize
    @db = db_instance
  end
  
  def process_user(auth_provider_user_details_hash)
    email = auth_provider_user_details_hash["email"]
    unless @db.user_collection_exists?
      @db.add_user(email)
      @db.update_user format_user_details(auth_provider_user_details_hash)      
    end
    user = User.new(email)
    return user
  end
  
  private
  def format_user_details(auth_provider_user_details_hash)
    
  end
end

class User
  include DB_factory
  
  def initialize email
    @user_details = db_instance.get_user_info email
  end
  
  def get(key)
    return @user_details[key]
  end
end