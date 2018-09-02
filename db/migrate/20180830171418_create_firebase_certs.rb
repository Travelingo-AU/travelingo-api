class CreateFirebaseCerts < ActiveRecord::Migration[5.2]
  def change
    create_table :firebase_certs do |t|
      t.string :kid, null: false, index: {unique: true}
      t.string :content, null: false
      t.timestamps null: false
    end
  end
end
