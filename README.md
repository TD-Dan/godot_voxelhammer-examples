# godot_voxelhammer-examples

## Tests

### Editor Instantiation

:heavy_check_mark: VoxelInstance3D by Add Child Node (Ctrl-A)<br>
:heavy_check_mark: VoxelInstance3D by VoxelHammer plugin Dock<br>
:x: VoxelBody3D by Add Child Node (Ctrl-A) -> some weird double mesh instantiation going on when loading the scene<br>
:x: VoxelBody3D by VoxelHammer plugin Dock -> some weird double mesh instantiation going on when loading the scene

- [ ] Undo functionality -> https://github.com/TD-Dan/godot-voxelhammer/issues/10

passing 2 / 5

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

![image](https://user-images.githubusercontent.com/37656679/235443330-9b153515-7dda-4181-b60f-a714d44d34e7.png)

:heavy_check_mark: single material<br>
:heavy_check_mark: multiple materials<br>
:x: erroneus materials -> negative indices should display error material<br>
:x: transparencies -> should show internal voxels<br>

passing 2 / 4

