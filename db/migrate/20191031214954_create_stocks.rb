class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :share_counts
      t.string :company_code

      t.references :user
      t.timestamps
    end

    add_index :stocks, :company_code
  end
end
