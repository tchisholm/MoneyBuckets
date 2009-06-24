class Bucket < ActiveRecord::Base
  belongs_to :user
  validates_existence_of :user
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false, :scope => [:user_id]
end
