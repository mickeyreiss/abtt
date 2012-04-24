class CreateEmailSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :email_subscriptions do |t|
      t.boolean :live
      t.boolean :daily
      t.boolean :weekly
      t.integer :member_id
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :email_subscriptions
  end
end
