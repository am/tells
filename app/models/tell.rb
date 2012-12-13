class Tell < ActiveRecord::Base
  attr_accessible :message, :name, :published

  validates :message, :presence => true,
                      :length => { :minimum => 10 }
end
