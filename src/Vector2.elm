module Vector2 exposing (Vec2, add, setX, setY, asXIn, asYIn)

type alias Vec2 =
    { x : Float
    , y : Float
    }

add : Vec2 -> Vec2 -> Vec2
add a b =
    { x = a.x + b.x, y = a.y + b.y }

setX : Float -> Vec2 -> Vec2
setX x v =
    { v | x = x }

setY : Float -> Vec2 -> Vec2
setY y v =
    { v | y = y }

asXIn : Vec2 -> Float -> Vec2
asXIn v x =
    { v | x = x }

asYIn : Vec2 -> Float -> Vec2
asYIn v y =
    { v | y = y }
