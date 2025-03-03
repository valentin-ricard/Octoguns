use octoguns::types::Vec2;

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Map {
    #[key]
    pub map_id: u32,
    pub map_objects_id: Array<u32>,
}

// Map is composed of a 100 x 100 Blocks used to place characters and objects
// Each square has a 1000 x 1000 grid hosted in each block for fine precion.
#[derive(Drop, Serde)]
#[dojo::model]
pub struct MapObjects {
    #[key]
    pub map_object_id: u32,
    pub dimensions: Vec2,
    pub coords: Vec2, 
}

