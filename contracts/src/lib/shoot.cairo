use octoguns::types::{Action, CharacterPosition};
use octoguns::models::bullet::{Bullet, BulletTrait};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

fn shoot(world: IWorldDispatcher, bullet: Action, character: CharacterPosition) -> Bullet {
    let angle = bullet.action_type; //i64
    let coords = character.coords; //Vec2
    let speed = 25;
    let id = world.uuid();
    let new_bullet = BulletTrait::new(id, coords, speed, angle);

    set!(world, (new_bullet));

    return new_bullet;
}