class CreateAccessories < ActiveRecord::Migration[7.0]
  def change
    create_table :accessories do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
