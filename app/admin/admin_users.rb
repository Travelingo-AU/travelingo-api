ActiveAdmin.register AdminUser do
  permit_params :email, :full_name, :password, :password_confirmation

  index do
    selectable_column
    id_column

    column :full_name
    column :email
    column :created_at

    actions
  end

  filter :email
  filter :full_name
  filter :created_at

  show do
    attributes_table do
      row :full_name
      row :email
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :full_name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
