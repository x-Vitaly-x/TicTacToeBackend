class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer :x_player_id
      t.integer :y_player_id
      t.json :board
      t.string :status

      t.timestamps
    end
  end
end
