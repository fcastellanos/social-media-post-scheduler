class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.string :url
      t.string :caption
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
