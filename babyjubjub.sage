pari.allocatemem(10^9)

import hashlib
babyjubjubr = 2736030358979909402780800718157159386076813972158567259200215660948447373041
babyjubjubq = 21888242871839275222246405745257275088548364400416034343698204186575808495617

Fq = GF(babyjubjubq)
print(Fq.primitive_element())
Fr = GF(babyjubjubr)

a = Fq(168700)
d = Fq(168696)
base_x = Fq(16540640123574156134436876038791482806971768689494387082833631921987005038935)
base_y = Fq(20819045374670962167435360035096875258406992893633759881276124905556507972311)

# convert edwards to montgomery
A = 2*(a+d)/(a-d)
B = 4/(a-d)
base_u = (1+base_y)/(1-base_y)
base_v = base_u/base_x

# convert montgomery to weierstrass
wa = (3-A^2)/(3*B^2)
wb = (2*A^3-9*A)/(27*B^3)
x0, y0 = (base_u+A/3)/B, base_v/B

Ebjj = EllipticCurve(Fq, [wa, wb])
a = Ebjj.random_point()
b = Ebjj.random_point()

g = Ebjj.random_point()

g0 = Ebjj(10480227264716662452755474067665177302533350463766626583754719465282143096156,
8369223176222797522123539354678750082493875221914526607111902450577289923070)
g1 = Ebjj(11880246950178646564845070742914370409150886704747897303831567178374129810211,
11568178448482280388943253237660832271540088086331062617007232034122551287432)
h0 = Ebjj(3168195724794061035067437460306519652998969886362841281644734115844445886185,
8489771060550565563483479806652696626788502212157814537990951108069267515955)
h1 = Ebjj(12239960479043393909262572194446271981202432681542270714195285876953060316412,
16901143140203092244252603065645010058104514960352419130166756310402509981799)

Scalars = GF(Ebjj.cardinality() / 8)

def random_value(prefix, i):
  return int(hashlib.sha256('%s%d' % (prefix, i)).hexdigest(), 16)

def prove_prime(w, s):
  [x0, x1, x2, x3, x4, x5, x6, b0, b1] = w
  [y, g0, g1, h0, h1, c0, c1, c2, c3, c4] = s

  A0 = c0
  A1 = c1
  A2 = c2
  A3 = c0 - c1 + c2
  A4 = c1 - c2 + c4
  A5 = c3
  A6 = c1 - c2 + c3 + c4

  r0 = Integer(Scalars.random_element())
  r1 = Integer(Scalars.random_element())
  r2 = Integer(Scalars.random_element())
  r3 = Integer(Scalars.random_element())

  s0 = Integer(Scalars.random_element())
  s1 = Integer(Scalars.random_element())
  s2 = Integer(Scalars.random_element())
  s3 = Integer(Scalars.random_element())
  s4 = Integer(Scalars.random_element())
  s5 = Integer(Scalars.random_element())

  R0 = r0*g0
  R1 = r1*(g0 - h0 + y)
  R2 = r2*h1
  R3 = r3*(g0 + h1)
  S0 = s0*g1 + s1*h0
  T0 = (s0*b0)*g1 + s2*h0
  S1 = s3*g1 + s4*y
  T1 = s4*g1 + s5*y

  a0 = random_value('1', 1)
  a1 = random_value('1', 1)
  a2 = random_value('1', 1)
  a3 = random_value('1', 1)
  a4 = random_value('1', 1)
  a5 = random_value('1', 1)
  a6 = random_value('1', 1)

  d0 = r0 + a0*x0 + a5*x5
  u0 = s0 + a1*b0
  v0 = s1 + a1*x1
  w0 = s2 + x1*(a1 - u0)
  u1 = s3 + a2*b1
  v1 = s4 + a2*x2
  w1 = s5 + x2*(a2 - u1)
  d1 = r1 + a3*x3
  d2 = r2 + a4*x4
  d3 = r3 + a6*x6

  # check : d0 g0 = R0 + a0 A0 + a5 A5
  assert d0*g0 == R0 + a0*A0 + a5*A5

  # check : u0 g1 + v0 h0 = S0 + a1 A1
  assert u0*g1 + v0*h0 == S0 + a1*A1

  # check : w0 h0 = T0 + (a1 - u0) A1
  assert w0*h0 == T0 + (a1 - u0)*A1

  # check : u1 g1 + v1 y = S1 + a2 A2
  assert u1*g1 + v1*y == S1 + a2*A2

  # check : w1 y = T1 + (a2 - u1) A2
  # assert w1*y == T1 + (a2 - u1)*A2

  # check : d1 ( g0 - h0 + y) = R1 + a3 A3
  assert d1*(g0 - h0 + y) == R1 + a3*A3

  # check : d2 h1 = R2 + a4 A4
  assert d2*h1 == R2 + a4*A4

  # check : d3 (g0 + h1) = R3 + a6 A6
  assert d3*(g0 + h1) == R3 + a6*A6

  print(a[0])

  print(R0[0])
  print(R0[1])

  print(R1[0])
  print(R1[1])

  print(R2[0])
  print(R2[1])

  print(R3[0])
  print(R3[1])

  print(S0[0])
  print(S0[1])

  print(S1[0])
  print(S1[1])

  print(T0[0])
  print(T0[1])

  print(T1[0])
  print(T1[1])

  print(Fr(d0))
  print(Fr(d1))
  print(Fr(d2))
  print(Fr(d3))
  print(Fr(u0))
  print(Fr(v0))
  print(Fr(w0))
  print(Fr(u1))
  print(Fr(v1))
  print(Fr(w1))

  JUBJUBE = 21888242871839275222246405745257275088614511777268538073601725287587578984328
  JUBJUBC = 8
  JUBJUBA = 168700
  JUBJUBD = 168696
  MONTA = 168698
  MONTB = 1
  infinity = [0, 1]
  Gu = 16540640123574156134436876038791482806971768689494387082833631921987005038935
  Gv = 20819045374670962167435360035096875258406992893633759881276124905556507972311
 
  #         0       1         2            3         4   5      6       7        8      9
  # return [JUBJUBA, JUBJUBD, infinity[0], infinity[1], Gu, Gv, JUBJUBE, JUBJUBC, MONTA, MONTB]
  
  print(JUBJUBA)
  print(JUBJUBD)
  print(infinity[0])
  print(infinity[1])
  print(Gu)
  print(Gv)
  print(JUBJUBE)
  print(JUBJUBC)
  print(MONTA)
  print(MONTB)

