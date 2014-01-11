class StoreChoicesAsFullString < ActiveRecord::Migration
  def up
    execute %Q{UPDATE trips SET composition = 'Alone' WHERE composition = 'A'}
    execute %Q{UPDATE trips SET composition = 'Couple' WHERE composition = 'C'}
    execute %Q{UPDATE trips SET composition = 'With friends' WHERE composition = 'F'}

    execute %Q{UPDATE users SET mood = 'Hippie' WHERE mood = 'H'}
    execute %Q{UPDATE users SET mood = 'Chic' WHERE mood = 'C'}
    execute %Q{UPDATE users SET mood = 'Normal' WHERE mood = 'N'}

    execute %Q{UPDATE users SET time = 'Night' WHERE time = 'N'}
    execute %Q{UPDATE users SET time = 'Day' WHERE time = 'D'}
    execute %Q{UPDATE users SET time = 'All day' WHERE time = 'A'}

    execute %Q{UPDATE users SET relationship_status = 'Single' WHERE relationship_status = 'S'}
    execute %Q{UPDATE users SET relationship_status = 'In a relationship' WHERE relationship_status = 'R'}

    execute %Q{UPDATE users SET sex = 'Male' WHERE sex = 'M'}
    execute %Q{UPDATE users SET sex = 'Female' WHERE sex = 'F'}
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
