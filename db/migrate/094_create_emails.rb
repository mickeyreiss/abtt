class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.binary :content
      t.boolean :global_read
      t.boolean :global_requires_followup
      t.boolean :global_blocking
      t.boolean :global_closed

      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
