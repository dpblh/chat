class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @users = User.find_for_facebook_oauth request.env["omniauth.auth"]
    if @users.persisted?
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
    sign_in_and_redirect @users, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end

  def vkontakte
    @users = User.find_for_vkontakte_oauth request.env["omniauth.auth"]
    if @users.persisted?
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Vkontakte"
    sign_in_and_redirect @users, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end

  def google_oauth2
    @user = User.find_for_google_oauth2 request.env["omniauth.auth"]

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end
end
