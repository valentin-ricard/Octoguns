<script lang="ts">
    import { T, useFrame, useThrelte } from '@threlte/core'
  import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier'
  import { PerspectiveCamera, Vector3 } from 'three'
  import PointerLockControls from './PointerLockControls.svelte'
  import Gun from './Gun.svelte'
    import type { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat'
    import { writable } from 'svelte/store'

  export let position: [number, number, number] = [0, 0, 0]
    let rigidBody: RapierRigidBody
    let cam: PerspectiveCamera
    let moveDirection = new Vector3()
    let speed = 5

    let previous_move = [0,0,0];
    let moves = [];

    let interval = .05;
    let turn_length = 600;

    let frame_counter = 0;

    $: progressWidth = Math.min(frame_counter/300 * 100, 100);


    const keyState = {
        forward: false,
        backward: false,
        left: false,
        right: false,
    }

    function handleKeyDown(event: KeyboardEvent) {
        switch (event.key.toLowerCase()) {
            case 'w': keyState.forward = true; break
            case 's': keyState.backward = true; break
            case 'a': keyState.left = true; break
            case 'd': keyState.right = true; break
        }
    }

    function handleKeyUp(event: KeyboardEvent) {
        switch (event.key.toLowerCase()) {
            case 'w': keyState.forward = false; break
            case 's': keyState.backward = false; break
            case 'a': keyState.left = false; break
            case 'd': keyState.right = false; break
        }
    }

    let turn_over = false;

    useFrame((_, delta) => {
        if (!rigidBody || !cam) return
        moveDirection.set(0, 0, 0)

        
        if (keyState.forward) moveDirection.z -= 1
        if (keyState.backward) moveDirection.z += 1
        if (keyState.left) moveDirection.x -= 1
        if (keyState.right) moveDirection.x += 1

        if (moveDirection.length() > 0) {
          frame_counter += 1;

          moveDirection.normalize().multiplyScalar(speed)
          moveDirection.applyQuaternion(cam.quaternion);
          moveDirection.x.toPrecision(100);
          moveDirection.z.toPrecision(100);

          if (frame_counter % 3 == 0 && !turn_over) {
            if (frame_counter == 300) {
              turn_over = true;
              document.exitPointerLock();
              console.log(moves)

            }
            console.log(moveDirection.multiplyScalar(3))

            let move = {x: moveDirection.x, y: moveDirection.y}
            moves.push(move)
            console.log(move)
            console.log(Math.sqrt(move.x**2 + move.y**2))

            const currentVel = rigidBody.linvel()
            rigidBody.setLinvel({ x: moveDirection.x, y: currentVel.y, z: moveDirection.z }, true)

            // Update position for camera and other components
            const pos = rigidBody.translation()
            position = [pos.x, pos.y, pos.z]
          }

          //TODO UPDATE BULLETS
        }
    })

    const { renderer } = useThrelte()
    
    function lockControls() {
        if (document.pointerLockElement !== renderer.domElement) {
            renderer.domElement.requestPointerLock()
        }
    }

    renderer.domElement.addEventListener('click', lockControls)
</script>

<svelte:window on:keydown={handleKeyDown} on:keyup={handleKeyUp} />
<div class="progress-container">
  <div class="progress-bar" style="width: 100%"> {progressWidth}</div>
</div>

<T.Group {position}>
    <T.PerspectiveCamera
        makeDefault
        fov={90}
        bind:ref={cam}
        position={[0, 1.7, 0]}
    >
        <PointerLockControls />
        <Gun position={new Vector3(.8, -.65,-.75)}/>

    </T.PerspectiveCamera>
    
    <RigidBody bind:rigidBody {position} type="dynamic" enabledRotations={[false, false, false]}>
    <CollisionGroups groups={[0]}>
            <Collider shape={'capsule'} args={[0.85, 0.3]} />
    </CollisionGroups>
    <CollisionGroups groups={[15]}>
            <T.Group position={[0, -0.85, 0]}>
                <Collider sensor shape={'ball'} args={[0.36]} />
      </T.Group>
    </CollisionGroups>
        <T.Mesh castShadow>
            <T.BoxGeometry args={[1, 2, 1]} />
            <T.MeshStandardMaterial color="blue" />
        </T.Mesh>
  </RigidBody>
</T.Group>

<style>
  .progress-container {
    width: 100%;
    height: 10px; /* Increased height for visibility */
    background-color: rgba(240, 240, 240, 0.5); /* Semi-transparent background */
    position: fixed; /* Changed to fixed */
    top: 0;
    left: 0;
    z-index: 1000;
    pointer-events: none; /* Allows clicks to pass through */
  }

  .progress-bar {
    height: 100%;
    background-color: #4CAF50;
    transition: width 0.3s ease;
  }
</style>