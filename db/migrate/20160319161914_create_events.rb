class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string      :title
      t.text        :description
      t.belongs_to  :adventure,         index: true, foreign_key: true
      t.integer     :previous_event_id, index: true

      t.timestamps null: false
    end
  end
end
