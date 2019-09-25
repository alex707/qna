class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :name
      t.references :question, foreign_key: true
      t.references :user, foreign_key: true, null: true

      t.timestamps
    end
  end
end
