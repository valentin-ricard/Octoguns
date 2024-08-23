
#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Map {
    #[key]
    pub map_id: u32,
    pub map_objects_id: Array<u32>,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct MapObjects {
    #[key]
    pub map_object_id: u32,
    pub dimensions: Dimensions,
    pub coords: Coords,
}

struct Dimensions {
    x: u32,
    y: u32,
    z: u32,
} 

struct Coords {
    x: u32,
    y: u32,
    z: u32,
}