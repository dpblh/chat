class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :uid
      t.belongs_to :user, index: true
      t.boolean :private_channel, default: false

      t.timestamps
    end
    create_table :channels_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :channel, index: true
    end
  end
end
