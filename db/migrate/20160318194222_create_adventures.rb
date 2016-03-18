class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string :name,     null: false
      t.text :setting
      t.boolean :started, default: false

      t.timestamps null: false
    end

    add_index :adventures, :name, unique: true
  end
end
