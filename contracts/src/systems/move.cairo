use array::ArrayTrait;
use starknet::ContractAddress;
use octoguns::lib::moveChecks::{CharacterPosition, does_collide};
use octoguns::models::map::{Bullet};

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
    fn move(ref world: IWorldDispatcher, session_id: u32, moves: Array<CharacterMove>);
}

#[dojo::contract]
mod actions {
    use super::IMove;
    use super::{Vector2, Action, CharacterMove};
    use octoguns::models::sessions::{Session};
    use octoguns::models::character::{Character, Position};
    use octoguns::models::map::{Bullet};
    use octoguns::lib::moveChecks::{CharacterPosition, does_collide};
    use octoguns::lib::data_mover::data_mover::{get_character_ids, store_character_positions, get_all_bullets};
    use starknet::{ContractAddress, get_caller_address};
    use array::ArrayTrait;

    #[abi(embed_v0)]
    impl MoveImpl of IMove<ContractState> {
        fn move(ref world: IWorldDispatcher, session_id: u32, moves: Array<CharacterMove>) {
            assert(moves.len() <= 3, 'Invalid number of moves');

            // Collect all unique character IDs from all moves
            let all_character_ids = get_character_ids(moves);

            // Create an array to store initial positions
            // @Note initial_position struct: Array<CharacterPosition>
            // pub struct CharacterPosition {
            //     pub id: u32,
            //     pub x: u16,
            //     pub y: u16,
            //     pub max_steps: u32,
            //     pub current_step: u32,
            // }
            let initial_positions = store_character_positions(world, all_character_ids);

            let bullets = get_all_bullets(world, session_id);

            let mut step_count = 0;
            loop {
                if step_count >= 100_u32 {
                    break;
                }

                let mut user_count = 0;
                loop {
                    if user_count == initial_positions.len() {
                        break;
                    }
                    let character = *initial_positions.at(user_count);

                    // TODO check character is out of moves
                    if character.current_step >= character.max_steps {
                        break;
                    }

                    // Check if the move collides
                    let is_collision = does_collide(character);
                    if !is_collision {
                        //Move character
                    }

                    // Check if shot
                };

                // Simulete Bullets

                step_count += 1;
            }
        }
    }
}

