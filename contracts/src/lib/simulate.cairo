use octoguns::models::map::{Bullet, Vec2};
use octoguns::lib::moveChecks::{CharacterPosition};
use alexandria_math::trigonometry::{fast_cos, fast_sin};

// Tuple to hold both bullets and character positions
pub type SimulationResult = (Array<Bullet>, Array<u32>);

pub fn simulate_bullets(ref bullets: Array<Bullet>, ref character_positions: Array<CharacterPosition>) -> SimulationResult {
    let mut updated_bullets = ArrayTrait::new();
    let mut dead_characters_ids = ArrayTrait::new();
    let mut character_index: u32 = 0;

    loop {
        if character_index >= bullets.len() {
            break;
        }
        let bullet = *bullets.at(character_index);
        let (updated_bullet, character_id) = simulate_bullet(bullet, @character_positions);
        match updated_bullet {
            Option::Some(bullet) => updated_bullets.append(bullet),
            Option::None => {},
        }
        if character_id != 0 {
            // Only append character if not hit
                dead_characters_ids.append(character_id);
        }
        character_index += 1;
    };

    (updated_bullets, dead_characters_ids)
}

pub fn simulate_bullet(mut bullet: Bullet, character_positions: @Array<CharacterPosition>) -> (Option<Bullet>, u32) {
    let position = bullet.coords;
    let position_x = position.x;
    let position_y = position.y;
    let speed = bullet.speed;
    let direction = bullet.direction;

    let character_id = compute_bullet_hits(position_x, position_y, character_positions);

    if character_id != 0 {
        return (Option::None(()), character_id);
    }

    let x_shift = fast_sin(direction) * speed / 100_000_000;
    let y_shift = fast_cos(direction) * speed / 100_000_000;

    let new_position_x = position_x + x_shift;
    let new_position_y = position_y + y_shift;

    if new_position_x < 0 || new_position_x > 10_000 || new_position_y < 0 || new_position_y > 10_000 {
        return (Option::None(()), character_id);
    }

    bullet.coords = Vec2 { x: new_position_x, y: new_position_y };

    (Option::Some(bullet), character_id)
}

pub fn compute_bullet_hits(bullet_position_x: i64, bullet_position_y: i64, characters: @Array<CharacterPosition>) -> u32 {
    let mut character_index: u32 = 0;
    let mut character_id = 0;

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
            character_id = *character.id;
            break;        
        }

        character_index += 1;
    };

    character_id
}