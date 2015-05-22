class AddConfirmableToBuyersDevise < ActiveRecord::Migration
  # Note: Can't use change, as User.update_all will fail in the down migration
  def up
    add_column :buyers, :confirmation_token, :string
    add_column :buyers, :confirmed_at, :datetime
    add_column :buyers, :confirmation_sent_at, :datetime
    add_index :buyers, :confirmation_token, unique: true
    execute("UPDATE buyers SET confirmed_at = NOW()")
    # All existing user accounts should be able to log in after this.
  end

  def down
    remove_columns :buyers, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
