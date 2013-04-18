module SessionsHelper
  def sign_in(user)
    cookies.permanent[:session_token] = user.session_token
    @current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def signed_in_user
    unless signed_in?
      # Wouldn't work with "knock on the door" button, because of new_story_path
      # TODO: make it work
      # store_location
      respond_to do |format|
        format.html { redirect_to signin_path, notice: "Please sign in." }
        format.js { render js: "window.location.pathname='#{signin_path}'" }
      end
    end
  end

  def current_user
    @current_user ||= User.find_by_session_token(cookies[:session_token])
  end

  def current_user?(user)
    user == current_user
  end
  
  def sign_out
    @current_user = nil
    cookies.delete(:session_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url 
  end
end
