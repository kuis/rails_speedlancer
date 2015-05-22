class ApiKey < ActiveRecord::Base

  validates :access_token, :uniqueness =>  true

end

# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#
