module Tests where
import IC.TestSuite
import Practice


isPrefixTestCases
   = [
       ("has","haskell") ==> True
     , ("","haskell") ==> True
     , ("ask","haskell") ==> False
     ]

removePrefixTestCases
   = [
       ("ja","java") ==> "va"
     , ("","java") ==> "java"
     ]

suffixesTestCases
  = [
      ("perl") ==> ["perl","erl","rl","l"]
    ]

isSubstringTestCases
   = [
       ("ytho","python") ==> True
     , ("ythough","python") ==> False
     ]

findSubstringsTestCases
   = [
       ("an","banana") ==> [1,3]
     , ("s","mississippi") ==> [2,3,5,6]
     , ("hello","goodbye") ==> []
     ]

-- You can add your own test cases above

allTestCases
  = [
      TestCase "isPrefix" (uncurry isPrefix)
               isPrefixTestCases
    , TestCase "removePrefix" (uncurry removePrefix)
               removePrefixTestCases
    , TestCase "suffixes" (suffixes)
               suffixesTestCases
    , TestCase "isSubstring" (uncurry isSubstring)
               isSubstringTestCases
    , TestCase "findSubstrings" (uncurry findSubstrings)
               findSubstringsTestCases
    ]


runTests = mapM_ goTest allTestCases

main = runTests
