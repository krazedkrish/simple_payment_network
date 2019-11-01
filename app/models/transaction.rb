class TransactionValidator < ActiveModel::Validator
  def validate(record)
    if record.to_wallet_id.nil?
      record.errors[:to_wallet_id] << 'Destination wallet needs to be valid'
    end

    if record.from_wallet_id.nil?
      record.errors[:from_wallet_id] << 'Source wallet needs to be valid'
    end

    if record.to_wallet_id == record.from_wallet_id
      record.errors[:to_wallet_id] << 'Destination wallet needs to be different from source wallet'
    end
  end
end

class Transaction < ApplicationRecord
  include ActiveModel::Validations
  include AASM

  validates_with TransactionValidator

  enum aasm_state: {
    initiated: 0,
    accepted: 1,
    rejected: 2,
    locked_funds: 3,
    succeed: 4,
    failed: 5
  }

  belongs_to :from_wallet, class_name: "Wallet"
  belongs_to :to_wallet, class_name: "Wallet"

  before_validation :generate_attributes, on: :create

  def self.types
    %w(Withdraw Deposit)
  end

  scope :deposits, -> { where(type: 'Deposit') }
  scope :Withdraws, -> { where(type: 'Withdraw')}

  scope :succeed, -> { where(aasm_state: 'succeed') }

  aasm enum: true, whiny_transactions: false do
    state :initiated, initial: true
    state :accepted
    state :rejected
    state :locked_funds
    state :succeed
    state :failed
  
    event :accept do
      transitions from: :initiated, to: :accepted
    end

    event :reject do
      transitions from: :initiated, to: :rejected
    end

    event :lock_funds do
      transitions from: :accepted, to: :locked_funds
      after { from_wallet.lock!.lock_funds(amount)}
    end

    event :success do
      transitions from: :locked_funds, to: :succeed
      after { from_wallet.lock!.unlock_funds(amount)}
    end

    event :fail do
      transitions from: :locked_funds, to: :failed
      after { from_wallet.lock!.unlock_funds(amount)}
    end
  end

  def order(from_wallet, to_wallet, amount)
    Transaction.create(amount: amount, from_wallet: from_wallet, to_wallet: to_wallet)
  end

  private

  def generate_attributes
    self.aasm_state = 'initiated'
    set_tx_no
  end

  def set_tx_no
    loop do
      self.tx_no = SecureRandom.hex[0..7].upcase
      break unless Transaction.exists?(tx_no: self.tx_no)
    end
  end
end