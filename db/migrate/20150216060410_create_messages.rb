class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :sender_id
      t.string :sender_type
      t.integer :receiver_id
      t.string :receiver_type

      t.timestamps
    end
  end
end
