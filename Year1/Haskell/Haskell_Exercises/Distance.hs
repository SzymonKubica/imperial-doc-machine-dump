type Vertex = (Float, Float)
--Returns the distance between two vertices
distance :: Vertex -> Vertex -> Float
distance (a, b) (c, d)
 = sqrt((a - c) ^ 2 + (b - d) ^ 2)
--Returns the area of a triangle defined by three vertices
triangleArea :: Vertex -> Vertex -> Vertex -> Float
triangleArea (a, b) (c, d) (e, f)
 = sqrt(s * (s - x) * (s - y) * (s - z))
   where
    x = distance (a, b) (c, d)
    y = distance (c, d) (e, f)
    z = distance (a, b) (e, f)
    s = (x + y + z)/2
