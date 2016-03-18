class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string :name,     null: false
      t.text :setting
      t.boolean :started, default: false
      t.integer :owner_id

      t.timestamps null: false
    end

    add_index :adventures, :name, unique: true
  end
end
