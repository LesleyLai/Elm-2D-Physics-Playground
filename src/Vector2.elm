module Vector2 exposing (Vec2, add)

type alias Vec2 =
    { x : Float
    , y : Float
    }

add : Vec2 -> Vec2 -> Vec2
add a b =
    { x = a.x + b.x, y = a.y + b.y }
