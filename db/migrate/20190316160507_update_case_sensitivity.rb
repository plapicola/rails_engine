class UpdateCaseSensitivity < ActiveRecord::Migration[5.1]
  def up
    enable_extension('citext')

    change_column :customers, :first_name, :citext
    change_column :customers, :last_name, :citext
    change_column :items, :name, :citext
    change_column :items, :description, :citext
    change_column :merchants, :name, :citext
  end

  def down
    change_column :customers, :first_name, :string
    change_column :customers, :last_name, :string
    change_column :items, :name, :string
    change_column :items, :description, :text
    change_column :merchants, :name, :string
  end
end
