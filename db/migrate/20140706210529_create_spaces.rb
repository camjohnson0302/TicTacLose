class CreateSpaces < ActiveRecord::Migration
  def change
  	create_table :spaces do |t|
      t.integer :player_id
      t.integer :board_id
      t.integer :X
      t.integer :y
      t.timestamps
    end
  end
end
