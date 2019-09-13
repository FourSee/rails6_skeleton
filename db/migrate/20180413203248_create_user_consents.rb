class CreateUserConsents < ActiveRecord::Migration[5.2]
  def change
    create_table :user_consents do |t|
      t.belongs_to :user
      t.belongs_to :consent
      t.boolean :consented, default: false, null: false
      t.boolean :up_to_date, default: true, null: false

      t.timestamps
    end

    # add_index :user_consents, :user, unique: true
  end
end
