object false
node(:status){"success"}
node(:payment){@task.payment_method}
node(:payment_url){@task.payment_url("#{Rails.application.secrets.wordpress_payment_url}", @task.price_in_dollars, 0, true)}

