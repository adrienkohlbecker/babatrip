class SingleMoodAndTime < ActiveRecord::Migration
  def up
    add_column :users, :single_mood, :string
    add_column :users, :single_time, :string

    User.all.each {|u| u.update_attributes!(:single_mood => u.mood.first, :single_time => u.time.first) }

    remove_column :users, :mood
    remove_column :users, :time

    rename_column :users, :single_mood, :mood
    rename_column :users, :single_time, :time

    change_column :users, :mood, :string, null: false
    change_column :users, :time, :string, null: false
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
