class RemovePublishedFromPosts < ActiveRecord::Migration[8.1]
  def change
    remove_column :posts, :published, :boolean
  end
end
