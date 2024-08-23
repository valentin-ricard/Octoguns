#[dojo::contract]
mod data_mover {

    use octoguns::systems::move::{CharacterMove, CharacterPosition};
    use octoguns::models::character::{Position, Character};
    use octoguns::models::map::{Bullet};
    use octoguns::models::sessions::{SessionMeta};
    use starknet::{ContractAddress, get_caller_address};

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

    fn store_character_positions(world: IWorldDispatcher, all_character_ids: Array<u32>) -> Array<CharacterPosition> {
        let mut initial_positions: Array<CharacterPosition> = ArrayTrait::new();
        let caller = get_caller_address();

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
            initial_positions.append(CharacterPosition { id: character_id, x: position.x, y: position.y, max_steps: character.steps_amount, current_step: 0 });

            char_index += 1;
        };
        return initial_positions;
    }

    fn get_all_bullets(world: IWorldDispatcher, session_id: u32) -> Array<Bullet> {
        let mut all_live_bullets: Array<Bullet> = ArrayTrait::new();
        let session_meta = get!(world, session_id, (SessionMeta));
        let bullets = session_meta.bullets; //  type: array<u32>

        let mut i = 0;
        loop {
            if i >= bullets.len() {
                break;
            }
            let bullet_id = *bullets.at(i);
            let bullet = get!(world, bullet_id, (Bullet));

            all_live_bullets.append(Bullet {bullet_id: bullet_id, coords: bullet.coords, speed: bullet.speed});
        };

        return all_live_bullets;
    }
}