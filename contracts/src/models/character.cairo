#[derive(Drop, Serde)]
#[dojo::model]
pub struct Character {
    #[key]
    pub entity_id: u32,
    pub session_id: u32,
    pub player_id: u8,
    pub steps_amount: u32, // The amount of acion s this character can submit
}


// 10 000 x 10 000 x 10 000 map (high level position)
#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Position {
    #[key]
    pub entity_id: u32, 
    pub x: u16, 
    pub y: u16,
    pub z: u16,
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