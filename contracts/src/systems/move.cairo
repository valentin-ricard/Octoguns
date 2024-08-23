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

    #[abi(embed_v0)]
    impl MoveImpl of IMove<ContractState> {
        fn move(ref world: IWorldDispatcher, moves: Array<CharacterMove>) {
            assert(moves.len() <= 3, 'Invalid number of moves');

            let caller = get_caller_address();

            let mut i = 0;
            loop {
                if i >= moves.len() {
                    break;
                }
                let character_move = moves.at(i);
                
                // Process each character in the CharacterMove
                let mut j = 0;
                loop {
                    if j >= character_move.character_ids.len() {
                        break;
                    }
                    let character_id = *character_move.character_ids.at(j);
                    
                    // Retrieve the Character struct from the world
                    let character = get!(world, character_id, (Character));

                    // TODO: Validate that the caller owns this character
                    // assert(character.player_id == caller, 'Not character owner');

                    // Process movement
                    let mut k = 0;
                    loop {
                        if k >= character_move.movement.len() {
                            break;
                        }
                        let movement = *character_move.movement.at(k);
                        
                        // TODO: Apply movement
                        // Example:
                        // let mut position = get!(world, character_id, (Position));
                        // position.x += movement.x;
                        // position.y += movement.y;
                        // set!(world, (position));

                        k += 1;
                    };

                    // Process actions
                    let mut l = 0;
                    loop {
                        if l >= character_move.actions.len() {
                            break;
                        }
                        let action = *character_move.actions.at(l);
                        
                        // TODO: Apply action
                        // Example:
                        // apply_action(world, character_id, action.action_type, action.step);

                        l += 1;
                    };

                    j += 1;
                };

                i += 1;
            };
        }
    }
}