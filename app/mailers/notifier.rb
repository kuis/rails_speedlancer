class Notifier < ActionMailer::Base

  default from: "\"Speedlancer\" <noreply@speedlancer.com>"

  def send_account_credentials_to_seller(_password, _seller)
    @password = _password
    @seller = _seller
    mail(to: @seller.email, subject: "Your Speedlancer account details")
  end

  def send_account_credentials_to_buyer(_password, _buyer)
    @password = _password
    @buyer = _buyer
    mail(to: @buyer.email, subject: "Your Speedlancer account details")
  end

  def send_sales_approved_email(_seller)
    @seller =  _seller
    mail(to: @seller.email, subject: "Your Speedlancer account has been approved")
  end

  def send_block_for_sales_email(_seller)
    @seller = _seller
    mail(to: @seller.email, subject: 'You have been blocked for sales')
  end

  def send_comment_to_buyer_email(_comment, _task, _buyer, _commenter)
    @task = _task
    @comment = _comment
    @buyer = _buyer
    @commenter = _commenter
    mail(to: @buyer.email, subject:"Comment added on task: #{_task.title}")
  end

  def send_message_to_buyer_email(_message, _task, _buyer,_seller)
    @task = _task
    @message = _message
    @buyer = _buyer
    @seller = _seller
    mail(to: @buyer.email, subject:"New message added: #{@task.title}")
  end

  def send_message_to_seller_email(_message, _task, _buyer,_seller)
    @task = _task
    @message = _message
    @buyer = _buyer
    @seller = _seller
    mail(to: @seller.email, subject:"New message added: #{@task.title}")
  end

  def send_task_accepted_email(_task, _buyer, _seller)
    @task = _task
    @buyer = _buyer
    @seller = _seller
    mail(to: @buyer.email, subject: "Good news! Your task has been accepted by #{@seller.first_name_for_email}")
  end

  def send_seller_submission_received_email(_submission, _task, _buyer, _seller)
    @submission = _submission
    @task = _task
    @buyer = _buyer
    @seller = _seller
    _submission.submission_attachments.each do |submission_attachment|
      attachments[submission_attachment.submission.file.identifier] = File.read(submission_attachment.submission.path)
    end
    mail(to: @buyer.email, subject: "Your task has been delivered!")
  end

  def send_seller_revison_requested_email(_submission, _task, _buyer, _seller)
    @submission = _submission
    @task = _task
    @buyer = _buyer
    @seller = _seller
    mail(to: @seller.email, subject: "'#{@task.title}' revison request from '#{@buyer.first_name_for_email}'")
  end

  def send_seller_submission_approved_email(_task, _buyer, _seller )
    @buyer = _buyer
    @seller = _seller
    @task = _task
    mail(to: @seller.email, subject: "Good news! Your task has been approved by '#{@buyer.first_name_for_email}'")
  end

  def send_seller_feedback_received_email(_feedback, _task, _buyer, _seller)
    @feedback = _feedback
    @task = _task
    @buyer = _buyer
    @seller = _seller
    mail(to: @seller.email, subject: "'#{@buyer.first_name_for_email}' rated your work!")
  end

  def send_support_ticket_email(_support_ticket)
    @support_ticket = _support_ticket
    _email = _support_ticket.email
    mail(to: "support.6416.c4ea91333cdf2481@helpscout.net", subject: "New support ticket from #{_email}")
  end

  def send_task_lapse_email(_task)
    @task        = _task
    @buyer       = _task.buyer
    _admin_email = "admin@speedlancer.com"
    mail(to: @buyer.email, subject: "Task lapsed notice for: #{@task.title}")
  end

  def send_task_lapse_email_to_admin(_lapse_task_array)
    @tasks = _lapse_task_array
    _admin_email = "admin@speedlancer.com"
    mail(to: _admin_email, subject: "'#{@tasks.size}' tasks has been elapsed in last 8 hours.")
  end


  def send_task_time_run_out_to_seller_email(_task)
    @task = _task
    @seller = @task.present_seller
    mail(to: @seller.email, subject: "Urgent notice: Your time has lapsed!")
  end

  def send_task_time_run_out_to_admin_email(_tasks)
    @tasks = _tasks
    _admin_email = "admin@speedlancer.com"
    mail(to: _admin_email, subject: "Following task's delivery time has been run out")
  end

  def send_notify_sellers_about_new_tasks_email(_category, _seller, _task)
    @seller   = _seller
    @task     = _task
    @category = _category
    mail(to: @seller.email, subject: "New Speedlancer #{@category.name} Task - #{@task.title.capitalize}")
  end

  def send_notify_sellers_about_pending_tasks_email(_category, _seller, _task)
    @seller   = _seller
    @task     = _task
    @category = _category
    mail(to: @seller.email, subject: "Pending Speedlancer #{@category.name} Task - #{@task.title.capitalize}")
  end

  def send_task_back_to_que_seller_email(_task, _seller)
    @task = _task
    @seller = _seller
    mail(to: @seller.email, subject: "Your '#{@task.title.capitalize}' task has been disapproved by buyer.")
  end

  def send_buyer_team_subscribed(_team)
    @team = _team
    @buyer = _team.buyer
    mail(to: @buyer.email, subject: "Monthly subscription for your team has been paid.")
  end

  def send_buyer_team_inactivated(_team)
    @team = _team
    @buyer = _team.buyer
    mail(to: @buyer.email, subject: "Your Team has been expired.")
  end

end




