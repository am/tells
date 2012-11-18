class Tell < ActiveRecord::Base
  attr_accessible :message, :name, :published

  validates :name, :presence => true
  validates :message, :presence => true,
                      :length => { :minimum => 10 }
end
