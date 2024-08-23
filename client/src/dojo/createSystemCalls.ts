import { Account } from "starknet";
import { World, defineSystem, Has, HasValue } from "@dojoengine/recs";
import { ClientComponents } from "./createClientComponents";
import { IWorld } from "./bindings/typescript/contracts.gen";

function createSystemCalls(
    { client }: { client: IWorld },
    {}: ClientComponents,
    world: World
) {
    const startWorld = async (account: Account) => {
        try {
            await client.start.world({ account });
        } catch (e) {
            console.log(e);
        }
    };

    const startCreate = async (account: Account) => {
        try {
            await client.start.create({ account });
        } catch (e) {
            console.log(e);
        }
    };

    const startJoin = async (account: Account, session_id: number) => {
        try {
            await client.start.join({ account, session_id });
        } catch (e) {
            console.log(e);
        }
    };

    const spawnWorld = async (account: Account) => {
        try {
            await client.spawn.world({ account });
        } catch (e) {
            console.log(e);
        }
    };

    const spawn = async (account: Account, session_id: number) => {
        try {
            await client.spawn.spawn({ account, session_id });

            // Wait for the indexer to update the entity
        }
        catch (e) {
            console.log(e);
        }

    };

    return {
        startWorld,
        startCreate,
        startJoin,
        spawnWorld,
        spawn,
    };
}


export default createSystemCalls;
