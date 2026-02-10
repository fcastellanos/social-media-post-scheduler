class AddIndexToScheduledDateOnPosts < ActiveRecord::Migration[8.1]
  def up
    return if index_exists?(:posts, :scheduled_date)

    add_index :posts, :scheduled_date
  end

  def down
    if index_exists?(:posts, :scheduled_date)
      remove_index :posts, column: :scheduled_date
    end
  end
end
