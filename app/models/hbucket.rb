class Hbucket < ActiveRecord::Base
  
  belongs_to :history
  validates_existence_of :history
  validates_presence_of :abucket_id
  validates_uniqueness_of :abucket_id, :case_sensitive => false, :scope => [:history_id]
  
end
