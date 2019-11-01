module WalletConcern
  include ActiveSupport::Concern

  def create_wallet
    wallet.create
  end
end
