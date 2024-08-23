use array::ArrayTrait;
use core::debug::PrintTrait;

#[derive(Copy, Drop, Serde)]
struct CharacterPosition {
    x: u8,
    y: u8,
}

fn generate_character_positions(player_id: u8) -> Array<CharacterPosition> {
    assert(player_id == 1 || player_id == 2, 'Invalid player ID');

    let mut positions = ArrayTrait::new();
    let is_player_one = player_id == 1;

    let (start_x, end_x) = if is_player_one {
        (0_u8, 19_u8) // Player one spawns on the left side
    } else {
        (80_u8, 99_u8) // Player two spawns on the right side
    };

    let mut count = 0;
    while count < 8 {
        let x = start_x + (end_x - start_x) * count / 7;
        let y = 20 + (count * 60 / 7); // Distribute across the height of the board
        positions.append(CharacterPosition { x, y });
        count += 1;
    };

    positions
}