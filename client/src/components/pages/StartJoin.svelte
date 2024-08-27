<script lang="ts">
	import { createComponentValueStore } from "../../dojo/componentValueStore";
	import { setupStore } from "../../main";
    import { derived, writable } from "svelte/store";

	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);

	$: entity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(0).toString()])
		: undefined
	);

	$: global = createComponentValueStore(clientComponents.Session, entity);

	$: console.log("Global Updated:", $global);

</script>

<main>
  {#if $setupStore}
    <p>Setup completed</p>
  {:else}
    <p>Setting up...</p>
  {/if}

  <button
    on:click={async () => {
      const account = burnerManager.getActiveAccount();
      if (account) {
        await client.start.create({ account });
      } else {
        console.error("No active account found");
      }
    }}>spawn</button
  >

  <div>
    {$global}		
  </div>
</main>