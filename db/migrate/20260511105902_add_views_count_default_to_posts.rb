class AddViewsCountDefaultToPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :posts, :views_count, 0
  end
end
