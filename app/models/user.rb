class User < ApplicationRecord
  extend WalletConcern
  has_one :wallet, as: :walletable

  has_and_belongs_to_many :teams
  has_many :stocks

  after_create :create_wallet
end
