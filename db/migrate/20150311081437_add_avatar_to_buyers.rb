class AddAvatarToBuyers < ActiveRecord::Migration
  def change
    add_column :buyers, :avatar, :string
  end
end
