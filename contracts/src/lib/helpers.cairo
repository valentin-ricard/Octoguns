
use octoguns::types::{CharacterPosition, CharacterPositionTrait, CharacterMove};
use octoguns::models::character::{Position, Character};
use octoguns::models::bullet::{Bullet};
use octoguns::models::sessions::{SessionMeta};
use starknet::{ContractAddress, get_caller_address};
use dojo::world::IWorldDispatcher;

fn get_character_ids(moves: @Array<CharacterMove>) -> Array<u32> {
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

fn get_character_positions(world: IWorldDispatcher, ref all_character_ids: Array<u32>) -> Array<CharacterPosition> {
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

        let position = CharacterPositionTrait::new(character_id, position.x, position.y, character.steps_amount, 0 );
        // Store the initial position in our array
        initial_positions.append(position);
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

        all_live_bullets.append(bullet);
    };

    return all_live_bullets;
}

fn check_is_character_owner(world: IWorldDispatcher, id: u32, player: ContractAddress) -> bool {
    let character = get!(world, id, (Character));
    character.player_id == player
}

fn filter_out_dead_characters(world: IWorldDispatcher, all_character_positions: Array<CharacterPosition>, dead_characters: Array<u32>) -> (Array<CharacterPosition>, Array<u32>) {
    let mut filtered_positions: Array<CharacterPosition> = ArrayTrait::new();
    let mut filtered_ids: Array<u32> = ArrayTrait::new();
    let mut i = 0;
    loop {
        if i >= all_character_positions.len() {
            break;
        }
        let character = *all_character_positions.at(i);
        let mut is_dead = false;
        let mut j = 0;
        loop {
            if j >= dead_characters.len() {
                break;
            }
            if character.id == *dead_characters.at(j) {
                is_dead = true;
                break;
            }
            j += 1;
        };
        if !is_dead {
            filtered_positions.append(character);
            filtered_ids.append(character.id);
        }
        i += 1;
    };
    return (filtered_positions, filtered_ids);
}

fn extract_bullet_ids(bullets: Array<Bullet>) -> Array<u32> {
    let mut bullet_ids: Array<u32> = ArrayTrait::new();
    let mut i = 0;
    loop {
        if i >= bullets.len() {
            break;
        }
        let bullet = *bullets.at(i);
        bullet_ids.append(bullet.bullet_id);
        i += 1;
    };
    return bullet_ids;
}