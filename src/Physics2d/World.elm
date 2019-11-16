module Physics2d.World exposing (Particle, World, empty,
                                 addParticle, getParticles,
                                 asPositionIn, asVelocityIn, explicitEuler)

import Physics2d.Vector2 as Vector2 exposing (Vec2)

import Array exposing (Array)

type alias Particle =
    { position: Vec2
    , velocity: Vec2
    }

addParticle : Particle -> World -> World
addParticle particle world
    = { world | particles = Array.push particle world.particles }

asPositionIn : Particle -> Vec2 -> Particle
asPositionIn particle pos =
    { particle | position = pos }

asVelocityIn : Particle -> Vec2 -> Particle
asVelocityIn particle vel =
    { particle | velocity = vel }

type alias World =
    { particles: Array Particle }

{-
 An empty new world.
-}
empty : World
empty = { particles = Array.empty }

{-
 Get all particles from the world.
-}
getParticles : World -> List Particle
getParticles  world
    = Array.toList world.particles

updateParticle : Particle -> Particle
updateParticle particle =
    { position = Vector2.add particle.position particle.velocity
    , velocity = particle.velocity }

explicitEuler: World -> World
explicitEuler world =
    let particles = Array.map (\{position, velocity} ->
                                   { position = Vector2.add position velocity
                                   , velocity = velocity }
                              ) world.particles in
    { particles = particles }
