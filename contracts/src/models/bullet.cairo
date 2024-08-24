use octoguns::types::Vec2; 

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Bullet {
    #[key]
    pub bullet_id: u32,
    pub coords: Vec2,
    pub speed: i64, // pixels per step
    pub direction: i64, // in degrees
}


#[generate_trait]
impl BulletImpl of BulletTrait {

    fn new(id: u32, coords: Vec2, speed: i64, direction: i64) -> Bullet {
        Bullet { bullet_id: id, coords, speed, direction}
    }

}