class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :aasm_state
      t.decimal :amount
      t.string :tx_no

      t.references :to_wallet
      t.references :from_wallet

      t.timestamps
    end
    add_index :transactions, :tx_no, unique: true
    add_index :transactions, :aasm_state
  end
end
