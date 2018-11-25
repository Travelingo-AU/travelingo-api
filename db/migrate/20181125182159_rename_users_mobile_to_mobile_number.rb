class RenameUsersMobileToMobileNumber < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :mobile, :mobile_number
  end
end
