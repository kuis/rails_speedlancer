class Team < ActiveRecord::Base
	belongs_to :buyer
	belongs_to :package, :foreign_key => "package_id", :class_name => "TeamPackage"
	has_many :seller_teams, dependent: :destroy
	# has_many :sellers, through: :seller_teams, source: :sellers
	has_many :sellers, through: :seller_teams, class_name: "Seller"

	accepts_nested_attributes_for :sellers

	enum status: [ :active, :inactive]

	validates :buyer, :package, :deadline, :status, :members, presence: true
	validates :members, :numericality => {:greater_than => 0.01}
	validate :seller_cannot_be_greater_than_members

	def seller_cannot_be_greater_than_members
		if self.sellers.count > self.members
			errors.add(:sellers, "can't be greater than members")
		end
	end

	def self.expires
		teams = Team.active.where("deadline < ?", Time.zone.now)
		teams.each do |team|
			unless team.buyer.purchase_team(team.package)
				team.update(status: 'inactive')
				team.save
			end

			team.notify_mail_to_buyer
		end
	end

	def notify_mail_to_buyer
		if self.active?
			Notifier.send_buyer_team_subscribed(self).deliver
		elsif self.inactive?
			Notifier.send_buyer_team_inactivated(self).deliver
		end
	end
	handle_asynchronously :notify_mail_to_buyer
end