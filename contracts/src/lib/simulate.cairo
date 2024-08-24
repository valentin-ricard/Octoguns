use octoguns::models::map::{Bullet, Vec2};
use octoguns::lib::moveChecks::{CharacterPosition};

use alexandria_math::trigonometry::{fast_cos, fast_sin};

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
pub fn simulate_bullets(mut bullets: Array<Bullet>, ref character_positions: Array<CharacterPosition>) -> Array<Bullet> {
    let mut updated_bullets = ArrayTrait::new();
    loop {
        match bullets.pop_front() {
            Option::Some(bullet) => {
                match simulate_bullet(bullet, @character_positions) {
                    Option::Some(updated_bullet) => updated_bullets.append(updated_bullet),
                    Option::None => {},
                }
            },
            Option::None => {
                break;
            },
        }
    };
    updated_bullets
}

pub fn simulate_bullet(mut bullet: Bullet, character_positions: @Array<CharacterPosition>) -> Option<Bullet> {

    let position = bullet.coords;
    let position_x = position.x; // i64
    let position_y = position.y; // i64
    let speed = bullet.speed; // in pixels per step
    let direction = bullet.direction; // in degrees from 0 to 259

    let is_charater_hit = compute_bullet_hits(position_x, position_y, character_positions);

    let x_shift = fast_sin(direction) * speed / 100_000_000;
    let y_shift = fast_cos(direction) * speed / 100_000_000;

    let new_position_x = position_x + x_shift;
    let new_position_y = position_y + y_shift;

    if new_position_x < 0 || new_position_x > 10_000 || new_position_y < 0 || new_position_y > 10_000 {
        return Option::None(());
    }

    bullet.coords = Vec2 { x: new_position_x, y: new_position_y };

    return Option::Some(bullet);
}

pub fn compute_bullet_hits(bullet_position_x: i64, bullet_position_y: i64, characters: @Array<CharacterPosition>) -> bool {
    let mut character_index = 0;
    let mut hit_detected = false;

    loop {
        if character_index >= characters.len() {
            break;
        }

        let character = characters.at(character_index);
        let character_position_x = *character.x;
        let character_position_y = *character.y;

        let lower_bound_x = character_position_x - 5;
        let upper_bound_x = character_position_x + 5;
        let lower_bound_y = character_position_y - 5;
        let upper_bound_y = character_position_y + 5;

        if bullet_position_x >= lower_bound_x && bullet_position_x <= upper_bound_x &&
           bullet_position_y >= lower_bound_y && bullet_position_y <= upper_bound_y {
            hit_detected = true;
            break; // Exit the loop if a hit is detected
        }

        character_index += 1;
    };

    hit_detected // Return the result
}