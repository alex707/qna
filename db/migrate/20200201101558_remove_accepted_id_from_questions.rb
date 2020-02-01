class RemoveAcceptedIdFromQuestions < ActiveRecord::Migration[5.2]
  def change
    return unless column_exists?(:questions, :accepted_id)

    remove_column(:questions, :accepted_id)
  end
end
