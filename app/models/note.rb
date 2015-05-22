class Note < ActiveRecord::Base
  belongs_to :task
end

# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :text
#  task_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
