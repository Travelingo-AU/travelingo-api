# == Schema Information
#
# Table name: users
#
#  id                :bigint(8)        not null, primary key
#  email             :string           not null
#  email_verified    :boolean          default(FALSE), not null
#  full_name         :string           not null
#  firebase_user_uid :string           not null
#  firebase_meta     :jsonb            not null
#  dob               :date
#  picture_url       :string
#  mobile            :string
#  role              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  include FullName


  #
  # ATTRIBUTES
  #

  attr_readonly :firebase_uid

  # See http://api.rubyonrails.org/classes/ActiveRecord/Store.html
  store_accessor :firebase_meta, [:identities, :sign_in_provider]

  def first_name
    (self[:full_name].split(/\s+/)[0]) if self[:full_name].present?
  end

  def last_name
    (self[:full_name].split(/\s+/)[1]) if self[:full_name].present?
  end


  #
  # VALIDATION
  #

  # Normalizes the attribute itself before validation
  phony_normalize :mobile

  #
  # LOGIC
  #

  def anonymous?
    sign_in_provider == 'anonymous'
  end

  # NOTE: we don't take email here, it may override  the one passed by user on sign-up.
  # REVIEW: But we take new picture if it was changed on FB side
  # User is a 'Information expert' here, so keeping this transformation here
  def assign_attributes_from_jwt_payload(jwt_payload)
    payload_to_attrs = {firebase_user_uid: jwt_payload['sub'],
                        firebase_meta:     jwt_payload['firebase'],
                        picture_url:       jwt_payload['picture']}

    assign_attributes(payload_to_attrs)
  end

  #
  # GRAPE ENTITIES
  #

  # This is basic profile info safe to be viewed by DJ or other Users
  class Entity < Grape::Entity
    expose :id, documentation: {type: Integer, desc: 'User ID'}
    expose :email, documentation: {type: String, desc: 'User email'}
    expose :mobile, documentation: {type: String, desc: 'User mobile'}
    expose :dob, documentation: {type: String, desc: 'User DOB'}
    expose :full_name, documentation: {type: String, desc: 'User full name'}
    expose :first_name, documentation: {type: String, desc: 'User first name'}
    expose :last_name, documentation: {type: String, desc: 'User last name'}
    expose :firebase_user_uid, documentation: {type: String, desc: 'Firebase User UID'}
    expose :sign_in_provider, documentation: {type: String, desc: 'User sign-in provider'}
    expose :picture_url, documentation: {type: String, desc: 'User avatar'}
    expose :created_at, documentation: {type: String, desc: 'User created at date time'}
    expose :updated_at, documentation: {type: String, desc: 'User updated at date time'}
  end
end
