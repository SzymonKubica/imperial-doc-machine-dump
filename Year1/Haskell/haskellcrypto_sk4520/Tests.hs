module Tests where

import IC.TestSuite

import Crypto

-------------------------------------------------------------------------------
-- PART 1 : asymmetric encryption

gcdTestCases
  = [ (0, 0) ==> 0
    , (0, 8) ==> 8
    , (8, 0) ==> 8
    , (3, 3) ==> 3
    , (3, 12) ==> 3
    , (12, 16) ==> 4
    , (16, 12) ==> 4
    , (18, 12) ==> 6
    , (23, 12) ==> 1
    , (65, 40) ==> 5
    , (23, 39) ==> 1
    , (18, 81) ==> 9
    , (80, 40) ==> 40
    , (11, 121) ==> 11
    , (735, 1239) ==> 21
    , (1024, 512) ==> 512
    ]

phiTestCases
  = [ 0 ==> 0
    , 1 ==> 1
    , 2 ==> 1
    , 3 ==> 2
    , 4 ==> 2
    , 5 ==> 4
    , 6 ==> 2
    , 18 ==> 6
    , 35 ==> 24
    , 77 ==> 60
-- The following test cases verify the property phi(p) = p - 1 for prime p.
    , 17 ==> 16
    , 19 ==> 18
    , 23 ==> 22
    , 29 ==> 28
    , 31 ==> 30
    , 37 ==> 36
    , 41 ==> 40
    ]

modPowTestCases
  = [ (0, 0, 1) ==> 0
    , (1, 1, 1) ==> 0
    , (1, 1, 2) ==> 1
    , (13481, 11237, 6) ==> 5
    , (8, 0, 1) ==> 0
    , (8, 0, 5) ==> 1
    , (237, 1, 1000) ==> 237
    , (859237, 1, 1000) ==> 237
    , (33893, 2, 10000) ==> 5449
    , (7433893, 2, 10000) ==> 5449
    , (13481503, 11237126, 46340) ==> 6629
    ]

computeCoeffsTestCases
  = [ (0, 0) ==> (1, 0)
    , (0, 8) ==> (0, 1)
    , (12, 16) ==> (-1, 1)
    , (16, 12) ==> (1, -1)
    , (65, 40) ==> (-3, 5)
    , (735, 1239) ==> (27, -16)
    ]

inverseTestCases
  = [ (11, 16) ==> 3
    , (4, 15) ==> 4
    , (18, 35) ==> 2
    , (35, 18) ==> 17
    , (12, 91) ==> 38
    , (34, 91) ==> 83
    , (64, 91) ==> 64
    ]

smallestCoPrimeOfTestCases
  = [ 1 ==> 2
    , 2 ==> 3
    , 3 ==> 2
    , 12 ==> 5
    , 13 ==> 2
    , 14 ==> 3
    , 15 ==> 2
    , 16 ==> 3
    , 30 ==> 7
    , 210 ==> 11
    , 2310 ==> 13
    ]

genKeysTestCases
  = [ (2, 3) ==> ((3,6),(1,6))
    , (17, 23) ==> ((3,391),(235,391))
    , (101, 83) ==> ((3,8383),(5467,8383))
    , (401, 937) ==> ((7,375737),(213943,375737))
    , (613, 997) ==> ((5,611161),(243821,611161))
    , (26641, 26437) ==> ((7,704308117),(100607863,704308117))
    ]

rsaEncryptTestCases
  = [ (4321, (3,8383)) ==> 3694
    , (324561, (5, 611161)) ==> 133487
    , (1234, (5,611161)) ==> 320878
    , (704308111, (7, 704308117)) ==> 704028181
    ]

rsaDecryptTestCases
  = [ (3694, (5467,8383)) ==> 4321
    , (133487, (243821,611161)) ==> 324561
    , (320878, (243821,611161)) ==> 1234
    , (704028181, (100607863,704308117)) ==> 704308111
    ]

-------------------------------------------------------------------------------
-- PART 2 : symmetric encryption

toIntTestCases
  = [ 'a' ==> 0
    , 'b' ==> 1
    , 'c' ==> 2
    , 'd' ==> 3
    , 'e' ==> 4
    , 'f' ==> 5
    , 'g' ==> 6
    , 'h' ==> 7
    , 'i' ==> 8
    , 'j' ==> 9
    , 'k' ==> 10
    , 'l' ==> 11
    , 'm' ==> 12
    , 'n' ==> 13
    , 'o' ==> 14
    , 'p' ==> 15
    , 'q' ==> 16
    , 'r' ==> 17
    , 's' ==> 18
    , 't' ==> 19
    , 'u' ==> 20
    , 'v' ==> 21
    , 'w' ==> 22
    , 'x' ==> 23
    , 'y' ==> 24
    , 'z' ==> 25
    ]

