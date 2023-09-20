# Promos phases
module DateRanges
  def before_promo?
    Time.now.before?(Time.new(2022, 8, 1))
  end

  def during_promo?
    time_now = Time.now
    time_now.after?(Time.new(2022, 8, 1)) && time_now.before?(Time.new(2022, 9, 20))
  end

  def after_promo?
    Time.now.after?(Time.new(2022, 9, 20))
  end
end
