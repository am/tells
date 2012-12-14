class CleanTable < ActiveRecord::Migration
  def up
    remove_column :tells, :name
    remove_column :tells, :published
  end

  def down
    add_column :tells, :name, :string
    add_column :tells, :published, :date
  end
end
