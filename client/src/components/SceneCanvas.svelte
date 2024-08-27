<script lang="ts">
    import { Canvas } from "@threlte/core";
    import { World } from "@threlte/rapier";
    import Game from "./Game.svelte";
</script>

<Canvas>
    <World>
        <Game />
    </World>
</Canvas>