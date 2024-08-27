<script lang="ts">
    import {T} from "@threlte/core";
    import { setupStore } from "src/main";
    import { createComponentValueStore } from "src/dojo/componentValueStore";
    import { derived } from "svelte/store";
    export let id = 0;
    let entity: any;
    let character
    console.log(id)

	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);

    $: entity = derived(setupStore, ($store) =>
        $store
        ? torii.poseidonHash([BigInt(id).toString()])
        : undefined
    );

    let account: any;
 
    $: if (burnerManager) account = burnerManager.getActiveAccount();
    $: character = createComponentValueStore(clientComponents.Character, entity);
    $: position = createComponentValueStore(clientComponents.Position, entity);

    function AddressToBigInt(address) {
        // Ensure the address starts with '0x'
        if (!address.startsWith('0x')) {
            address = '0x' + address;
        }
        // Convert hexadecimal address to BigInt
        return BigInt(address);
    }
</script>

{#if $character && $position && account}
    {#if $character.player_id === AddressToBigInt(account.address)}
        <T.PerspectiveCamera position={[$position.x / 100 - 51, 0.5, $position.y / 100 - 51]} />
    {/if}
    <T.Mesh position={[$position.x / 100 - 51, 0.5, $position.y / 100 - 51]}>
        <T.BoxGeometry />
        <T.MeshStandardMaterial color="red" />
    </T.Mesh>
{/if}



