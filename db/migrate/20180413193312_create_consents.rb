class CreateConsents < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'uuid-ossp'

    create_table :consents do |t|
      t.uuid :uuid, default: 'uuid_generate_v4()'
      t.timestamps
    end

    add_index :consents, :uuid, unique: true
  end
end
