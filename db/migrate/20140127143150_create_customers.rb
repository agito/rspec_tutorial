class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|

      t.string :username, null: false
      t.string :password_digest
      t.string :family_name, null: false
      t.string :given_name, null: false
      t.string :family_name_kana, null: false
      t.string :given_name_kana, null: false

      t.timestamps
    end
  end
end
