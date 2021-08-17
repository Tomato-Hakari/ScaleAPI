class CreateScaleData < ActiveRecord::Migration[6.1]
  def change
    create_table :scale_data do |t|
      t.string :date
      t.string :keydata
      t.string :model
      t.string :tag

      t.timestamps
    end
  end
end
