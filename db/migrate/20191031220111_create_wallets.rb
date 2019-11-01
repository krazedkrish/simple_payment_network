class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.decimal :cash_deposit
      t.decimal :locked
      t.references :walletable, polymorphic: true

      t.timestamps
    end
  end
end
