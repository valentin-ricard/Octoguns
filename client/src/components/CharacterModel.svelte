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

    $: character = createComponentValueStore(clientComponents.Character, entity);
    $: position = createComponentValueStore(clientComponents.Position, entity);
</script>

{#if $character && $position}
<T.Mesh position={[$position.x/ 100 - 51, 0, $position.y / 100 - 51]}>
    <T.BoxGeometry/>
    <T.MeshStandardMaterial color="red"/>
</T.Mesh>
{/if}



