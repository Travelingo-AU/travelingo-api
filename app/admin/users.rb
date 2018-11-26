ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :full_name, :email, :email_verified, :dob, :mobile_number, :picture_url,
                :firebase_user_uid, :firebase_meta, :role
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #

  index do
    selectable_column

    column 'Image', :picture_url do |user|
      image_tag user.picture_url, class: %w[aa-user-picture-index aa-user-picture]
    end

    id_column

    column :full_name
    column :email
    column :mobile_number
    column :dob
    column :firebase_user_uid

    actions
  end

  show do
    attributes_table do
      row :image do |user|
        image_tag user.picture_url, class: %w[aa-user-picture-show aa-user-picture]
      end

      row :full_name
      row :email
      row :mobile_number
      row :dob
      row :firebase_user_uid

      row :firebase_meta do |user|
        content_tag(:pre) do
          JSON.pretty_generate(user.firebase_meta || {})
        end
      end
    end
  end


  json_editor

  form do |f|
    f.inputs do
      f.input :full_name
      f.input :email
      f.input :email_verified
      f.input :firebase_user_uid
      f.input :firebase_meta, as: :jsonb
      f.input :dob
      f.input :picture_url
      f.input :mobile_number
      f.input :role
    end

    f.actions
  end

end
