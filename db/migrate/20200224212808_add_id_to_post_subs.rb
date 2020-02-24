class AddIdToPostSubs < ActiveRecord::Migration[6.0]
  def change
    add_column :post_subs, :id, :primary_key
  end
end
