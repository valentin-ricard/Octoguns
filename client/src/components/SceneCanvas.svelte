<script>
    import { Canvas } from "@threlte/core";
    import { World } from "@threlte/rapier";
    import Scene from "./Scene.svelte";
</script>

<Canvas size={{height: 800, width: 800}}>
    <World>
        <Scene />
    </World>
</Canvas>