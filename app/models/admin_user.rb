# == Schema Information
#
# Table name: admins
#
#  id              :bigint(8)        not null, primary key
#  email           :string           not null
#  full_name       :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_admins_on_email  (email) UNIQUE
#

class AdminUser < ApplicationRecord
  include FullName

  has_secure_password

  self.table_name = 'admins'

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, length: {minimum: 8}
end
