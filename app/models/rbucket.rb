class Rbucket < ActiveRecord::Base
  
  belongs_to :recurring
  validates_existence_of :recurring
  validates_presence_of :abucket_id, :amount
  validates_uniqueness_of :abucket_id, :case_sensitive => false, :scope => [:recurring_id]
  
end
