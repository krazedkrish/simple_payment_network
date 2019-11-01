# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [ {first_name: 'John', last_name: 'Doe', dob: '1990/01/01'},
          {first_name: 'Jane', last_name: 'Doe', dob: '1992/02/01'},
          {first_name: 'Tom', last_name: 'Imaginary', dob: '1980/10/01'},
          {first_name: 'Peter', last_name: 'Parker', dob: '1982/11/11'}]

teams = [ {team_name: 'Team Alpha'}, 
          {team_name: 'XYZ'},
          {team_name: 'ABC'} ]

users = User.create(users)

teams = Team.create(teams)

teams[0].users << [users[0], users[1], users[2]]
teams[1].users << [users[0], users[1]]
teams[2].users << [users[0], users[2]]


stocks = [ {share_counts: 210, company_code: 'AGN', user: users[0]},
           {share_counts: 100, company_code: 'BGN', user: users[1]},
           {share_counts: 312, company_code: 'CGN', user: users[2]},
           {share_counts: 212, company_code: 'DGN', user: users[0]},
           {share_counts: 321, company_code: 'EGN', user: users[1]},
           {share_counts: 422, company_code: 'FGN', user: users[0]}]

stocks  = Stock.create(stocks)

users.each { |u| u.wallet.update(cash_deposit: 50) }
teams.each { |t| t.wallet.update(cash_deposit: 50) }
stocks.each { |s| s.wallet.update(cash_deposit: 50) }

transactions = [{ amount: 10, from_wallet: users[3].wallet, to_wallet: users[0].wallet},
                { amount: 10, from_wallet: users[3].wallet, to_wallet: users[1].wallet},
                { amount: 10, from_wallet: users[3].wallet, to_wallet: users[2].wallet},
                { amount: 10, from_wallet: users[2].wallet, to_wallet: users[0].wallet},
                { amount: 10, from_wallet: users[2].wallet, to_wallet: users[1].wallet}]

transactions = Transaction.create(transactions)
transactions.each do |t|
  t.update(aasm_state: "succeed")
end


# transactions = [{ amount: 10, from_wallet: users[3].wallet, to_wallet: users[0].wallet},
#                 { amount: 10, from_wallet: users[3].wallet, to_wallet: users[1].wallet},
#                 { amount: 10, from_wallet: users[3].wallet, to_wallet: users[2].wallet},
#                 { amount: 10, from_wallet: users[2].wallet, to_wallet: users[0].wallet},
#                 { amount: 10, from_wallet: users[2].wallet, to_wallet: users[1].wallet}]

# transactions = Transaction.create(transactions)
# transactions.each do |t|
#   t.accept!
#   TransactionsWorker.perform_async(t.id)
# end


