class CreateLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :phone
      t.text :message
      t.string :selected_vehicle
      t.decimal :decimal
      t.string :year
      t.string :link

      t.timestamps
    end
  end
end
