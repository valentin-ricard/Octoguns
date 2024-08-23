use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Session {
    #[key]
    pub session_id: u32,
    pub player1: ContractAddress,
    pub player2: ContractAddress,
    pub map_id: u32,
    pub state: u8, // 0: waiting for seconde player. 1 waiting for spawn, 2 in game, 3 ended.
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct SessionMeta {
    #[key]
    pub session_id: u32,
    pub turn_count: u32, // mod 2 = 1 is player 2 and mod 2 = 0 is player 1
}
