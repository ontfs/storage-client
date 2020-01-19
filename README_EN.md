EN | [中文](README.md)

## ONTFS Client Usage Documentation

#### Tools and Pre-requisites

1. [Client interface](http://ontfs.io/)
2. Wallet file (`.dat` file exported using an Ontology wallet)
3. [Test net token balance](http://ontfs.io/)

> A testnet wallet is required to use the SDK. Testnet tokens can be applied for using the link provided above.

#### Usage Process

##### Step 1:

Create a `config.json` file and move it to the same directory under which `ontfs-client` is located.

Here is a sample configuration file:

```json
{
  "DBPath": "./Sdk/DB",
  "FsRepoRoot": "./Sdk/OntFs",
  "FsFileRoot": "./Sdk/Download", 
  "RpcPort": 21336, 
  "LogLevel": 1,
  "DisableStdLog": false
}
```

|   Field    | Description                        |
| :--------: | ---------------------------------- |
| FsFileRoot | File download directory            |
|  RpcPort   | Default enabled port of the client |

The client automatically reads the configuration file `config.json` when launched using the command line or when the client executable is double-clicked.

![](./images/step1.jpg)

##### Step 2:

The SDK is launched by invoking the `RPC API`. It is important to ensure that the SDK has been initialized. This needs to be done one time only. The command used is: `./ontfs-client service start`

```text
API URL: http://localhost:21336
```

```json

{
  "jsonrpc": "2.0",
  "method": "startsdk",
  "params": [
        {
        "ChainRpcAddr": "http://128.1.40.229:20336",
        "WalletPath": "",
        "WalletPwd": "",
        "GasPrice": 0,
        "GasLimit": 20000,
        "PdpVersion": 1,
        "P2pProtocol": "tcp",
        "P2pListenAddr": "0.0.0.0:20556",
        "P2pNetworkId": 7,
        "BlockConfirm": 0
        }
  ],
  "id": "1"
}
```
| Parameter    | Description             |
| :----------: | ----------------------- |
| ChainRpcAddr | RPC server URL          |
| WalletPath   | `.dat` wallet file path |
| WalletPwd    | Wallet password         |
| PdpVersion   | PDP proof version       |

![](/Users/ericyang/Desktop/client_moc/use_doc/images/step2.jpg)


All the methods of the `API` can be invoked as soon as the **ONTFS** client is running.

Please refer to the [RPC API Documentation](https://docs.ontfs.io/) for detailed description of the available methods.
