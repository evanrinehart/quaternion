class Q

  attr_reader :a, :b, :c, :d

  class DivZeroError < StandardError; end

  def initialize a, b, c, d
    @a = a
    @b = b
    @c = c
    @d = d
  end

  ZERO = Q.new(0,0,0,0)
  ONE = Q.new(1,0,0,0)


  def + y
    x = self
    Q.new(
      x.a + y.a, x.b + y.b,
      x.c + y.c, x.d + y.d
    )
  end

  def - y
    self + y.neg
  end

  def * y
    x = self
    Q.new(
      x.a*y.a - x.b*y.b - x.c*y.c - x.d*y.d,
      x.a*y.b + x.b*y.a + x.c*y.d - x.d*y.c,
      x.a*y.c - x.b*y.d + x.c*y.a + x.d*y.b,
      x.a*y.d + x.b*y.c - x.c*y.b + x.d*y.a
    )
  end

  def conj
    Q.new(a, -b, -c, -d)
  end

  def neg
    Q.new(-a, -b, -c, -d)
  end

  def norm_squared
    a*a + b*b + c*c + d*d
  end

  def norm
    Math.sqrt(norm_squared)
  end

  def scale s
    Q.new(s*a, s*b, s*c, s*d)
  end

  def normalize
    raise DivZeroError if zero?
    scale (1.0 / norm)
  end

  def recip
    raise DivZeroError if zero?
    conj.scale(1.0 / norm_squared)
  end

  def zero?
    norm_squared.zero?
  end

  def left_div q
    q.recip * self
  end

  def right_div q
    self * q.recip
  end

  def vector
    [b,c,d]
  end

  def rotate v
    q1 = Q.new(0, v[0], v[1], v[2])
    q2 = self * q1 * self.recip
    [q2.b, q2.c, q2.d]
  end

  def with_a a
    Q.new(a, b, c, d)
  end

  def self.from_axis_angle axis, angle
    q_axis = Q.new(0, axis[0], axis[1], axis[2])
    unit_axis = q_axis.normalize
    l = Math.cos (angle.to_f / 2)
    r = Math.sin (angle.to_f / 2)
    unit_axis.scale(r).with_a(l)
  end

end
