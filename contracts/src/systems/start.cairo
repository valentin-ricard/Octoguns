#[dojo::interface]
trait ISetup {
    fn create(ref world: IWorldDispatcher);
    fn join(ref world: IWorldDispatcher, session_id: u32);
}

#[dojo::contract]
mod start {
    use super::ISetup;
    use octoguns::models::sessions::{Session, SessionTrait};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl SetupImpl of ISetup<ContractState> {
        fn create(ref world: IWorldDispatcher) {
            // Do shit
            let player = get_caller_address();
            let id = world.uuid();
            let session = SessionTrait::new(id, player, 1);

            set!(world, (session));
        }

        fn join(ref world: IWorldDispatcher, session_id: u32) {

            let mut session = get!(world, session_id, (Session));

            let player = get_caller_address();

            session.join(player);

            set!(world, (session));        
        }
    }
}