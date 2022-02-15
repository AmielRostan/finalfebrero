class AddFields2ToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :document_number, :integer
    add_column :users, :birth_date, :date
  end
end
