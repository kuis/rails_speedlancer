class RemoveSenderIdAndReceiverIdFromMessages < ActiveRecord::Migration
  def change
  	remove_column :messages, :sender_id, :integer
    remove_column :messages, :receiver_id, :integer
    remove_column :messages, :sender_type, :string
    remove_column :messages, :receiver_type, :string
  end
end
