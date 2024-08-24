use octoguns::models::map::{Bullet};
use octoguns::lib::moveChecks::{CharacterPosition};

use alexandria_math::trigonometry::fast_cos;
use alexandria_math::trigonometry::fast_sin;
use alexandria_math::trigonometry::fast_tan;

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
pub fn simulate_bullets(mut bullets: Array<Bullet>) -> Array<Bullet> {
    let mut bullet_counter = 0;
    loop {
        if bullet_counter >= bullets.len() {
            break;
        }
        let new_bullet_position = simulate_bullet(bullets.pop_front().unwrap());

    };
    bullets
}

pub fn simulate_bullet(bullet: Bullet) -> Bullet {

    let position = bullet.coords;
    let position_x = position.x; // i16
    let position_y = position.y; // i16
    let speed = bullet.speed;
    let direction = bullet.direction; // in degrees from 0 to 259

    let x_shift = fast_sin(direction) * speed / 100_000_000;
    let y_shift = fast_cos(direction) * speed / 100_000_000;

    bullet
}

pub fn compute_bullet_hits(ref bullets: Array<Bullet>, character: CharacterPosition) -> bool {
    return false;
}