class CreatePostSubJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :posts, :subs, table_name: :post_subs do |t|
      t.index [:post_id, :sub_id]
      t.index [:sub_id, :post_id], unique: true
    end
  end
end
