#[dojo::interface]
trait ISpawn {
    fn spawn(ref world: IWorldDispatcher);
}

#[dojo::contract]
mod start {
    use super::ISpawn;
    use octoguns::models::sessions::{Session};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl SpwanImpl of ISpawn<ContractState> {
        fn spawn(ref world: IWorldDispatcher) {
            
        }
    }
}