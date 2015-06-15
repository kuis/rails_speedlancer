class AddColumnFeeByPercentToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :fee_by_percent, :int, :default => 20
  end
end
