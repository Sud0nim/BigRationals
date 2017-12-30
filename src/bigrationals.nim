import math, hashes, bigints

type BigRational* = object
  ## a rational number, consisting of a numerator and denominator
  num*, den*: BigInt

proc initBigRational*(num, den: int | string | BigInt): BigRational =
  ## Creates a new big rational number.
  assert(initBigInt(den) != initBigInt(0), "A denominator of zero value is invalid.")
  result.num = initBigInt(num)
  result.den = initBigInt(den)

proc `//`*(num, den: int | string | BigInt): BigRational = 
  ## A shorthand version of `initBigRational`. Example usage:
  ##
  ## .. code-block:: nim
  ##   var a = initBigInt(1)//3 + 1//"5"
  result = initBigRational(num, den)

proc `$`*(a: BigRational): string =
  ## Turn a big rational number into a string.
  result = $a.num & "/" & $a.den

proc toBigRational*(a: int | string | BigInt): BigRational =
  ## Convert integer, big int or numerical string `a` in to a big rational number.
  result.num = initBigInt(a)
  result.den = initBigInt(1)

proc toBigRational*(a: BigRational): BigRational =
  ## Copy big rational number `a`.
  result = a

proc toBigInt*(a: BigRational): BigInt =
  ## Convert a rational number `a` to it's quotient.
  ## The remainder is discarded.
  result = a.num div a.den

proc abs(a: BigInt): BigInt =
  ## Returns the absolute value of `a`.
  result = a
  result.flags = {}

proc gcd*(a, b: BigInt): BigInt =
  ## Returns the greatest common denominator for `a` and `b` as a big int.
  var (a, b) = (a, b)
  while b != 0:
    a = a mod b
    swap(a, b)
  abs(a)

proc reduce*(a: var BigRational) =
  ## Reduce big rational `a`.
  let common = gcd(a.num, a.den)
  if a.den > 0:
    a.num = a.num div common
    a.den = a.den div common
  elif a.den < 0:
    a.num = -a.num div common
    a.den = -a.den div common
  else:
    raise newException(DivByZeroError, "Division by zero.")
    
proc `+` *(a, b: BigRational): BigRational =
  ## Add two big rational numbers.
  let common = lcm(a.den, b.den)
  result.num = common div a.den * a.num + common div b.den * b.num
  result.den = common
  reduce(result)

proc `+` *(a: BigRational, b: int | string | BigInt): BigRational =
  ## Add big rational `a` to an int, big int or numerical string `b`.
  result.num = a.num + initBigInt(b) * a.den
  result.den = a.den

proc `+` *(a: int | string | BigInt, b: BigRational): BigRational =
  ## Add an int, big int or numerical string `a` to big rational `b`.
  result.num = initBigInt(a) * b.den + b.num
  result.den = b.den

proc `+=` *(a: var BigRational, b: BigRational) =
  ## Add big rational `b` to big rational `a`.
  let common = lcm(a.den, b.den)
  a.num = common div a.den * a.num + common div b.den * b.num
  a.den = common
  reduce(a)

proc `+=` *(a: var BigRational, b: int | string | BigInt) =
  ## Add an int, big int or numerical string `b` to big rational `a`.
  a.num += initBigInt(b) * a.den

proc `-` *(a: BigRational): BigRational =
  ## Unary minus for big rational numbers.
  result.num = -a.num
  result.den = a.den

proc `-` *(a, b: BigRational): BigRational =
  ## Subtract two big rational numbers.
  let common = lcm(a.den, b.den)
  result.num = common div a.den * a.num - common div b.den * b.num
  result.den = common
  reduce(result)

proc `-` *(a: BigRational, b: int | string | BigInt): BigRational =
  ## Subtract an int, big int or numerical string `b` from big rational `a`.
  result.num = a.num - initBigInt(b) * a.den
  result.den = a.den

proc `-` *(a: int | string | BigInt, b: BigRational): BigRational =
  ## Subtract big rational `b` from an int, big int or numerical string `a`.
  result.num = initBigInt(a) * b.den - b.num
  result.den = b.den

proc `-=` *(a: var BigRational, b: BigRational) =
  ## Subtract big rational `b` from big rational `a`.
  let common = lcm(a.den, b.den)
  a.num = common div a.den * a.num - common div b.den * b.num
  a.den = common
  reduce(a)

proc `-=` *(a: var BigRational, b: int | string | BigInt) =
  ## Subtract an int, big int or numerical string `b` from big rational `a`.
  a.num -= initBigInt(b) * a.den

proc `*` *(a, b: BigRational): BigRational =
  ## Multiply two rational numbers.
  result.num = a.num * b.num
  result.den = a.den * b.den
  reduce(result)

