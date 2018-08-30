ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :full_name, :email, :email_verified, :dob, :mobile, :picture_url,
                :firebase_user_uid, :firebase_meta, :role
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

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
      f.input :mobile
      f.input :role
    end

    f.actions
  end

end
