class AddExtractedTextToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :extracted_text, :text
  end
end
