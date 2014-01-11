class RemoveNullConstraintOnMoodAndTime < ActiveRecord::Migration
  def change
    change_column :users, :mood, :string, null: true
    change_column :users, :time, :string, null: true
  end
end
