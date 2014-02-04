class NormalToCool < ActiveRecord::Migration
  def up
    execute "UPDATE users SET mood='Cool' WHERE mood='Normal'"
  end
  def down
    execute "UPDATE users SET mood='Normal' WHERE mood='Cool'"
  end
end
