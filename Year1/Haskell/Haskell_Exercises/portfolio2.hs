
alpha :: Double -> Double
alpha x = x * x

alpha' :: Double -> Double
alpha' x = 2 * x

alpha'' :: Double -> Double
alpha'' x = 2

beta :: Double -> Double
beta x = x * x * x

beta' :: Double -> Double
beta' x = 3 * x * x

beta'' :: Double -> Double
beta'' x = 6 * x

gamma :: Double -> Double
gamma x = x * x * x * x

gamma' :: Double -> Double
gamma' x = 4 * x * x * x

gamma'' :: Double -> Double
gamma'' x = 12 * x * x

df :: (Double -> Double) -> Double -> Double -> Double
df f x h
  = (f (x + h) - f (x - h))/(2 * h)

d2f :: (Double -> Double) -> Double -> Double -> Double
d2f f x h
  = (f (x + h) - 2 * f x + f (x - h))/(h * h)

ns :: [Int]
ns = [2, 2*2, 2*2*2, 2*2*2*2]

hs :: [Double]
hs = map (\ x -> 1/x) (map fromIntegral ns)

efn :: (Double -> Double) -> (Double -> Double) -> Double -> Double
efn f1 f2 x
  = abs(f1 x - f2 x)

dfs :: (Double -> Double) -> Double -> [Double] -> [Double]
dfs f x 
  = map (df f x) 

d2fs :: (Double -> Double) -> Double -> [Double] -> [Double]
d2fs f x 
  = map (d2f f x) 

