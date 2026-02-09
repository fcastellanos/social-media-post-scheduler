class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.datetime :scheduled_date

      t.timestamps
    end
  end
end
