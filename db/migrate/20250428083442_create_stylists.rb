class CreateStylists < ActiveRecord::Migration[8.0]
  def change
    create_table :stylists do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
