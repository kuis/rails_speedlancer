class SellerTeam < ActiveRecord::Base
	belongs_to :team
	belongs_to :seller

	validates :team_id, uniqueness: {:scope => :seller_id}, presence: true
  	validates :seller_id, uniqueness: {:scope => :team_id}, presence: true
end