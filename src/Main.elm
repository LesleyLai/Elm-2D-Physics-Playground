module Main exposing (main)

import Array

import Browser
import Browser.Events exposing (onAnimationFrameDelta)


import Model exposing (Model, initModel)
import View exposing (view, Msg(..))

import Physics2d.Vector2 as Vector2 exposing (Vec2, setX, setY, asXIn, asYIn)
import Physics2d.World as World
    exposing (Particle, asPositionIn, asVelocityIn, explicitEuler)

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> (initModel, Cmd.none)
        , view = view
        , update = update
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let { world, particleToAdd } = model in
    case msg of
        Frame _ ->
            ( { model | world = explicitEuler world }, Cmd.none )
        ChangeParticleToAddPosX x ->
            let newParticleToAdd =
                    (Maybe.withDefault 0.0 (String.toFloat x))
                         |> asXIn model.particleToAdd.position
                         |> asPositionIn model.particleToAdd in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddPosY y ->
            let newParticleToAdd =
                    (Maybe.withDefault 0.0 (String.toFloat y))
                         |> asYIn model.particleToAdd.position
                         |> asPositionIn model.particleToAdd in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddVelX x ->
            let newParticleToAdd =
                    (Maybe.withDefault 0.0 (String.toFloat x))
                         |> asXIn model.particleToAdd.velocity
                         |> asVelocityIn model.particleToAdd in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        ChangeParticleToAddVelY y ->
            let newParticleToAdd =
                    (Maybe.withDefault 0.0 (String.toFloat y))
                         |> asYIn model.particleToAdd.velocity
                         |> asVelocityIn model.particleToAdd in
            ( { model | particleToAdd = newParticleToAdd }, Cmd.none )
        AddParticle ->
            let newWorld =
                    World.addParticle particleToAdd world
            in
            ( { model | world = newWorld }, Cmd.none )
