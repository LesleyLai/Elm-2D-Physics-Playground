module Model exposing (Model, Particle
                      , initModel, asPositionIn, asVelocityIn)

import Vector2 exposing (Vec2)

import Array exposing (Array)

type alias Particle =
    { position: Vec2
    , velocity: Vec2
    }

asPositionIn : Particle -> Vec2 -> Particle
asPositionIn particle pos =
    { particle | position = pos }

asVelocityIn : Particle -> Vec2 -> Particle
asVelocityIn particle vel =
    { particle | velocity = vel }

type alias Model =
    { particles : Array Particle,
      particleToAdd : Particle }


idleParticle : Particle
idleParticle =  { position = { x = 0, y = 0 }
                , velocity = { x = 0, y = 0 }
                }

initParticles : Array Particle
initParticles = Array.empty

initModel : Model
initModel = { particles = initParticles
            , particleToAdd = idleParticle
            }
