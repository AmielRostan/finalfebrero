class Bill < ApplicationRecord
  has_many :movements
  belongs_to :user

  validates :bill_type, :balance, presence: true

  paginates_per 50

end
