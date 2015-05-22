class AddFirstNameAndLastNameToBuyers < ActiveRecord::Migration
  def change
    add_column :buyers, :first_name, :string
    add_column :buyers, :last_name, :string
  end
end
