class CreateAddresses < ActiveRecord::Migration
  create_table :addresses do |t|
    t.string :address, null: false
    t.references :user
    t.timestamps
  end
end
