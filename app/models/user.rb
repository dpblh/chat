class User < ActiveRecord::Base

  has_many :channels
  has_and_belongs_to_many :subscribes, class_name: 'Channel'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :vkontakte, :google_oauth2]

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :nickname, :provider, :url, :username

  def self.find_for_facebook_oauth access_token
    if user = User.where(:url => access_token.info.urls.Facebook).first
      user
    else
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Facebook, :username => access_token.extra.raw_info.name, :nickname => access_token.extra.raw_info.username, :email => access_token.extra.raw_info.email, :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_vkontakte_oauth access_token
    if user = User.where(:url => access_token.info.urls.Vkontakte).first
      user
    else
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Vkontakte, :username => access_token.info.name, :nickname => access_token.extra.raw_info.nickname, :email => access_token.info.urls.Vkontakte+'@user.com', :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_google_oauth2 access_token
    if user = User.where(:url => access_token.info.urls.Google).first
      user
    else
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Google, :username => access_token.extra.raw_info.name, :nickname => access_token.extra.raw_info.name, :email => access_token.extra.raw_info.email, :password => Devise.friendly_token[0,20])
    end
  end
end
