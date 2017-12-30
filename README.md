# BigRationals

An arbitrary sized rational type based on the rationals module from the Nim standard library. The standard library implementation has been extended through the use of BigInts to allow for arbitrary sizing in the rationals type. Only some very minor changes and additions have been made to this implementation in order to maintain consistency between rational and bigrational APIs.

# Usage

**Initialisation**

```nim
var
  a = initBigRational("121211458858441234234", 2223)
  b = "-11821" // -212121221
  c = "99999999999999999999999999999999999999912121212" // "18121882"
  d = initBigInt(99999999) // "3"
  
echo a # 121211458858441234234/2223
echo b # -11821/-212121221
echo c # 99999999999999999999999999999999999999912121212/18121882
echo d # 99999999/3
```

**Arithmetic Operations**

```nim
var
  a = initBigRational("121211458858441234234", 2223)
  b = "-11821" // -212121221
  c = "99999999999999999999999999999999999999912121212" // "18121882"
  d = initBigInt(99999999) // "3"
  
echo a * b # 1432840655165633829880114/471545474283
echo b - c # -10606061049999999999999999999999999999990679414985336365/1922017868328961
echo c / d # 16666666666666666666666666666666666666652020202/100677121215451
echo d + a # 121211458932541233493/2223
```

**Boolean Operators**

```nim
var
  a = initBigRational("121211458858441234234", 2223)
  b = "-11821" // -212121221
  c = "99999999999999999999999999999999999999912121212" // "18121882"
  d = initBigInt(99999999) // "3"
  
echo a < b # false
echo b < c # true
echo c >= d # true
echo d <= a # true
echo b == d # false
echo c != d # true
```
