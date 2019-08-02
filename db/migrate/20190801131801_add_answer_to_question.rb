class AddAnswerToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :accepted, foreign_key: { to_table: :answers }, null: true
  end
end
