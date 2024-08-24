use array::ArrayTrait;
use core::debug::PrintTrait;

#[derive(Copy, Drop, Serde)]
struct CharacterPosition {
    x: i16,
    y: i16,
}

fn generate_character_positions(player_id: u8) -> Array<CharacterPosition> {
    assert(player_id == 1 || player_id == 2, 'Invalid player ID');

    let mut positions = ArrayTrait::new();
    let is_player_one = player_id == 1;

    // Define the x-coordinate for each player
    let x = if is_player_one {
        100_i16 // Player one spawns near the left edge
    } else {
        9900_i16 // Player two spawns near the right edge
    };

    let num_characters = 8;
    let mut count = 0;
    while count < num_characters {
        // Calculate y position, distributing characters across the full height
        // Start at 1% and end at 99% of height to avoid placing characters exactly on the edges
        let y = 100_i16 + (count * 9800_i16 / (num_characters - 1));
        
        positions.append(CharacterPosition { x, y });
        count += 1;
    };

    positions
}