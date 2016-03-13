class AddSingleUsePasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :temporary_password, :string
  end
end
