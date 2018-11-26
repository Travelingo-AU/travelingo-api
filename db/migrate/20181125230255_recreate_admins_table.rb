class RecreateAdminsTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :admin_users

    create_table :admins, force: :cascade do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :full_name, null: false
      t.string :password_digest, null: false
      t.timestamps(null: false)
    end
  end

  def down
    create_table "admin_users", force: :cascade do |t|
      t.string "full_name", null: false
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["email"], name: "index_admin_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    end

    drop_table :admins
  end
end
