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

  #
  # GRAPE ENTITIES
  #

  # This is basic profile info safe to be viewed by DJ or other Users
  class Entity < Grape::Entity
    expose :id, documentation: {type: Integer, desc: 'User ID'}
    expose :email, documentation: {type: String, desc: 'User email'}
    expose :first_name, documentation: {type: String, desc: 'User first name'}
    expose :last_name, documentation: {type: String, desc: 'User last name'}
    expose :firebase_user_uid, documentation: {type: String, desc: 'Firebase User UID'}
    expose :sign_in_provider, documentation: {type: String, desc: 'User sign-in provider'}
    expose :picture, documentation: {type: String, desc: 'User avatar'}
    expose :created_at, documentation: {type: String, desc: 'User created at date time'}
    expose :updated_at, documentation: {type: String, desc: 'User updated at date time'}
  end
end
