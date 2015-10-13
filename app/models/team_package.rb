class TeamPackage < ActiveRecord::Base
	validates :title, :cycle, :cost, :members, presence: true

	def cost_in_dollars
		self.cost.to_d / 100.00 if self.cost
	end

	def cost_in_dollars=(dollars)
		self.cost = dollars.to_d * 100 if dollars.present?
	end
end