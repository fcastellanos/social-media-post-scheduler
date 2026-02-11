class AddPropertyToPost < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :property, null: true, foreign_key: { to_table: :properties }
  end
end
