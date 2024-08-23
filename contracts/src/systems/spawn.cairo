#[dojo::interface]
trait ISpawn {
    fn spawn(ref world: IWorldDispatcher, session_id: u32);
}

#[dojo::contract]
mod start {
    use super::ISpawn;
    use octoguns::models::sessions::{Session};
    use octoguns::models::character::{Character, Position, Camera, Health};
    use octoguns::lib::defaultSpawns::{generate_character_positions};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl SpwanImpl of ISpawn<ContractState> {
        fn spawn(ref world: IWorldDispatcher, session_id: u32) {
            let positions_1 = generate_character_positions(1);
            let positions_2 = generate_character_positions(2);
            let session = get!(world, session_id, (Session));

            let mut i = 0;
            loop {
                if i >= positions_1.len() {
                    break;
                }
                let position_1 = *positions_1[i];
                let position_2 = *positions_2[i];
                let id1 = world.uuid();

                let default_steps = 10;
                set!(
                    world,
                    (
                        Character {
                            entity_id: id1,
                            session_id: session_id,
                            player_id: 1,
                            steps_amount: default_steps, 
                        },
                        Position {
                            entity_id: id1, 
                            x: position_1.x,
                            y: position_1.y,
                            z: 0,
                        },
                        Camera {
                            entity_id: id1,
                            pitch: 0,
                            yaw: 0,
                            roll: 0,
                        },
                        Health {
                            entity_id: id1,
                            health: 100,
                        }
                    )
                );

                let id2 = world.uuid();
                set!(
                    world,
                    (
                        Character {
                            entity_id: id2,
                            session_id: session_id,
                            player_id: 2,
                            steps_amount: default_steps, 
                        },
                        Position {
                            entity_id: id2, 
                            x: position_2.x,
                            y: position_2.y,
                            z: 0,
                        },
                        Camera {
                            entity_id: id2,
                            pitch: 0,
                            yaw: 0,
                            roll: 0,
                        },
                        Health {
                            entity_id: id2,
                            health: 100,
                        }
                    )
                );

                set!(world, Session {
                    session_id: session_id,
                    player1: session.player1,
                    player2: session.player2,
                    map_id: session.map_id,
                    state: 2, // ready to start 
                });    

                i += 1;
            }  

        }
    }
}