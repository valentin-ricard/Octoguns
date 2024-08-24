use octoguns::models::map::{Bullet, Vec2};
use octoguns::lib::moveChecks::{CharacterPosition};

use alexandria_math::trigonometry::{fast_cos, fast_sin};

// #[derive(Copy, Drop, Serde)]
// #[dojo::model]
// pub struct Bullet {
//     #[key]
//     pub bullet_id: u32,
//     pub coords: Vec2,
//     pub speed: u32, // pixels per step
//     pub direction: u32, // in degrees
// }


// TO DO The bullet simpulation
pub fn simulate_bullets(mut bullets: Array<Bullet>) -> Array<Bullet> {
    let mut bullet_counter = 0;
    let mut updated_bullets = ArrayTrait::new();
    loop {
        if bullet_counter >= bullets.len() {
            break;
        }
        let new_bullet_position = simulate_bullet(bullets.pop_front().unwrap());
        match new_bullet_position {
            Option::Some(bullet) => {
                updated_bullets.append(bullet);
            },
            Option::None => {
                break;
            },
        }
    };
    updated_bullets
}

pub fn simulate_bullet(mut bullet: Bullet) -> Option<Bullet> {

    let position = bullet.coords;
    let position_x = position.x; // i64
    let position_y = position.y; // i64
    let speed = bullet.speed; // in pixels per step
    let direction = bullet.direction; // in degrees from 0 to 259

    let x_shift = (fast_sin(direction) * speed) / 100_000_000;
    let y_shift = (fast_cos(direction) * speed) / 100_000_000;

    let new_position_x = position_x + x_shift;
    let new_position_y = position_y + y_shift;

    if new_position_x < 0 || new_position_x > 10_000 || new_position_y < 0 || new_position_y > 10_000 {
        return Option::None(());
    }

    bullet.coords = Vec2 { x: new_position_x, y: new_position_y };

    return Option::Some(bullet);
}

pub fn compute_bullet_hits(ref bullets: Array<Bullet>, character: CharacterPosition) -> bool {
    return false;
}

#[cfg(test)]
mod simulate_tests {

    use octoguns::models::map::{Bullet, BulletTrait};
    use octoguns::models::map::{Vec2};
    use super::{simulate_bullet, simulate_bullets};

    #[test]
   fn test_bullet_sim_y_only()  {
        let bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 0);
        let res = simulate_bullet(bullet);
        match res {
            Option::None => {
                panic!("Should not be none");
            },
            Option::Some(bullet) => {
                assert!(bullet.coords.y == 1, "y should have changed");
                assert!(bullet.coords.x == 3, "x should not have changed")
            }
        }
    }

    #[test]
    fn test_bullet_sim_x_only()  {
         let bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 90 * 100_000_000);
         let res = simulate_bullet(bullet);
         match res {
             Option::None => {
                 panic!("Should not be none");
             },
             Option::Some(bullet) => {
                println!("x: {}, y: {}", bullet.coords.x, bullet.coords.y);
                 assert!(bullet.coords.x == 4, "x should have changed");
                 assert!(bullet.coords.y == 0, "y should not have changed");
             }
         }
     }

     #[test]
    fn test_4_bullets_sim()  {
        let bullet_1 = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 180);
        let bullet_2 = BulletTrait::new(1, Vec2 { x:3, y:5}, 3, 74);
        let bullet_3 = BulletTrait::new(1, Vec2 { x:6, y:1}, 4, 27);
        let bullet_4 = BulletTrait::new(1, Vec2 { x:3, y:0}, -1, -90);
    
        let bullets = array![bullet_1, bullet_2, bullet_3, bullet_4];
        let res = simulate_bullets(bullets);
         
     }
}