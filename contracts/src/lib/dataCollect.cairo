use octoguns::systems::move::{CharacterMove};

fn get_character_ids(moves: Array<CharacterMove>) -> Array<u32> {
    let mut all_character_ids: Array<u32> = ArrayTrait::new();
    let mut move_index = 0;
    loop {
        if move_index >= moves.len() {
            break;
        }
        let character_move = moves.at(move_index);
        let mut char_index = 0;
        loop {
            if char_index >= character_move.character_ids.len() {
                break;
            }
            let character_id = *character_move.character_ids.at(char_index);
            all_character_ids.append(character_id);
            char_index += 1;
        };
        move_index += 1;
    };
    return all_character_ids;
}