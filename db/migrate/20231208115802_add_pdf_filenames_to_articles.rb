class AddPdfFilenamesToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :pdf_filenames, :string
  end
end
