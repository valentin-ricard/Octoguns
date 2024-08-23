#[derive(Drop, Serde)]
#[dojo::model]
pub struct Character {
    #[key]
    pub entity_id: u32,
    pub session_id: u32,
    pub player_id: u8,
    pub steps_amount: u32, // The amount of acion s this character can submit
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Position {
    #[key]
    pub entity_id: u32, 
    pub x: u8,
    pub y: u8,
    pub z: u8,
}
#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Camera {
    #[key]
    pub entity_id: u32,
    pub pitch: u8,
    pub yaw: u8,
    pub roll: u8,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Health {
    #[key]
    pub entity_id: u32,
    pub health: u8,
}