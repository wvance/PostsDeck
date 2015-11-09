class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	# def all
	# 	user = User.from_omniauth(request.env["omniauth.auth"])
	# 	if user.persisted?
	# 		flash.notice = "Signed In!"
	# 		sign_in_and_redirect user
	# 	else
	# 		session["devise.user_attributes"] = user.attributes
	# 		redirect_to new_user_registration_url
	# 	end
	# end
	# alias_method :twitter, :all


	def facebook
    @user = UserProvider.find_for_facebook_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def foursquare
  	@user = UserProvider.find_for_foursquare_oauth(request.env["omniauth.auth"])

  	if @user.persisted?
  		sign_in_and_redirect @user, :event => :authentication
  	else
  		session["devise.foursquare"] = request.env["omniauth.auth"]
  		redirect_to new_user_registration_url
  	end
  end

  def twitter
    auth = env["omniauth.auth"]

    @user = UserProvider.find_for_twitter_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_uid"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    @user = UserProvider.find_for_google_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
end
