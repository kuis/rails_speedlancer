class Metainfo < ActiveRecord::Base
    validates :name, :presence => true, :uniqueness => {scope: :url}
    validates :value, presence: true

    scope :default, -> {where("URL = '' or URL IS NULL")}
    scope :metas, -> {where("URL = '' or URL IS NULL")}

    def self.get(url)
    	Metainfo.where("url = ?", url)
    end
end