class Customer < ApplicationRecord
  has_many :appointments
  has_many :stylists, through: :appointments

  validates :name, presence: true
  validates :email, uniqueness: true, allow_blank: true
  validates :phone, uniqueness: true
end
