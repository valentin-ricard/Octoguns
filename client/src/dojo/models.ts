import { ContractComponents } from "./bindings/typescript/models.gen";

export type ClientModels = ReturnType<typeof models>;

export function models({
    contractModels,
}: {
    contractModels: ContractComponents;
}) {
    return {
        models: {
            ...contractModels,
        },
    };
}
