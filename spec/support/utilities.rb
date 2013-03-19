def sign_in(user)
  visit signin_path
  fill_in "Email",       with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:session_token] = user.session_token
end

def sign_up_user
  fill_in "Name",           with: "Example User"
  fill_in "Email",            with: "user@example.com"
  fill_in "Password",      with: "foobar"
  fill_in "Confirmation", with: "foobar"
end

def edit_user(user)
  fill_in "Name",             with: new_name
  fill_in "Email",              with: new_email
  fill_in "Password",        with: user.password
  fill_in "Confirmation",  with: user.password
  click_button "Save changes"
end