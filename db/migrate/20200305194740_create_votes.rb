class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value, null: false, default: 1
      t.references :votable, null: false, polymorphic: true
      t.references :voter, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :votes, [:voter_id, :votable_id, :votable_type], unique: true
  end
end
