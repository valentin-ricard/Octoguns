<script lang="ts">

	import { createComponentValueStore } from "./dojo/componentValueStore";
	import { setupStore } from "./main";
    import { derived, writable } from "svelte/store";
	import SceneCanvas from "./components/SceneCanvas.svelte";

	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);

	$: entity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(0).toString()])
		: undefined
	);

	$: global = createComponentValueStore(clientComponents.Global, entity);

	$: console.log("Global Updated:", $global);

    let pending_id = writable(null);
</script>

<main>
	<div style="justify-content: space-evenly" >
		<button on:click={async () => {
			const account = burnerManager.getActiveAccount();
			if (account) {
			  await client.start.create({ account });
			} else {
			  console.error("No active account found");
			}
		  }}> Create Game </button>
		<div>
			{#if global}
            <select on:change={(e) => pending_id.set(e.target.value)}>
				{#each $global.pending_sessions as pending, index} 
					{console.log(pending)}
					<option value={pending.value}s key={index}> {pending.value} </option>
				{/each}
			</select>
			<button on:click={async () => {
				const account = burnerManager.getActiveAccount();
				if (account) {
				await client.start.join({ account: account, session_id: $pending_id.value });
				} else {
				console.error("No active account found");
				}
            }}> Join game {$pending_id}</button>
			{/if}
		</div>
	<div>
	<div class = "canvas" >
		<SceneCanvas />
	<div>
	
</main>

<style lang="scss">
	main {
		text-align: center;
		padding: 1em;
		max-width: 240px;
		margin: 0 auto;

		h1 {
			color: #ff3e00;
			text-transform: uppercase;
			font-size: 4em;
			font-weight: 100;
		}

		@media (min-width: 640px) {
			max-width: none;
		}

		.canvas {
			justify-content: center;
			align-content: center;
			align-items: center;
		}
	}
</style>
