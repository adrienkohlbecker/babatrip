class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :this_id
      t.string :other_id
      t.string :kind

      t.timestamps
    end
  end
end
