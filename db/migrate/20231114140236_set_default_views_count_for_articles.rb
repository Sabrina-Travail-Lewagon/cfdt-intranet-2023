class SetDefaultViewsCountForArticles < ActiveRecord::Migration[7.0]
  def change
    change_column_default :articles, :views_count, from: nil, to: 0
  end
end
