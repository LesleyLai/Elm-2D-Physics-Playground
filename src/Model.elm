module Model exposing (Model, initModel)

import Physics2d.World exposing (Particle, World, empty)

type alias Model =
    { world : World,
      particleToAdd : Particle }


idleParticle : Particle
idleParticle =  { position = { x = 0, y = 0 }
                , velocity = { x = 0, y = 0 }
                }

initModel : Model
initModel = { world = empty
            , particleToAdd = idleParticle
            }
