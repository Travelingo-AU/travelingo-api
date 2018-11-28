module FullName
  extend ActiveSupport::Concern

  attr_reader :first_name, :last_name

  def full_name=(value)
    value      = String(value).strip
    name_parts = value.split(/\s+/)

    # Take really last part as a last_name
    @first_name, @last_name = [name_parts.shift, name_parts[-1]]

    super
  end
end
