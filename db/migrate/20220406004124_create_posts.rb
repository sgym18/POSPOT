class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :spot, null: false
      t.text :caption, null: false
      t.string :address, null: false
      t.float :longitude, null: false
      t.float :latitude, null: false


      t.timestamps
    end
  end
end
