class Channel < ActiveRecord::Base
  attr_accessible :name, :private_channel
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_and_belongs_to_many :subscriber, class_name: 'User'
end
