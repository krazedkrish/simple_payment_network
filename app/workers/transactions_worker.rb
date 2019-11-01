class TransactionsWorker
  include Sidekiq::Worker

  def perform(transaction_id)
    begin
      transaction = Transaction.lock.find_by_id(transaction_id)
      return if transaction.nil? || !transaction.accepted?

      transaction.lock_funds!
      transaction.success!
    rescue Exception => e
      transaction.fail!
      Sidekiq.logger.error { 'Error during transaction processing.' }
      Sidekiq.logger.error { "Failed to process transaction with ID #{transaction.id}: #{e.inspect}." }
    end
  end
end