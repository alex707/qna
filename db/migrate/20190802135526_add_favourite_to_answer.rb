class AddFavouriteToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :favourite, :boolean, default: false, null: false
  end
end
