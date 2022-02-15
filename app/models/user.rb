class User < ApplicationRecord
  has_many :bills
  has_many :movements
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    return first_name + " " + last_name
  end
end
