class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable :registerable,:recoverable, 
  devise :database_authenticatable, :rememberable, :validatable

  validates :name, presence: true

  has_many :notes, dependent: :destroy
end
