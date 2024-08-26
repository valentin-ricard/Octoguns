<script lang="ts">
	import { createComponentValueStore } from "./dojo/componentValueStore";
	import { setupStore } from "./main";
    import { derived, writable } from "svelte/store";
	import SceneCanvas from "./components/SceneCanvas.svelte";

	let inGame = false;
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

<main>
	<div style="justify-content: space-evenly" class="start" >
		{#if !inGame}
		<div class="title-card">
			<div>OCTO</div>
			<div>GUNS</div>
		</div>
		<button on:click={async () => {
			const account = burnerManager.getActiveAccount();
			if (account) {
			  await client.start.create({ account });
			  inGame = true;
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
				inGame = true;
				} else {
				console.error("No active account found");
				}
            }}> Join game {$pending_id}</button>
			{/if}
		</div>

		{/if}	
		{#if inGame}
			<div class="canvas">
				<SceneCanvas />
			</div>
		{/if}
	</div>
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
	}
</style>
