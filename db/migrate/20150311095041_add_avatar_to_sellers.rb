class AddAvatarToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :avatar, :string
  end
end
