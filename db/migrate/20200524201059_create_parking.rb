class CreateParking < ActiveRecord::Migration[5.0]
  def change
    create_table :parkings do |t|
      t.string :plate
      t.boolean :paid, default: false
      t.boolean :left, default: false
      t.timestamps
    end
  end
end
