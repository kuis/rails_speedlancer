object false
node(:status){"success"}
node :buyers do
	@buyers.map do |buyer|
		{id:buyer.id, email: buyer.email,bot_key:buyer.bot_key,bot_pid:buyer.bot_pid}
	end
end