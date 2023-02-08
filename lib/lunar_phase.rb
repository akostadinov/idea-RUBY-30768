require "time"

module LunarPhase
  LUNAR_MONTH = 29.530588853
  JULIAN_YEAR = 365.25
  J2000 = DateTime.new(2000, 1, 1, 12, 0, 0).amjd.to_f
  KNOWN_NEW_MOON = DateTime.new(2000, 1, 6, 6, 14, 0).amjd.to_f

  module ClassMethods
    # credits to https://celestialprogramming.com/meeus-illuminated_fraction_of_the_moon.html
    # some more clues at https://en.wikipedia.org/wiki/Full_moon
    # rubocop:disable all
    def illumination(time = DateTime.now)
      t = centuries_since_j2000(time)

      d = rad(297.8501921 + 445267.1114034*t - 0.0018819*t*t + 1.0/545868.0*t*t*t - 1.0/113065000.0*t*t*t*t) #47.2
      m = rad(357.5291092 + 35999.0502909*t - 0.0001536*t*t + 1.0/24490000.0*t*t*t) #47.3
      mp = rad(134.9633964 + 477198.8675055*t + 0.0087414*t*t + 1.0/69699.0*t*t*t - 1.0/14712000.0*t*t*t*t) #47.4

      i = rad(180 - d*180/Math::PI - 6.289 * Math.sin(mp) + 2.1 * Math.sin(m) -1.274 * Math.sin(2*d - mp) -0.658 * Math.sin(2*d) -0.214 * Math.sin(2*mp) -0.11 * Math.sin(d)) #48.4
      (1+Math.cos(i))/2
    end
    # rubocop:enable all

    def percent(time = DateTime.now)
      age(time) / LUNAR_MONTH
    end

    def age(time = DateTime.now)
      age_from_known = time.to_datetime.amjd - KNOWN_NEW_MOON
      age_from_known += LUNAR_MONTH if age_from_known.negative?
      age_from_known % LUNAR_MONTH
    end

    def full?(time = DateTime.now)
      illumination(time) > 0.98
    end

    private

    def centuries_since_j2000(time = DateTime.now)
      (time.to_datetime.amjd.to_f - J2000) / (JULIAN_YEAR * 100)
    end

    def rad(num)
      angle = num % 360
      angle += 360 if angle.negative?
      angle * Math::PI / 180
    end
  end

  extend ClassMethods
end
