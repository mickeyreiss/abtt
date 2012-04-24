class CreateEmailQueues < ActiveRecord::Migration
  def self.up
    create_table :email_queues do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :email_queues
  end
end
