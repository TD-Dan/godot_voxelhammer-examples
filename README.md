# godot_voxelhammer-examples

## Examples

### Live Blobs

![image](https://user-images.githubusercontent.com/37656679/236407797-eda89daa-d55b-461c-b984-d76e5bb54a62.png)

Shows dynamic creation of geometry with a VoxelPaintStack.

## Tests

### Editor Instantiation

:heavy_check_mark: VoxelInstance3D by Add Child Node (Ctrl-A)<br>
:heavy_check_mark: VoxelInstance3D by VoxelHammer plugin Dock<br>
:heavy_check_mark: VoxelBody3D by Add Child Node (Ctrl-A)<br>
:heavy_check_mark: VoxelBody3D by VoxelHammer plugin Doc

- [ ] Undo functionality -> https://github.com/TD-Dan/godot-voxelhammer/issues/10

passing 4 / 5

### Live Instances

![image](https://user-images.githubusercontent.com/37656679/235439473-424265e2-1125-42bd-a40e-a77f718ef722.png)

:heavy_check_mark: No frame jitter<br>
#### meshing modes:
:heavy_check_mark: Cubes<br>
:heavy_check_mark: Faces<br>
#### thread modes:
:x: None - runs in main thread -> does not render everything<br>
:heavy_check_mark: Simple - one local thread per instance
- [ ] TaskHammer - Uses global threadpool with priorities -> not implemented yet

passing 4 / 6


### Meshing

![image](https://user-images.githubusercontent.com/37656679/236410839-4b8cd054-2900-4f8b-bd4c-9a497dcaf3c5.png)

:heavy_check_mark: single material<br>
:heavy_check_mark: multiple materials<br>
:heavy_check_mark: erroneus materials -> negative indices should display error material<br>
:x: transparencies -> should show internal voxels<br>

passing 2 / 4

