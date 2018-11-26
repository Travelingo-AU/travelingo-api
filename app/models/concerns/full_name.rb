module FullName
  extend ActiveSupport::Concern

  attr_reader :first_name, :last_name

  def full_name=(value)
    if (value.present?)
      name_parts              = value.split(/\s+/)
      @first_name, @last_name = [name_parts.shift, name_parts.slice(-1, 1)]
    else
      @first_name, @last_name = [nil] * 2
    end

    super
  end
end
