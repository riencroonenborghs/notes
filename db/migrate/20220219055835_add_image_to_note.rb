class AddImageToNote < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :image_uid,  :string    
  end
end
