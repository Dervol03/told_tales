class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.text        :decision,  null: false
      t.belongs_to  :event,     null: false, index: true, foreign_key: true

      t.timestamps              null: false
    end

    add_column  :events, :outcome_id, :integer
    add_index   :events, :outcome_id
  end
end
