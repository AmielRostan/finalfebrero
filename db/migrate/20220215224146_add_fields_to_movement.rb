class AddFieldsToMovement < ActiveRecord::Migration[6.1]
  def change
    add_column :movements, :total_amount, :integer
  end
end
