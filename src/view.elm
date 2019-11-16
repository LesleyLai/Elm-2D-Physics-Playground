module View exposing (view, Msg(..))

import Array exposing (Array)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region

import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (..)

import Color

import Vector2

import Html exposing (Html)
import Html.Attributes

import Model exposing (Model, Particle)

type Msg
    = Frame Float
    | ChangeParticleToAddPosX String
    | ChangeParticleToAddPosY String
    | ChangeParticleToAddVelX String
    | ChangeParticleToAddVelY String
    | AddParticle

view : Model -> Html Msg
view model =
    Element.layout [ Font.size 14 ]
        (mainRow model)

mainRow : Model -> Element Msg
mainRow { particles } =
    Element.row
        [ Element.width Element.fill
        , Element.centerY
        , Element.spacing 30
        ]
        [ toolsBar
        , (canvas 1024 800 particles)
        , panels
        ]

{- Toolsbar -}
toolsBar: Element Msg
toolsBar =
    Element.column
        [ Element.width (Element.px 80)
        , Element.alignTop
        ]
        [ Input.button [
               Element.centerX
              , Element.centerY
              , Element.height (Element.px 60)
              , Background.color (Element.rgb255 200 200 200)
              ]
              { label = Element.text "Select"
              , onPress = Nothing
              }
        ]

{- Side panels -}
panels: Element Msg
panels =
    Element.column
        [ Element.width Element.fill
        , Element.alignTop]
        [ objectPropertiesView
        ]

-- numberInput : String -> String -> (String -> Msg) -> Html Msg     --
-- numberInput name placeholder onInputMsg                           --
--     = input [ Html.Attributes.type_ "number"                      --
--             , Html.Attributes.name name                           --
--             , Html.Attributes.value "0"                           --
--             , Html.Attributes.placeholder placeholder             --
--             , Html.Attributes.required True                       --
--             , Html.Attributes.step "0.01"                         --
--             , onInput onInputMsg ] []                             --

numberInput : String -> String -> (String -> Msg) -> Element Msg
numberInput text labelText onChange =
    Input.text []
        { onChange = onChange
        , text = text
        , placeholder = Nothing
        , label = Input.labelLeft [
                   Element.centerY
                  ] (Element.text labelText)
        }

vec2Input : String -> (String -> Msg) -> (String -> Msg) -> Element Msg
vec2Input title onChangeX onChangeY =
    Element.row [ Element.spacing 7, Font.size 14 ]
        [ Element.el [ Element.width (Element.px 70) ] (Element.text title)
        , numberInput "0" "x" onChangeX
        , numberInput "0" "y" onChangeY]

objectPropertiesView : Element Msg
objectPropertiesView =
    Element.column
        [ Element.spacing 5 ]
        [
         Element.el [ Region.heading 3
                    , Font.size 18 ] (Element.text "New Particle")
         , vec2Input "Position" ChangeParticleToAddPosX ChangeParticleToAddPosY
         , vec2Input "Velocity" ChangeParticleToAddVelX ChangeParticleToAddVelY
         , Input.button
             [ Element.centerX
             , Element.centerY
             , Element.width (Element.px 60)
             , Element.height (Element.px 20)
             , Background.color (Element.rgb255 200 200 200)
             ]
             { label = Element.text "Add"
             , onPress = Just AddParticle
             }
        ]

canvas: Int -> Int -> Array Particle -> Element Msg
canvas width height particles =
    let widthF = toFloat width
        heightF = toFloat height
    in
    Canvas.toHtml
        ( width, height )
        [ ]
        [ clearScreen widthF heightF
        , render widthF heightF particles
        ]
    |> Element.html

clearScreen : Float -> Float -> Canvas.Renderable
clearScreen width height =
    shapes [ fill (Color.rgb 0.6 0.6 0.6) ] [ rect ( 0, 0 ) width height ]

render: Float -> Float -> Array Particle -> Canvas.Renderable
render width height particles =
    let
        size = width / 30
        centerX = width / 2
        centerY = height / 2
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
