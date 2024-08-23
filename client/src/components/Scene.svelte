<script lang="ts">
	import { T, useTask} from '@threlte/core'
	import { Environment } from '@threlte/extras'
	import { AutoColliders, CollisionGroups } from '@threlte/rapier'
	import { spring } from 'svelte/motion'
	import { BoxGeometry, Mesh, MeshStandardMaterial, Vector3 } from 'three'
	import Character from './Character.svelte'
	import Ground from './Ground.svelte'


	let playerMesh: Mesh
	let positionHasBeenSet = false
	const smoothPlayerPosX = spring(0)
	const smoothPlayerPosZ = spring(0)
	const t3 = new Vector3()
	useTask(() => {
	  if (!playerMesh) return
	  playerMesh.getWorldPosition(t3)
	  smoothPlayerPosX.set(t3.x, {
		hard: !positionHasBeenSet
	  })
	  smoothPlayerPosZ.set(t3.z, {
		hard: !positionHasBeenSet
	  })
	  if (!positionHasBeenSet) positionHasBeenSet = true
	})
  </script>
  <T.DirectionalLight
	castShadow
	position={[8, 20, -3]}
  />
  <T.GridHelper
	args={[50]}
	position.y={0.01}
  />
  <CollisionGroups groups={[0, 15]}>
	<Ground />
  </CollisionGroups>
  <CollisionGroups groups={[0]}>
	<Character
	  bind:playerMesh
	  position={[0, 2, 3]}
	/>
	<AutoColliders shape={'cuboid'}>
	  <T.Mesh
		receiveShadow
		castShadow
		position.x={30 + 0.7 + 0.15}
		position.y={1.275}
		geometry={new BoxGeometry(60, 2.55, 0.15)}
		material={new MeshStandardMaterial({
		  transparent: true,
		  opacity: 0.5,
		  color: 0x333333
		})}
	  />
	  <T.Mesh
		receiveShadow
		castShadow
		position.x={-30 - 0.7 - 0.15}
		position.y={1.275}
		geometry={new BoxGeometry(60, 2.55, 0.15)}
		material={new MeshStandardMaterial({
		  transparent: true,
		  opacity: 0.5,
		  color: 0x333333
		})}
	  />
	</AutoColliders>
  </CollisionGroups>
  