Ebjj = EllipticCurve(Fq, [wa, wb])
a = Ebjj.random_point()
b = Ebjj.random_point()

g = Ebjj(13037949799327265748286426706936349024124924757595405599698606380497400784347, 393589182837104319763301766843923249088483507277002073284380207823253619313)
g0 = Ebjj(10480227264716662452755474067665177302533350463766626583754719465282143096156,
8369223176222797522123539354678750082493875221914526607111902450577289923070)
g1 = Ebjj(11880246950178646564845070742914370409150886704747897303831567178374129810211,
11568178448482280388943253237660832271540088086331062617007232034122551287432)
h0 = Ebjj(3168195724794061035067437460306519652998969886362841281644734115844445886185,
8489771060550565563483479806652696626788502212157814537990951108069267515955)
h1 = Ebjj(12239960479043393909262572194446271981202432681542270714195285876953060316412,
16901143140203092244252603065645010058104514960352419130166756310402509981799)

Scalars = GF(Ebjj.cardinality() / 8)

x = Integer(1)
x0 = Integer(1)
x1 = Integer(1)
x2 = Integer(1)
x3 = Integer(1)
x4 = Integer(1)
x5 = Integer(1)
x6 = Integer(1)
y = x*g

b = Integer(1)
b0 = Integer(1)
b1 = Integer(1)
c0 = x*g0
c1 = b*g1+x*h0
c2 = b*g1+x*y
c3 = x*g0
c4 = x*(y-h0)+x*h1

"""
# A0 = x0 g0 = c0
A0 = x0*g0
# A1 = b0 g1 + x1 h0 = c1
A1 = b0*g1+x1*h0
# A2 = b1 g1 + x2 y = c2
A2 = b1*g1+x2*y
# A3 = x3 (g0 - h0 + y) = c0 - c1 + c2
A3 = x3*(g0-h0+y)
# A4 = x4 h1 = c0 - c2 + c4
A4 = x4*h1
# A5 = x5 g0 = c3
A5 = x5*g0
# A6 = x6 (g0 + h1) = c1 - c2 + c3 + c4
A6 = x6*(g0+h1)
"""
s = [y, g0, g1, h0, h1, c0, c1, c2, c3, c4]
w = [x, x, x, x, x, x, x, b, b]

prove_prime(w, s)

# print(hashlib.sha256(c0 + c1 + c2 + c3))
