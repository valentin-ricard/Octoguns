<script lang="ts">
	import { createComponentValueStore } from "../../dojo/componentValueStore";
	import { setupStore } from "../../main";
    import { derived, writable } from "svelte/store";

	interface Torii {
		poseidonHash: (inputs: any[]) => any; // Adjust types as needed
	}

	$: ({ clientComponents = {}, torii = {} as Torii, burnerManager = {}, client = {} } = $setupStore);

	$: entity = derived(setupStore, ($store) =>
		$store ? torii.poseidonHash([BigInt(0).toString()]) : undefined
	);

	$: global = clientComponents && entity ? createComponentValueStore(clientComponents.Global, entity) : null;

	$: console.log("Global Updated:", $global);

    let pending_id = writable(null);
</script>


	<div style="justify-content: space-evenly" class="start" >
		<button on:click={async () => {
			const account = burnerManager.getActiveAccount();
			if (account) {
			  await client.start.create({ account });
			  window.location.href = '/game';
			} else {
			  console.error("No active account found");
			}
		}}> Create Game </button>

		<div>
			{#if $global}
            <select on:change={(e) => pending_id.set(e.target.value)}>
				{#each $global.pending_sessions as pending (pending.value)} 
					<option value={pending.value} key={pending.value}> {pending.value} </option>
				{/each}
			</select>
			<button on:click={async () => {
				const account = burnerManager.getActiveAccount();
				if (account) {
				await client.start.join({ account: account, session_id: $pending_id });
				window.location.href = '/game';
				} else {
				console.error("No active account found");
				}
            }}> Join game {$pending_id}</button>
			{/if}
		</div>
	</div>


<style lang="scss">

    .start {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
      gap: 0; // Remove gap between elements
    }

    .title-card {
      font-family: 'Block';
      font-size: 15em;
      line-height: 0.8;
      margin-bottom: -0.1em; // Add negative margin to pull content up
    }
</style>
