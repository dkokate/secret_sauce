module SessionsHelper
  
  def sign_in(user, options={})
    {:remember_me => options[:remember_me]}
    unencrypted_remember_token = User.new_remember_token
    # ==================
    if :remember_me
      cookies.permanent[:remember_token] = unencrypted_remember_token
    else
      cookies[:remember_token] = unencrypted_remember_token
    end
    # ==================
    # cookies.permanent[:remember_token] = unencrypted_remember_token
    user.update_attribute(:remember_token, User.encrypt(unencrypted_remember_token))
    self.current_user = user 
    # The above line translates to 'current_user=(user)' where 'current_user=' is a method defined below
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    encrypted_remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: encrypted_remember_token) if cookies[:remember_token]
    #                                                                       =============================
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.url
  end

end
