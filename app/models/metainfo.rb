class Metainfo < ActiveRecord::Base
    validates :name, :presence => true, :uniqueness => true
    validates :value, presence: true

    scope :metas, -> {where("NAME != 'title'")}

    def self.get(name)
    	obj = Metainfo.find_by_name(name)
    	value = ''
    	unless obj.nil?
    	 	value = obj.value
    	end

    	value
    end
end