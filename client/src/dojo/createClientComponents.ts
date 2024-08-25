import { overridableComponent } from "@dojoengine/recs";
import { defineContractComponents } from "./bindings/typescript/models.gen";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
    contractComponents,
}: {
    contractComponents: Awaited<ReturnType<typeof defineContractComponents>>;
}) {
    return {
        ...contractComponents,
        Character: overridableComponent(contractComponents.Character),
        Health: overridableComponent(contractComponents.Health),
        Map: overridableComponent(contractComponents.Map),
        MapObjects: overridableComponent(contractComponents.MapObjects),
        Session: overridableComponent(contractComponents.Session),
        Position: overridableComponent(contractComponents.Position),
        Bullet: overridableComponent(contractComponents.Bullet)
    };
}
