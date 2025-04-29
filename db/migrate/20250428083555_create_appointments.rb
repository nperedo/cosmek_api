class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.datetime :time
      t.integer :duration
      t.string :status
      t.references :customer, null: false, foreign_key: true
      t.references :stylist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
