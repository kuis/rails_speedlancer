Rails.configuration.stripe = {
  :publishable_key => 'pk_test_sYnTJ1haMDdLOx7VS7vVUrpp',
  :secret_key      => 'sk_test_AWxl4UgV5VFfkOnML8sjSm8z'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]