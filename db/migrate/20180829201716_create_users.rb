class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: {unique: true}
      t.boolean :email_verified, null: false, default: false
      t.string :full_name, null: false
      t.string :firebase_user_uid, null: false
      t.jsonb :firebase_meta, null: false, default: {}
      t.date :dob
      t.string :picture_url
      t.string :mobile
      t.string :role

      t.timestamps null: false
    end
  end
end
