class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :nick_name
      t.string :phone
      t.string :email
      t.string :username
      t.string :password_hash
      t.string :callsign
      t.string :shirt_size

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
