import { AccountInterface } from "starknet";
import { Entity, getComponentValue } from "@dojoengine/recs";
import { uuid } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponent";
import { Direction, updatePositionWithDirection } from "./utils";
import {
    getEntityIdFromKeys,
    getEvents,
    setComponentsFromEvents,
} from "@dojoengine/utils";
import type { IWorld } from "./defineContractSystems";
import { ContractComponents } from "./defineContractComponents";

export type SystemCalls = ReturnType<typeof systems>;

export function systems({
    client,
    clientModels: { Position, Moves },
    contractComponents,
}: {
    client: IWorld;
    clientModels: ClientComponents;
    contractComponents: ContractComponents;
}) {
    console.log(client);
    console.log(contractComponents);
    console.log(Moves);
    function actions() {
        const spawn = async (account: AccountInterface) => {
            

            try {
                const { transaction_hash } = (await client.actions.spawn({
                    account,
                })) as { transaction_hash: string };
                
            } catch (e) {
                console.error(e);
            }
        };

        const move = async (
            account: AccountInterface,
            direction: Direction
        ) => {
            const entityId = getEntityIdFromKeys([
                BigInt(account.address),
            ]) as Entity;


            try {
                const { transaction_hash } = (await client.actions.move({
                    account,
                    direction,
                })) as { transaction_hash: string };

                
            } catch (e) {
                console.error(e);
            }
        };
        return { spawn, move };
    }

    return {
        actions: actions(),
    };
}
