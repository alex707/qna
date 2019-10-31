class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :voteable, polymorphic: true, null: false
      t.string :value, null: false

      t.timestamps
    end
    add_index :votes, [:user_id, :voteable_type, :voteable_id], unique: true
  end
end
