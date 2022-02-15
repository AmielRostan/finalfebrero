class Movement < ApplicationRecord
  belongs_to :bill
  belongs_to :user

  paginates_per 50

  validates :description, :date, :time, :amount, presence: true


  # def positive_value
  #   if self.amount > 0
  #   else
  #     puts "*** El monto del movimiento debe ser positivo, al seleccionar debito se restara de la cuenta por mas de que ingrese un numero positivo *** "
  #     errors.add(:amount, 'El monto debe ser positivo')
  #     break
  #   end
  # end
end
