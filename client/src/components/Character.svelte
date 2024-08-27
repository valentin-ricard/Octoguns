<script lang="ts">
    import { T, useFrame, useThrelte } from '@threlte/core'
  import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier'
  import { PerspectiveCamera, Vector2, Vector3 } from 'three'
  import PointerLockControls from './PointerLockControls.svelte'
  import Gun from './Gun.svelte'
    import type { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat'
    import { writable } from 'svelte/store'
    import { Bullet } from 'src/dojo/typescript/models.gen'
  //  import { bullets, characters } from 'src/stores'

  export let position: [number, number, number] = [0, 0, 0]
  
    let rigidBody: RapierRigidBody
    let cam: PerspectiveCamera
    let moveDirection = new Vector3()
    let speed = 5

    let previous_move = [0,0,0];
    let moves: any[] = [];

    let interval = .05;
    let turn_length = 600;
let isMouseDown = false;


    let bullets:any[] = [];
    let cooldown = 0;
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

    function handleMouseDown(event: MouseEvent) {
    if (event.button === 0) { // Left mouse button
        isMouseDown = true;
    }
      }

      function handleMouseUp(event: MouseEvent) {
          if (event.button === 0) { // Left mouse button
              isMouseDown = false;
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
            if (cooldown > 0){
              cooldown -=1;
            }
            if (frame_counter == 300) {
              turn_over = true;
              document.exitPointerLock();
              console.log(moves)

            }
            if (isMouseDown) {
              if ( bullets.length < 5 && cooldown == 0) {
                //TODO make sure to normailze so that (0,0) is corner rather than center
                let position = new Vector2(rigidBody.translation().x, rigidBody.translation().y)
                console.log(position)
                let bullet = {position: position};
                console.log(bullet)

                bullets.push({position:position, cam: cam.quaternion, speed:25, index:(frame_counter%3)});
                
                cooldown = 5;
              }
            }

            let move = {x: moveDirection.x, y: moveDirection.y}

            const currentVel = rigidBody.linvel()
            rigidBody.setLinvel({ x: moveDirection.x, y: currentVel.y, z: moveDirection.z }, true)

            // Update position for camera and other components
            const pos = rigidBody.translation()
            position = [pos.x, pos.y, pos.z]

        // Update bullets
        for (let i = 0; i < bullets.length; i++) {
          let bullet = bullets[i];
          
          // Calculate the displacement
          let displacement = new Vector2(
            Math.cos(bullet.angle) * bullet.velocity * delta,
            Math.sin(bullet.angle) * bullet.velocity * delta
          );
          
          // Update the bullet's position
          bullet.position.add(displacement);
          
          // Optional: Remove bullets that have traveled too far
          if (bullet.position.length() > 1000) { // Adjust this value as needed
            bullets.splice(i, 1);
            i--;
          }
          console.log(bullets)
        }
      }
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

<svelte:window on:keydown={handleKeyDown} 
                  on:keyup={handleKeyUp} 
                  on:mousedown={handleMouseDown}
                  on:mouseup={handleMouseUp}/>
<div class="progress-container">
  <div class="progress-bar" style="width: 100%"> {progressWidth}</div>
</div>

<T.Group {position}>
    <T.PerspectiveCamera
        makeDefault
        fov={90}
        bind:ref={cam}
        position={[0, 1.7, 0]}
        enabledRotations={[true, false, true]}
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