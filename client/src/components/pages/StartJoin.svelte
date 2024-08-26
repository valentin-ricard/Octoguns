<script lang="ts">

	import { createComponentValueStore } from "../../dojo/componentValueStore";
	import { setupStore } from "../../main";
    import { derived, writable } from "svelte/store";
    import { BurnerManager } from "@dojoengine/create-burner";
	import { current_session } from "../../stores";

	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);

	$: global_entity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(0).toString()])
		: undefined
	);

	$: player_entity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(burnerManager.getActiveAccount().address).toString()])
		: undefined
	);

	$: global = createComponentValueStore(clientComponents.Global, global_entity);
	$: player = createComponentValueStore(clientComponents.Player, player_entity);


	$: console.log("Global Updated:", $global);

    let pending_id = writable(null);

</script>

	<div style="justify-content: space-evenly" >
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
				{#each $global.pending_sessions as pending, index} 
					{console.log(pending)}
					<option value={pending.value} key={index}> {pending.value} </option>
				{/each}
			</select>
			<button on:click={async () => {
				const account = burnerManager.getActiveAccount();
				if (account) {
				await client.start.join({ account: account, session_id: $pending_id.value });
				window.location.href = '/game';
				} else {
				console.error("No active account found");
				}
            }}> Join game {$pending_id}</button>
			{/if}
		</div>
		<div>
			{#if $player}
			<span> Render Game: </span>
            <select on:change={(e) => current_session.set(e.target.value)}>
				{#each $player.games as game, index} 
					<option value={game.value} key={index}> {game.value} </option>
				{/each}
			</select>
			<button on:click={async () => {
				const account = burnerManager.getActiveAccount();
				if (account) {
				await client.spawn.spawn({ account: account, session_id: $current_session });
				} else {
				console.error("No active account found");
				}
            }}> Spawn game {$current_session}</button>
			{/if}
		</div>
	</div>


<style lang="scss">

		h1 {
			color: #ff3e00;
			text-transform: uppercase;
			font-size: 4em;
			font-weight: 100;
		}

		.canvas {
			justify-content: center;
			align-content: center;
			align-items: center;
		}
</style>