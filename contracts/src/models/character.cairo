#[derive(Drop, Serde)]
#[dojo::model]
pub struct Character {
    #[key]
    pub entity_id: u8,
    pub session_id: u32,
    pub player_id: bool,
}

#[derive(Copy, Drop, Serde)]
struct Position {
    #[key]
    entity_id: u32, 
    x: u32,
    y: u32,
    z: u32,
}
 
#[derive(Copy, Drop, Serde)]
struct Camera {
    #[key]
    entity_id: u32,
    pitch: u8,
    yaw: u8,
    roll: u8,
}

#[derive(Copy, Drop, Serde)]
struct Health {
    #[key]
    entity_id: u32,
    health: u8,
}