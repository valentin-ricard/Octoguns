use array::ArrayTrait;
use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
struct Vector2 {
    x: i16,
    y: i16,
}

#[derive(Copy, Drop, Serde)]
struct Action {
    action_type: u8,
    step: u8,
}

#[derive(Drop, Serde)]
struct CharacterMove {
    character_ids: Array<u32>,
    movement: Array<Vector2>,
    actions: Array<Action>,
}

#[dojo::interface]
trait IMove {
    fn move(ref world: IWorldDispatcher, moves: Array<CharacterMove>);
}

#[dojo::contract]
mod actions {
    use super::IMove;
    use super::{Vector2, Action, CharacterMove};
    use octoguns::models::sessions::{Session};
    use octoguns::models::character::{Character, Position};
    use starknet::{ContractAddress, get_caller_address};
    use array::ArrayTrait;

    // Define a struct to hold character ID and position
    #[derive(Drop, Copy)]
    struct CharacterPosition {
        id: u32,
        x: u16,
        y: u16,
    }

    #[abi(embed_v0)]
    impl MoveImpl of IMove<ContractState> {
        fn move(ref world: IWorldDispatcher, moves: Array<CharacterMove>) {
            assert(moves.len() <= 3, 'Invalid number of moves');

            let caller = get_caller_address();

            // Create an array to store initial positions
            let mut initial_positions: Array<CharacterPosition> = ArrayTrait::new();

            // Collect all unique character IDs from all moves
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

            // Get initial positions for all characters
            let mut char_index = 0;
            loop {
                if char_index >= all_character_ids.len() {
                    break;
                }
                let character_id = *all_character_ids.at(char_index);
                
                // Retrieve the Character and Position structs from the world
                let character = get!(world, character_id, (Character));
                let position = get!(world, character_id, (Position));

                // Validate that the caller owns this character
                assert(character.player_id == caller, 'Not character owner');

                // Store the initial position in our array
                initial_positions.append(CharacterPosition { id: character_id, x: position.x, y: position.y });

                char_index += 1;
            };
        }
    }
}