class CreateGistContents < ActiveRecord::Migration[5.2]
  def change
    create_table :gist_contents do |t|
      t.string :content
      t.references :link, foreign_key: true, null: true

      t.timestamps
    end
  end
end
