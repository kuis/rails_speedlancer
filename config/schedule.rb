set :output, {:error => 'error.log', :standard => 'cron.log'}

# Commented out for now as it might create issues on production
every 30.minutes do
  rake "approve_submissions"
end

every 30.minutes do
  runner "Task.tasks_lapse"
end

every 30.minutes do
  runner "Task.check_active_task_pending"
end

# every 3.hours do
# 	runner "Category.tasks_in_categories"
# end

every 3.hours do
	runner "Task.check_task_time_out"
end

every 1.day, :at => '12pm' do
  runner "Seller.create_payouts"
end

every 1.day, :at => '12am' do
  runner "Team.expires"
end
