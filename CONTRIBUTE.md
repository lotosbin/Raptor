# CONTRIBUTE

## Ref
https://developer.valvesoftware.com/wiki/Source_RCON_Protocol
https://minecraft.wiki/w/RCON

## 
Starting a server for testing
```shell
docker pull itzg/minecraft-server
docker run --name=minecraft-server -p 25575:25575 -d -e EULA=TRUE itzg/minecraft-server
```
