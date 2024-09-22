-- Returns a temperature in Fahrenheit given temperature in Celcius
celciusToFahrenheit :: Double -> Double 
celciusToFahrenheit celcius 
 = celcius* 9 / 5 + 32

--Returns the binary representation of a given int.
binary :: Int -> Int
binary x
 | x < 2 = x
 | otherwise = remainder x 2 + 10 * binary (quotient x 2)
  where
   remainder :: Int -> Int -> Int
   remainder dividend divisor
    | dividend < divisor = dividend
    | otherwise          = remainder (dividend - divisor) divisor
   quotient dividend divisor
    | dividend < divisor = 0
    | otherwise          = 1 + quotient (dividend - divisor) divisor

