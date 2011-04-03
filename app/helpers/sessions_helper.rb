module SessionsHelper
  
  def sign_in(user)
    session[:user] = { :key => user.id, :secret => user.salt }
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    session[:user] = { :key => nil, :secret => nil }
    self.current_user = nil
  end
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      session[:user].respond_to?("values") ? session[:user].values : [nil, nil]
    end
end
