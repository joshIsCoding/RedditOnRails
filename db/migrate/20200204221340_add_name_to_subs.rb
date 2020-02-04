class AddNameToSubs < ActiveRecord::Migration[6.0]
  def change
    add_column :subs, :name, :string, null: false
  end
end
