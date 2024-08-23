<script lang="ts">

	import { dojoStore } from "./stores";
	import { get } from "svelte/store";

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
	} = get(dojoStore);

	let address = burnerManager.account?.address;
	console.log(address);

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
