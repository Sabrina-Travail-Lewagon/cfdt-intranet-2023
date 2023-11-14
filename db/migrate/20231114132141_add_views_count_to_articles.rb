class AddViewsCountToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :views_count, :integer
  end
end
