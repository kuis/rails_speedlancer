class AddFirstNameAndLastNameToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :first_name, :string
    add_column :sellers, :last_name, :string
  end
end
