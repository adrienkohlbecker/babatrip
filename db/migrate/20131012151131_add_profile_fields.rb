class AddProfileFields < ActiveRecord::Migration
  def change

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birth_date, :date
    add_column :users, :sex, :string, length: 1
    add_column :users, :relationship_status, :string, length: 1
    add_column :users, :nationality, :string, length: 2
    add_column :users, :city, :string
    add_column :users, :mood, :string,  array: true
    add_column :users, :time, :string,  array: true

  end
end
