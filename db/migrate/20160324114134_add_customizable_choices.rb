class AddCustomizableChoices < ActiveRecord::Migration
  def change
    add_column :choices, :customized, :boolean, default: false
  end
end
