#[cfg(test)]
mod tests {
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::utils::test::{spawn_test_world, deploy_contract};
    use starknet::testing::{set_caller_address};
    use starknet::ContractAddress;
    // import test utils
    use octoguns::models::{character::{Character, Position, Camera, Health, character, position, camera, health},
                            map::{Map, MapObjects, Bullet, map, map_objects, bullet},
                            sessions::{Session, session, SessionMeta, session_meta}};
    use octoguns::systems::{start::{start, IStartDispatcher, IStartDispatcherTrait}, 
                            move::{move, IMoveDispatcher, IMoveDispatcherTrait}, 
                            spawn::{spawn, ISpawnDispatcher, ISpawnDispatcherTrait}};

    fn setup() -> ( IWorldDispatcher, 
                    IStartDispatcher, 
                    IMoveDispatcher,
                    ISpawnDispatcher) {

        let models = array![ character::TEST_CLASS_HASH,
                            position::TEST_CLASS_HASH,
                            camera::TEST_CLASS_HASH,
                            health::TEST_CLASS_HASH,
                            map::TEST_CLASS_HASH,
                            map_objects::TEST_CLASS_HASH,
                            bullet::TEST_CLASS_HASH,
                            session::TEST_CLASS_HASH,
                            session_meta::TEST_CLASS_HASH
                            
                            ];
        // models
        let mut world = spawn_test_world(["octoguns"].span(), models.span());

        // deploy systems contract
        let move_address = world
            .deploy_contract('salt', move::TEST_CLASS_HASH.try_into().unwrap());
        let spawn_address = world
            .deploy_contract('m', spawn::TEST_CLASS_HASH.try_into().unwrap());
        let start_address = world
            .deploy_contract('b', start::TEST_CLASS_HASH.try_into().unwrap());

        let move_system = IMoveDispatcher { contract_address: move_address };
        let spawn_system = ISpawnDispatcher { contract_address: spawn_address };
        let start_system = IStartDispatcher { contract_address: start_address };

        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), move_address);
        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), spawn_address);
        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), start_address);

        (world, start_system, move_system, spawn_system)
    }

    #[test]
    fn test_setup() {
        let (world, _, _, _) = setup();
    }


}