class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.float :amount
      t.string :brand
      t.date :payed_at
      t.date :credited_on
      t.string :kind  

      t.timestamps
    end
  end
end