toCharTestCases
  = [ 0 ==> 'a'
    , 1 ==> 'b'
    , 2 ==> 'c'
    , 3 ==> 'd'
    , 4 ==> 'e'
    , 5 ==> 'f'
    , 6 ==> 'g'
    , 7 ==> 'h'
    , 8 ==> 'i'
    , 9 ==> 'j'
    , 10 ==> 'k'
    , 11 ==> 'l'
    , 12 ==> 'm'
    , 13 ==> 'n'
    , 14 ==> 'o'
    , 15 ==> 'p'
    , 16 ==> 'q'
    , 17 ==> 'r'
    , 18 ==> 's'
    , 19 ==> 't'
    , 20 ==> 'u'
    , 21 ==> 'v'
    , 22 ==> 'w'
    , 23 ==> 'x'
    , 24 ==> 'y'
    , 25 ==> 'z'
    ]

--The first few cases verify that a `add` x = x
addTestCases
  = [ ('a', 'a') ==> 'a'
    , ('a', 'd') ==> 'd'
    , ('a', 'x') ==> 'x'
    , ('a', 'e') ==> 'e'
    , ('d', 't') ==> 'w'
    , ('w', 't') ==> 'p'
    , ('x', 't') ==> 'q'
    ]

--The first few cases verify that x `substract` a = x
substractTestCases
  = [ ('a', 'a') ==> 'a'
    , ('x', 'a') ==> 'x'
    , ('t', 'a') ==> 't'
    , ('d', 'a') ==> 'd'
    , ('g', 'a') ==> 'g'
    , ('h', 'a') ==> 'h'
    , ('v', 's') ==> 'd'
    , ('p', 'w') ==> 't'
    , ('h', 'c') ==> 'f'
    , ('b', 'e') ==> 'x'
    ]

ecbEncryptTestCases
  = [ ('w', "") ==> ""
    , ('d', "w") ==> "z"
    , ('x', "bonjour") ==> "ylkglro"
    , ('k', "hello") ==> "rovvy"
    ]

ecbDecryptTestCases
  = [ ('w', "") ==> ""
    , ('d', "z") ==> "w"
    , ('x', "ylkglro") ==> "bonjour"
    , ('k', "rovvy") ==> "hello"
    ]

cbcEncryptTestCases
  = [ ('w', 'i', "") ==> ""
    , ('d', 'i', "w") ==> "h"
    , ('x', 'w', "bonjour") ==> "ufpvgxl"
    , ('k', 'q', "hello") ==> "hvqlj"
    ]

cbcDecryptTestCases
  = [ ('w', 'i', "") ==> ""
    , ('d', 'i', "h") ==> "w"
    , ('x', 'w', "ufpvgxl") ==> "bonjour"
    , ('k', 'q', "hvqlj") ==> "hello"
    ]

-- You can add your own test cases above

allTestCases
  = [ TestCase "gcd" (uncurry Crypto.gcd)
                     gcdTestCases
    , TestCase "phi" phi
                     phiTestCases
    , TestCase "modPow" (uncurry3 modPow)
                        modPowTestCases
    , TestCase "computeCoeffs" (uncurry computeCoeffs)
                             computeCoeffsTestCases
    , TestCase "inverse" (uncurry inverse)
                         inverseTestCases
    , TestCase "smallestCoPrimeOf" (smallestCoPrimeOf)
                                   smallestCoPrimeOfTestCases
    , TestCase "genKeys" (uncurry genKeys)
                         genKeysTestCases
    , TestCase "rsaEncrypt" (uncurry rsaEncrypt)
                            rsaEncryptTestCases
    , TestCase "rsaDecrypt" (uncurry rsaDecrypt)
                            rsaDecryptTestCases
    , TestCase "toInt" (toInt)
                       toIntTestCases
    , TestCase "toChar" (toChar)
                       toCharTestCases
    , TestCase "add" (uncurry add)
                     addTestCases
    , TestCase "substract" (uncurry substract)
                           substractTestCases
    , TestCase "ecbEncrypt" (uncurry ecbEncrypt)
                            ecbEncryptTestCases
    , TestCase "ecbDecrypt" (uncurry ecbDecrypt)
                            ecbDecryptTestCases
    , TestCase "cbcEncrypt" (uncurry3 cbcEncrypt)
                            cbcEncryptTestCases
    , TestCase "cbcDecrypt" (uncurry3 cbcDecrypt)
                       cbcDecryptTestCases
    ]


runTests = mapM_ goTest allTestCases

main = runTests
