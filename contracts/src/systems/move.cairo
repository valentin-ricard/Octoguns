use array::ArrayTrait;
use starknet::ContractAddress;
use octoguns::lib::moveChecks::{CharacterPosition, does_collide};
use octoguns::models::map::{Bullet};

#[derive(Copy, Drop, Serde)]
struct Vector2 {
    x: i64,
    y: i64,
}

#[derive(Copy, Drop, Serde)]
struct Action {
    action_type: u8,
    step: u8,
}

#[derive(Clone, Drop, Serde)]
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
    use octoguns::lib::moveChecks::{CharacterPosition, does_collide, check_valid_movement};
    use octoguns::lib::data_mover::data_mover::{get_character_ids, store_character_positions, get_all_bullets};
    use octoguns::lib::simulate::{simulate_bullets, compute_bullet_hits};
    use starknet::{ContractAddress, get_caller_address};
    use array::ArrayTrait;

    #[abi(embed_v0)]
    impl MoveImpl of IMove<ContractState> {
        fn move(ref world: IWorldDispatcher, session_id: u32, mut moves: Array<CharacterMove>) {
            assert(moves.len() <= 3, 'Invalid number of moves');
            let player = get_caller_address();
            let session = get!(world, session_id, (Session));
            match session.state {
                0 => {
                    assert!(player == session.player1, "not turn player");
                },
                1 => {
                    assert!(player == session.player2, "not turn player");
                },
                _ => {

                }
            }

            // Collect all unique character IDs from all moves
            let mut moves_clone = moves.clone();
            let all_character_ids = get_character_ids(@moves);

            // Create an array to store initial positions
            // @Note initial_position struct: Array<CharacterPosition>
            // pub struct CharacterPosition {
            //     pub id: u32,
            //     pub x: u16,
            //     pub y: u16,
            //     pub max_steps: u32,
            //     pub current_step: u32,
            // }
            let mut initial_positions = store_character_positions(world, all_character_ids);

            let mut bullets = get_all_bullets(world, session_id);

            let mut step_count = 0;
            loop {
                if step_count >= 100_u32 {
                    break;
                }
                let mut user_count = 0;
                moves = moves_clone.clone();
                let mut updated_positions = ArrayTrait::new();
                loop {

                    if user_count == initial_positions.len() {
                        break;
                    }
                    let character_move = moves.pop_front().unwrap(); 

                    let mut character = *initial_positions.at(user_count);

                    // check character is out of moves
                    if character.current_step >= character.max_steps {
                        updated_positions.append(character);
                        user_count += 1;    
                        break;
                    }

                    // TODO Check if move is valid
                    //Get movement vector
                    let movement = *character_move.movement.at(user_count); 
                    let movement_x = movement.x;
                    let movement_y = movement.y;

                    //Checks if the move is not to big
                    let is_vaild = check_valid_movement(movement_x, movement_y);
                    if !is_vaild {
                        updated_positions.append(character);
                        user_count += 1;
                        break;
                    }

                    // TODO Check if the move collides
                    let is_collision = does_collide(character);
                    if !is_collision {
                        //Move character
                        character.x = (character.x + movement_x);
                        character.y = (character.y + movement_y);
                        character.current_step += 1;
                    }
                    updated_positions.append(character);
                    user_count += 1;
                };
                // Replace initial_positions with updated_positions
                initial_positions = updated_positions;

                // TODO test imulete Bullets
                let ( new_bullets, dead_characters ) = simulate_bullets(ref bullets, ref initial_positions);
                // Update modesl in the world
                step_count += 1;
            }
        }
    }
}

