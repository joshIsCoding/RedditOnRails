class AddIndexToNameInSubs < ActiveRecord::Migration[6.0]
  def change
    add_index :subs, :name, unique: true
  end
end
