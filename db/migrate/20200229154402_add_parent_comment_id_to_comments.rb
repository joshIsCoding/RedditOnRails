class AddParentCommentIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :parent_comment, null: true, foreign_key: { to_table: :comments }
  end
end
