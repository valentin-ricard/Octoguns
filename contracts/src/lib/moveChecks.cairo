// In src/lib/moveChecks.cairo

use array::ArrayTrait;

#[derive(Drop, Copy)]
pub struct CharacterPosition {
    pub id: u32,
    pub x: i64,
    pub y: i64,
    pub max_steps: u32,
    pub current_step: u32,
}

pub fn does_collide(character: CharacterPosition) -> bool {
    // Implement your collision logic here
    false
}

pub fn check_valid_movement(movement_x: i64, movement_y: i64) -> bool {
    return true;
}