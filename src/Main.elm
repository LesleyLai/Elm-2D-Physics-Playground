module Main exposing (main)

import Array

import Browser
import Browser.Events exposing (onAnimationFrameDelta)

import Model exposing (Model, Particle
                      , initModel, asPositionIn, asVelocityIn)
import View exposing (view, Msg(..))

import Vector2 exposing (Vec2, setX, setY, asXIn, asYIn)

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> (initModel, Cmd.none)
        , view = view
        , update = update
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }

updateParticle : Particle -> Particle
updateParticle particle =
    { position = Vector2.add particle.position particle.velocity
    , velocity = particle.velocity }

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Frame _ ->
            let newParticles = Array.map updateParticle model.particles
            in
            ( { model | particles = newParticles }, Cmd.none )
        ChangeParticleToAddPosX x ->
            let newParticleToAdd =
                    (Maybe.withDefault 0.0 (String.toFloat x))
                         |> Vector2.asXIn model.particleToAdd.position
                         |> asPositionIn model.particleToAdd in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddPosY y ->
            let newParticleToAdd =
                    (Maybe.withDefault 0.0 (String.toFloat y))
                         |> Vector2.asYIn model.particleToAdd.position
                         |> asPositionIn model.particleToAdd in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddVelX x ->
            let newParticleToAdd =
                    (Maybe.withDefault 0.0 (String.toFloat x))
                         |> Vector2.asXIn model.particleToAdd.velocity
                         |> asVelocityIn model.particleToAdd in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddVelY y ->
            let newParticleToAdd =
                    (Maybe.withDefault 0.0 (String.toFloat y))
                         |> Vector2.asYIn model.particleToAdd.velocity
                         |> asVelocityIn model.particleToAdd in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        AddParticle ->
            ( { model | particles = (Array.push model.particleToAdd model.particles) }, Cmd.none )
