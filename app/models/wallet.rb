class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true

  has_many :credits, class_name: "Transaction", foreign_key: 'to_wallet_id'
  has_many :debits, class_name: "Transaction", foreign_key: 'from_wallet_id'

  delegate :deposits, :withdraws, to: :transactions

  def balance
    sum.to_f - locked.to_f
  end

  def sum
    deposits = Transaction.succeed.where(to_wallet: self).sum(:amount).to_f
    withdraws = Transaction.succeed.where(from_wallet: self).sum(:amount).to_f
    cash_deposit.to_f + deposits - withdraws
  end

  ZERO = 0.to_d

  before_validation :generate_attributes, on: :create
  validates_numericality_of :balance, :locked, greater_than_or_equal_to: ZERO

  def lock_funds(amount)
    (amount <= ZERO or amount > self.balance) and raise WalletError, I18n.t("activerecord.errors.messages.cannot_lock_funds", amount: amount)
    change_locked amount
  end

  def unlock_funds(amount, reason: nil, ref: nil)
    (amount <= ZERO or amount > self.locked) and raise WalletError, I18n.t("activerecord.errors.messages.cannot_unlock_funds", amount: amount)
    change_locked -amount
  end

  def change_locked(delta_l)
    self.with_lock do
      self.update(locked: self.locked + delta_l)
    end
    self
  end

  class WalletError < RuntimeError; end

  private

  def generate_attributes
    self.locked = ZERO
    self.cash_deposit = ZERO
  end
end
