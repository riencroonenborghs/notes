class Note < ApplicationRecord
  paginates_per 12
  acts_as_taggable_on :tags
  dragonfly_accessor :image
  
  belongs_to :user

  validates :title, :markdown, :html, presence: true
end
