# == Schema Information
#
# Table name: firebase_certs
#
#  id         :bigint(8)        not null, primary key
#  kid        :string           not null
#  content    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_firebase_certs_on_kid  (kid) UNIQUE
#

class FirebaseCert < ApplicationRecord
  validates_presence_of :kid, :content
end
