class Note < ApplicationRecord
  paginates_per 9
  acts_as_taggable_on :tags
  
  belongs_to :user

  validates :title, :markdown, :html, presence: true
end
