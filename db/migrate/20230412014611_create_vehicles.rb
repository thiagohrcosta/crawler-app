class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.references :lead, null: false, foreign_key: true
      t.string :brand
      t.string :model
      t.decimal :km

      t.timestamps
    end
  end
end
