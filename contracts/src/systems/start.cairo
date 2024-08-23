#[dojo::interface]
trait ISetup {
    fn create(ref world: IWorldDispatcher);
    fn join(ref world: IWorldDispatcher, session_id: u32);
}

#[dojo::contract]
mod start {
    use super::ISetup;
    use octoguns::models::sessions::{Session};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl SetupImpl of ISetup<ContractState> {
        fn create(ref world: IWorldDispatcher) {
            // Do shit
            let player = get_caller_address();
            let id = world.uuid();

            set!(world, Session {
                session_id: id,
                player1: player,
                player2: player,
                map_id: 1,
                state: 0, 
            });
        }

        fn join(ref world: IWorldDispatcher, session_id: u32) {

            let session = get!(world, session_id, (Session));

            let player = get_caller_address();
            set!(world, Session {
                session_id: session_id,
                player1: session.player1,
                player2: player,
                map_id: session.map_id,
                state: 1, // ready to start 
            });        
        }
    }
}