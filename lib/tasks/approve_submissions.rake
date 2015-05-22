desc "Approve seller submission if not reviewed within 3 days"
task approve_submissions: :environment do
  Task.in_review.find_each do |task|
    puts "Task under review: #{task.title}"
    last_seller_submission = task.sellers_submissions.last
    if last_seller_submission.present?
      if last_seller_submission.created_at < 72.hours.ago
        puts "=========================================="
        puts "Approving: #{task.title} #{task.id}"
        last_seller_submission.add_credits_and_update_task!
        puts last_seller_submission.inspect
        puts "=========================================="
      end
    end
  end
end
