class AddDescriptionToBookmarks < ActiveRecord::Migration[5.2]
  def change
    add_column :bookmarks, :description, :text
  end
end
