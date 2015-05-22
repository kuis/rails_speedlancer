class AddBotKeyToBuyers < ActiveRecord::Migration
  def change
    add_column :buyers, :bot_key, :string
    add_column :buyers, :bot_pid, :string
  end
end
