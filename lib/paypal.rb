module Paypal
  def paypal_url(return_path, credit_value)
    values = {
      business: ENV["PAYPAL_MERCHANT_ACCOUNT"],
      cmd: "_xclick",
      upload: 1,
      # return: "#{Rails.application.secrets.app_host}#{return_path}",
      return: "#{Rails.application.secrets.app_host}#{return_path}",
      invoice: "#{self.id}-#{self.updated_at}".parameterize,
      item_name: self.email,
      item_number: self.id,
      amount: credit_value,
      page_style: "Speedlancer",
      notify_url: "#{Rails.application.secrets.app_host}/credit_hook"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
end
