module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (..)
import Color
import Html exposing (Html, button, h3, div, input, span)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick, onInput)

import Array exposing (Array)

import Vector2 exposing (Vec2)

type alias Particle =
    { position: Vec2
    , velocity: Vec2
    }

type alias Model =
    { particles : Array Particle,
      particleToAdd : Particle }

type Msg
    = Frame Float
    | ChangeParticleToAddPosX String
    | ChangeParticleToAddPosY String
    | ChangeParticleToAddVelX String
    | ChangeParticleToAddVelY String
    | AddParticle

idleParticle : Particle
idleParticle =  { position = { x = 0, y = 0 }
                , velocity = { x = 0, y = 0 }
                }

initParticles : Array Particle
initParticles = Array.empty

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ({ particles = initParticles, particleToAdd = idleParticle }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }

updateParticle : Particle -> Particle
updateParticle particle =
    let newVel = Vector2.add particle.velocity (Vec2 0 0.98) in
    { position = Vector2.add particle.position particle.velocity, velocity = newVel }

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Frame _ ->
            let newParticles = Array.map updateParticle model.particles
            in
            ( { model | particles = newParticles }, Cmd.none )
        ChangeParticleToAddPosX x ->
            let oldParticleToAdd = model.particleToAdd in
            let oldPos = oldParticleToAdd.position in
            let newPos = { oldPos | x = Maybe.withDefault 0.0 (String.toFloat x) } in
            let newParticleToAdd = { oldParticleToAdd | position = newPos } in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddPosY y ->
            let oldParticleToAdd = model.particleToAdd in
            let oldPos = oldParticleToAdd.position in
            let newPos = { oldPos | y = Maybe.withDefault 0.0 (String.toFloat y) } in
            let newParticleToAdd = { oldParticleToAdd | position = newPos } in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddVelX x ->
            let oldParticleToAdd = model.particleToAdd in
            let oldVel = oldParticleToAdd.velocity in
            let newVel = { oldVel | x = Maybe.withDefault 0.0 (String.toFloat x) } in
            let newParticleToAdd = { oldParticleToAdd | velocity = newVel } in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddVelY y ->
            let oldParticleToAdd = model.particleToAdd in
            let oldVel = oldParticleToAdd.velocity in
            let newVel = { oldVel | y = Maybe.withDefault 0.0 (String.toFloat y) } in
            let newParticleToAdd = { oldParticleToAdd | velocity = newVel } in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        AddParticle ->
            ( { model | particles = (Array.push model.particleToAdd model.particles) }, Cmd.none )

width = 400
height = 400
centerX = width / 2
centerY = height / 2


numberInput : String -> String -> (String -> Msg) -> Html Msg
numberInput name placeholder onInputMsg
    = input [ Html.Attributes.type_ "number"
            , Html.Attributes.name name
            , Html.Attributes.value "0"
            , Html.Attributes.placeholder placeholder
            , Html.Attributes.required True
            , Html.Attributes.step "0.01"
            , onInput onInputMsg ] []

inputsView : Html Msg
inputsView =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        ]
        [ h3 [] [ Html.text "Add New Particle" ]
        , div []
            [ span [][Html.text "position" ]
            , numberInput "positionX" "x" ChangeParticleToAddPosX
            , numberInput "positionY" "y" ChangeParticleToAddPosY
            ]
        , div []
            [ span [][ Html.text "velocity" ]
            , numberInput "velocityX" "x" ChangeParticleToAddVelX
            , numberInput "velocityY" "y" ChangeParticleToAddVelY
            ]
        , button [ onClick AddParticle ] [ Html.text "Add" ]
        ]

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
        , inputsView
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
