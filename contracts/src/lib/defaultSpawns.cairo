use array::ArrayTrait;
use core::debug::PrintTrait;
use octoguns::types::{Vec2, CharacterPosition};

fn generate_character_positions(player_id: u8) -> Array<Vec2> {
    assert(player_id == 1 || player_id == 2, 'Invalid player ID');

    let mut positions = ArrayTrait::new();
    let is_player_one = player_id == 1;

    // Define the x-coordinate for each player
    let x = if is_player_one {
        200_u32 // Player one spawns near the left edge
    } else {
        1000_u32 // Player two spawns near the right edge
    };

    let num_characters = 8;
    let mut count = 0;
    while count < num_characters {
        // Calculate y position, distributing characters across the full height
        // Start at 1% and end at 99% of height to avoid placing characters exactly on the edges
        let y = 200_u32 + (count * 9900_u32 / (num_characters - 1));
        
        positions.append(Vec2 { x, y });
        count += 1;
    };

    positions
}