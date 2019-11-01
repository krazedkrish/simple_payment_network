class Team < ApplicationRecord
  extend WalletConcern
  has_one :wallet, as: :walletable
  
  has_and_belongs_to_many :users

  after_create :create_wallet
end
