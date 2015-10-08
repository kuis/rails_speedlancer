class TeamPackage < ActiveRecord::Base
	def cost_in_dollars
		self.cost.to_d / 100.00 if self.cost
	end

	def cost_in_dollars=(dollars)
		self.cost = dollars.to_d * 100 if dollars.present?
	end
end