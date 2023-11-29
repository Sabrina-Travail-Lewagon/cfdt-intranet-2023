class AddBackgroundColorToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :background_color, :string
  end
end
