<script>
    import { Canvas } from "@threlte/core";
    import { World } from "@threlte/rapier";
    import Game from "./Game.svelte";
    import Gun from "./Gun.svelte";
    import { Vector3 } from "three";


</script>

<Canvas size={{height: 800, width: 800}}>
    <World>
        <Game />

    </World>
</Canvas>