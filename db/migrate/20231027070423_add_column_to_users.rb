class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :photo, :string
    # add_reference :articles, :user, null: false, foreign_key: true
  end
end
