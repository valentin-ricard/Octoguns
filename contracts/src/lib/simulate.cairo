use octoguns::models::map::{Bullet};
use octoguns::lib::moveChecks::{CharacterPosition};


// #[derive(Copy, Drop, Serde)]
// #[dojo::model]
// pub struct Bullet {
//     #[key]
//     pub bullet_id: u32,
//     pub coords: Vec2,
//     pub speed: u32, // pixels per step
//     pub direction: u32, // in degrees
// }


// TO DO The bullet simpulation
pub fn simulate_bullets(bullets: Array<Bullet>) -> Array<Bullet> {
    bullets
}

pub fn compute_bullet_hits(ref bullets: Array<Bullet>, character: CharacterPosition) -> bool {
    return false;
}