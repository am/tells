class CreateTells < ActiveRecord::Migration
  def change
    create_table :tells do |t|
      t.string :name
      t.string :message
      t.date :published

      t.timestamps
    end
  end
end
