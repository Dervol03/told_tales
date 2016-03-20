class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string      :title,
                    index: true,
                    unique: true,
                    null: false,
                    default: ''

      t.text        :description,       null: false, default:     ''
      t.belongs_to  :adventure,         index: true, foreign_key: true
      t.integer     :previous_event_id, index: true
      t.integer     :current_event_id
      t.boolean     :visited,           default: false

      t.timestamps null: false
    end
  end
end
