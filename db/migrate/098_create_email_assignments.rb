class CreateEmailAssignments < ActiveRecord::Migration
  def self.up
    create_table :email_assignments do |t|
      t.integer :email_id
      t.integer :assigner_id
      t.integer :assignable_id
      t.string :assignable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :email_assignments
  end
end
