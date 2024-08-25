<script lang="ts">

	import { dojoStore, modelsStore } from "./stores";
	import { get } from "svelte/store";
    import SceneCanvas from "./components/SceneCanvas.svelte";

	const dojo = get(dojoStore);
	let {startCreate, startJoin, spawn} = dojo.systemCalls;
	let account = dojo.burnerManager.account;

	let {models} = get(modelsStore);

	let address = dojo.burnerManager.account?.address;
	console.log(models);

</script>

<main>
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
