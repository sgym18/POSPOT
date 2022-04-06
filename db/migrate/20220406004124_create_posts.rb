class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :spot
      t.text :caption
      t.string :address
      t.float :longitude
      t.float :latitude
      

      t.timestamps
    end
  end
end
