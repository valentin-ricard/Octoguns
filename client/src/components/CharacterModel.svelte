<script lang="ts">
    import {T} from "@threlte/core";
    import { setupStore } from "src/main";
    import { createComponentValueStore } from "src/dojo/componentValueStore";
    import { derived } from "svelte/store";
    import { CylinderGeometry, MeshStandardMaterial } from "three";
    
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

    console.log(entity)
    $: if (id) character = createComponentValueStore(clientComponents.Character, entity);
    console.log(character)
</script>

{#if $character}
<T.Mesh position = {[0,0,0]}>
    <T.BoxGeometry/>
    <T.MeshStandardMaterial color="red"/>
</T.Mesh>
{/if}



