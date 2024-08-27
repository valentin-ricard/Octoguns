<script lang="ts">
	import SceneCanvas from "../../components/SceneCanvas.svelte";
    import { character_counter } from "src/stores";
</script>

<div class="container">
    <SceneCanvas />
</div>

<style>
    .container {
        display: flex;
        width: 100vw;
        height: 100vh;
        overflow: hidden;
    }

    :global(canvas) {
        width: 100%;
        height: 100%;
        display: block;
    }
</style>