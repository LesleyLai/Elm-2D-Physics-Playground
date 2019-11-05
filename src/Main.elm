module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (..)
import Color
import Html exposing (Html, div)
import Html.Attributes exposing (style)

import Array exposing (Array)

import Vector2 exposing (Vec2)


type alias Particle =
    { position: Vec2
    , velocity: Vec2
    }

type alias Model =
    { particles : Array Particle }


type Msg
    = Frame Float

initParticles : Array Particle
initParticles = Array.initialize 1 (\x -> { position = { x = 0, y = 0 }
                                          , velocity = { x = 0, y = 1 }
                                          })

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ({ particles = initParticles }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }

updateParticle : Particle -> Particle
updateParticle particle =
    { particle
        | position = Vector2.add particle.position particle.velocity }

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Frame _ ->
            let newParticles = Array.map updateParticle model.particles
            in
            ( { particles = newParticles }, Cmd.none )

width = 400
height = 400
centerX = width / 2
centerY = height / 2


view : Model -> Html Msg
view { particles } =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ Canvas.toHtml
            ( width, height )
            [ style "border" "10px solid rgba(0,0,0,0.1)" ]
            [ clearScreen
            , render particles
            ]
        ]


clearScreen =
    shapes [ fill Color.white ] [ rect ( 0, 0 ) width height ]

render: Array Particle -> Canvas.Renderable
render particles =
    let
        size =
            width / 30
    in
    shapes
        [ transform
            [ translate centerX centerY
            ]
        , fill (Color.hsl 0.3 0.3 0.7)
        ]
        (Array.toList (Array.map (\particle ->
                            circle ( particle.position.x, particle.position.y ) size
        ) particles))
