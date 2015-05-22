class AddMessagableIdAndMesagableTypeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :messagable_id, :integer
    add_index :messages, :messagable_id
    add_column :messages, :messagable_type, :string
    add_index :messages, :messagable_type
  end
end
