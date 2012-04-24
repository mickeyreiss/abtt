class CreateEmailFlags < ActiveRecord::Migration
  def self.up
    create_table :email_flags do |t|
      t.integer :email_id
      t.integer :member_id
      t.boolean :read
      t.boolean :requires_follow_up
      t.boolean :blocking
      t.boolean :closed

      t.timestamps
    end
  end

  def self.down
    drop_table :email_flags
  end
end
