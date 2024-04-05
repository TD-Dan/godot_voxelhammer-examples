# Godot VoxelHammer Examples and Tests

<img src="https://badgen.net/badge/Godot/v%204.2.1/blue?icon=https://godotengine.org/themes/godotengine/assets/press/icon_monochrome_dark.svg"> <img src="https://badgen.net/badge/license/MIT/blue"> 
<br>
<img src="https://badgen.net/badge/Tests Passing/10 of 16/orange">

Example and test project of [godot-voxelhammer](https://github.com/TD-Dan/godot-voxelhammer)


## Examples

### Live Blobs

![image](https://user-images.githubusercontent.com/37656679/236407797-eda89daa-d55b-461c-b984-d76e5bb54a62.png)

Shows dynamic creation of geometry with a VoxelPaintStack.

## Tests

### 01 VoxelInstance



### 02 Multiple VoxelInstances

passing 1 / 1


### 03 Live Instances

![image](https://user-images.githubusercontent.com/37656679/235439473-424265e2-1125-42bd-a40e-a77f718ef722.png)

:heavy_check_mark: No frame jitter<br>
#### meshing modes:
:heavy_check_mark: Cubes<br>
:heavy_check_mark: Faces<br>
#### thread modes:
:x: None - runs in main thread -> does not render everything<br>
:heavy_check_mark: Simple - one local thread per instance
- [ ] WorkerThreadPool - Use global threadpool
passing 4 / 6


### 04 Meshing

![image](https://user-images.githubusercontent.com/37656679/236410839-4b8cd054-2900-4f8b-bd4c-9a497dcaf3c5.png)

:heavy_check_mark: single material<br>
:heavy_check_mark: multiple materials<br>
:heavy_check_mark: erroneus materials -> negative indices should display error material<br>
:x: transparencies -> should show internal voxels<br>
passing 3/4


### 05 Voxel Painting
:heavy_check_mark: in editor<br>
:heavy_check_mark: in game<br>
passing 2/2


### 06 DatabaseStreamer
:heavy_check_mark: folder and stream management<br>
:heavy_check_mark: Saving Streamables to file<br>
:heavy_check_mark: Loading Streamables from file<br>
:heavy_check_mark: scn/tscn file format<br>
passing  4/4

possible features to add:
- encryption


### 07 DebugMesh
passing 1/1


### 08 Octrees
passing 1/1


### 09 Multiple duplicates
not implemented
passing 0/1


### 10 VoxelScaling
- [ ] How should scaling work?
passing 0/1


### 11 ChunkSpace3D
:heavy_check_mark: Chunks generate and are removed around moving hotspots<br>
passing 1/1


### 12 Editor Instantiation
:heavy_check_mark: VoxelInstance3D by Add Child Node (Ctrl-A)<br>
- [ ] VoxelInstance3D by VoxelHammer plugin Dock NOT TESTED<br>
- [ ] VoxelBody3D by Add Child Node (Ctrl-A) NOT TESTED<br>
- [ ] VoxelBody3D by VoxelHammer plugin Dock NOT TESTED<br>
passing 1/4


### 13 PaintStack
:heavy_check_mark: Apply paint stack in local coordinates
passing 1/1


### 14 PaintStack Global
:heavy_check_mark: Apply paint stack in global coordinates
passing 1/1


### 15 VoxelTerrain
:heavy_check_mark: Generate terrain chunks around test targets. SLOW. Needs WorkerThreadPool to not choke CPU with too many threads.
passing 1/1


### 16 VoxelTerrain Collisions
:heavy_check_mark: Spheres collide with voxel terrain
passing 1/1


### 17 VoxelTerrain FPV
-[ ] Chunks generate around moving player (ChunkSpace3D)
-[ ] Terrain persists between sessions (DatabaseStreamer)
-[ ] Terrain is editable (PaintableVoxels component)
passing 0/3



possible features to add:
- [ ] Undo functionality -> https://github.com/TD-Dan/godot-voxelhammer/issues/10
