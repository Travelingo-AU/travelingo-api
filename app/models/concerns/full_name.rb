module FullName
  extend ActiveSupport::Concern

  def first_name
    (self[:full_name].split(/\s+/)[0]) if self[:full_name].present?
  end

  def last_name
    (self[:full_name].split(/\s+/)[1]) if self[:full_name].present?
  end
end
