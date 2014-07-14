class CreateBoards < ActiveRecord::Migration
  def change
  	create_table :boards do |t|
      t.integer :game_id
      t.integer :size, default: 3
      t.timestamps
    end
  end
end
