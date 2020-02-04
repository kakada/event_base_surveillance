# frozen_string_literal: true

class String
  # Does this string represent an integer?
  def integer?
    Integer(self) rescue nil
  end

  def real?
    Float(self) rescue nil
  end
end
