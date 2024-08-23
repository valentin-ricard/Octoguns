import { AccountInterface, Account } from "starknet";
import { Entity, getComponentValue } from "@dojoengine/recs";
import { uuid } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponent";
import {
    getEntityIdFromKeys,
    getEvents,
    setComponentsFromEvents,
} from "@dojoengine/utils";
import type { IWorld } from "./bindings/typescript/contracts.gen";
import { ContractComponents } from "./bindings/typescript/models.gen";

export type SystemCalls = ReturnType<typeof systems>;

export function systems({
    client,
    clientModels: { Position },
    contractComponents,
}: {
    client: IWorld;
    clientModels: ClientComponents;
    contractComponents: ContractComponents;
}) {
    function start() {
        const world = async (account: Account) => {
            try {
                await client.start.world({ account });
            } catch (e) {
                console.error(e);
            }
        };

        const create = async (account: Account) => {
            try {
                await client.start.create({ account });
            } catch (e) {
                console.error(e);
            }
        };

        const join = async (account: Account, session_id: number) => {
            try {
                await client.start.join({ account, session_id });
            } catch (e) {
                console.error(e);
            }
        };

        return { world, create, join };
    }

    function spawn() {
        const world = async (account: Account) => {
            try {
                await client.spawn.world({ account });
            } catch (e) {
                console.error(e);
            }
        };

        const spawn = async (account: Account, session_id: number) => {
            try {
                await client.spawn.spawn({ account, session_id });
            } catch (e) {
                console.error(e);
            }
        };

        return { world, spawn };
    }

    return {
        start: start(),
        spawn: spawn(),
    };
}