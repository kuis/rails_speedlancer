class ChangeTaskStatusDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :tasks, :status, 4
  end
end
