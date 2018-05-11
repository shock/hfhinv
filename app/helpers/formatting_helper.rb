module FormattingHelper
  def format_phone_number(number)
    digits = number.gsub(/[^\d]/, '')
    if digits.length == 11 and digits[0] == 1
      digits.unshift
    end
    if digits.length < 10 || digits.length > 10
      raise "Invalid phone number.  Must be a ten digit number."
    end
    "(#{digits.slice(0,3)})-#{digits.slice(3,3)}-#{digits.slice(6,4)}"
  end

  def normal_date(date)
    date.strftime("%b %e, %Y")
  end

  def dotw(date)
    Date::DAYNAMES[date.wday].slice(0,3).upcase rescue "N/A"
  end
end