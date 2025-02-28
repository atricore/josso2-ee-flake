# Build

# Create Docer image for JOSSO server

1. Update File

This will update the flake.nix file to the latest JOSSO zip file

```sh
./update-hash.sh
```

2. Build image

You can use the `--rebuild` flag to force a build.

``` sh
nix build .#josso-ee-img
```

3. Import image

``` sh
docker load < result
dfea5d3d84a0: Loading layer  894.9MB/894.9MB
Loaded image: ghcr.io/atricore/josso-ee:2.6.2-9
```

4. Upload image
``` sh
docker image push ghcr.io/atricore/josso-ee:2.6.2-9
The push refers to repository [docker.io/atricore/josso-ee]
dfea5d3d84a0: Pushed
2.6.2-9: digest: sha256:c2627b8bda6a1db1e532f0dd490413b1c241f40831cf49f90db987b7371a3bef size: 529
```
