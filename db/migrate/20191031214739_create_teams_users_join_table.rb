class CreateTeamsUsersJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :teams_users, id: false do |t|
      t.bigint :team_id
      t.bigint :user_id
    end

    add_index :teams_users, :team_id
    add_index :teams_users, :user_id
  end
end
