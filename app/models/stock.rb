class Stock < ApplicationRecord
  extend WalletConcern

  has_one :wallet, as: :walletable
  belongs_to :user

  after_create :create_wallet
end
