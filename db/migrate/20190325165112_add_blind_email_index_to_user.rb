class AddBlindEmailIndexToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_bidx, :string
    add_index :users, :email_bidx, unique: true
  end
end
