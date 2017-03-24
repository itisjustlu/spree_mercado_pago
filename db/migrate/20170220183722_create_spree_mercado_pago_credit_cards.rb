class CreateSpreeMercadoPagoCreditCards < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_mercado_pago_payments_credit_cards do |t|
      t.string :token
      t.string :last_four
      t.string :doc_type
      t.string :doc_number
      t.integer :installments
      t.integer :gateway_object_id
      t.string :p_method
      t.string :collected_amount
      t.string :p_method_id
      t.string :email
      t.integer :user_id
      t.integer :payment_method_id
      t.string :data

      t.timestamps
    end
  end
end