proc `*` *(a: BigRational, b: int | string | BigInt): BigRational =
  ## Multiply big rational `a` by an int, big int or numerical string `b`.
  result.num = a.num * initBigInt(b)
  result.den = a.den
  reduce(result)

proc `*` *(a: int | string | BigInt, b: BigRational): BigRational =
  ## Multiply an int, big int or numerical string `a` by big rational `b`.
  result.num = initBigInt(a) * b.num
  result.den = b.den
  reduce(result)

proc `*=` *(a: var BigRational, b: BigRational) =
  ## Multiply big rational `a` by `b`.
  a.num *= b.num
  a.den *= b.den
  reduce(a)

proc `*=` *(a: var BigRational, b: int | string | BigInt) =
  ## Multiply big rational `a` by an int, big int or numerical string `b`.
  a.num *= initBigInt(b)
  reduce(a)

proc reciprocal*(a: BigRational): BigRational =
  ## Calculate the reciprocal of big rational `a`, equivalent to: 1 / a
  if a.num > 0:
    result.num = a.den
    result.den = a.num
  elif a.num < 0:
    result.num = -a.den
    result.den = -a.num
  else:
    raise newException(DivByZeroError, "division by zero")

proc `/`*(a, b: BigRational): BigRational =
  ## Divide big rational `a` by big rational `b`.
  result.num = a.num * b.den
  result.den = a.den * b.num
  reduce(result)

proc `/`*(a: BigRational, b: int | string | BigInt): BigRational =
  ## Divide big rational `a` by an int, big int or numerical string `b`.
  result.num = a.num
  result.den = a.den * initBigInt(b)
  reduce(result)

proc `/`*(a: int | string | BigInt, b: BigRational): BigRational =
  ## Divide an int, big int or numerical string `a` by big rational `b`.
  result.num = initBigInt(a) * b.den
  result.den = b.num
  reduce(result)

proc `/=`*(a: var BigRational, b: BigRational) =
  ## Divide big rationals `a` by `b` in place.
  a.num *= b.den
  a.den *= b.num
  reduce(a)

proc `/=`*(a: var BigRational, b: int | string | BigInt) =
  ## Divide big rational `a` by an int, big int or numerical string `b` in place.
  a.den *= initBigInt(b)
  reduce(a)
  
proc `>` *(a: BigInt, b: int32): bool = cmp(a, b) > 0
proc `>=` *(a: BigInt, b: int32): bool = cmp(a, b) >= 0
  
proc cmp*(a, b: int | string | BigInt | BigRational): BigInt =
  ## Compares two rationals.
  (a.toBigRational() - b.toBigRational()).num

proc `<` *(a, b: int | string | BigInt | BigRational): bool =
  ## Checks if a big rational number `a` has a value lower than another
  ## big rational number or any int, big int or string that can
  ## be converted to a big rational number `b`.
  (a.toBigRational() - b.toBigRational()).num < 0

proc `<=` *(a, b: int | string | BigInt | BigRational): bool =
  ## Checks if a big rational number `a` has a value lower than or equivalent 
  ## to another big rational number or any int, big int or string that can
  ## be converted to a big rational number `b`.
  (a.toBigRational() - b.toBigRational()).num <= 0

proc `>` *(a, b: int | string | BigInt | BigRational): bool =
  ## Checks if a big rational number `a` has a value greater than another
  ## big rational number or any int, big int or string that can
  ## be converted to a big rational number `b`.
  (a.toBigRational() - b.toBigRational()).num > 0

proc `>=` *(a, b: int | string | BigInt | BigRational): bool =
  ## Checks if a big rational number `a` has a value greater than or equivalent 
  ## to another big rational number or any int, big int or string that can
  ## be converted to a big rational number `b`.
  (a.toBigRational() - b.toBigRational()).num >= 0

proc `==` *(a, b: int | string | BigInt | BigRational): bool =
  ## Checks if a big rational number `a` has a value equivalent to another
  ## big rational number or any int, big int or string that can
  ## be converted to a big rational number `b`.
  (a.toBigRational() - b.toBigRational()).num == 0

proc `!=` * (a, b: int | string | BigInt | BigRational): bool =
  ## Checks if a big rational number `a` has a value not equivalent to another
  ## big rational number or any int, big int or string that can
  ## be converted to a big rational number `b`.
  if a == b:
    result = false
  else:
    result = true

proc abs*(a: BigRational): BigRational =
  ## Returns the absolute value of `a`.
  result.num = abs a.num
  result.den = abs a.den

proc hash*(a: BigRational): Hash =
  ## Computes hash for big rational `a`.
  # Reduce first so that hash(a) == hash(b) for a == b.
  var copy = a
  reduce(copy)

  var h: Hash = 0
  h = h !& hash(copy.num)
  h = h !& hash(copy.den)
  result = !$h

