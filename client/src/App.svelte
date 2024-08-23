<script lang="ts">

	import { dojoStore, modelsStore } from "./stores";
	import { get } from "svelte/store";
	import { Direction } from "./dojo/utils";

	let {
        client,
        clientModels,
        contractComponents,
        systemCalls,
        config,
        world,
        burnerManager,
        rpcProvider,
        sync,
        account,
		toriiClient
	} = get(dojoStore);

	let {models} = get(modelsStore);

	let address = burnerManager.account?.address;
	console.log(models);



</script>

<main>
	<h1>Hello {address}!</h1>
	


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
	}
</style>
