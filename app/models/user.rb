class User < ActiveRecord::Base
  has_many :channels
  has_and_belongs_to_many :subscribes, class_name: 'Channel'
end
