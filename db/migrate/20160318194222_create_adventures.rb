class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string :name,       null: false
      t.text :setting
      t.integer :owner_id,  null: false
      t.integer :player_id
      t.integer :master_id

      t.timestamps          null: false
    end

    add_index :adventures, :name, unique: true
  end
end
