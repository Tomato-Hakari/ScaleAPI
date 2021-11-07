class AddIsDeleteToScaleData < ActiveRecord::Migration[6.1]
  def change
    add_column :scale_data, :isDelete, :boolean, null: false, default: true
  end
end
