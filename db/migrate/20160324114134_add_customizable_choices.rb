class AddCustomizableChoices < ActiveRecord::Migration
  def change
    add_column :choices, :customized, :boolean, default: false
    add_column :choices, :customized_choice_id, :integer
  end
end
