class Tell < ActiveRecord::Base
  attr_accessible :message

  validates :message, :presence => true,
                      :length => { :minimum => 10 }
end
