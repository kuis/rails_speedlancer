class AddSourceToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :source, :string, :default => "wordpress"
  end
end
