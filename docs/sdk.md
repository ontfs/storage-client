# OntFs Sdk Rpc Api


* [介绍](#介绍)
* [RPC接口列表](#rpc接口列表)
* [错误代码](#错误代码)

## 介绍
本文档是OntFs Sdk的RPC接口文档，详细定义了每种接口的参数与返回值。

以下是一些接口中用到的字段的定义：

#### 请求参数定义:

| 字段 | 类型 | 定义 |
| :---| :---| :---|
| jsonrpc | string | jsonrpc版本号 |
| method | string | 方法名 |
| params | string | 方法要求的参数 |
| id | string | 任意值 |

#### 相应参数定义:

| 字段 | 类型 | 定义 |
| :---| :---| :---|
| desc| string | 请求结果描述 |
| error | int64 | 错误代码 |
| jsonrpc | string | jsonrpc版本号 |
| id | string | 任意值 |
| result | object | RPC执行结果 |

>注意: 不同的请求类型会返回不同类型的Result。

#### 启动sdk选项 sdk_option 定义

| 参数名              | 类型      | 是否必须  | 说明                                       |
| ------------------ | -------- | -------- | --------------------------------------- |
| ChainRpcAddr       | string   | required | 本体rpc地址                                 |
| WalletPath         | string   | required | 钱包文件目录                                 |
| WalletPwd          | string   | required | 钱包密码                                    |
| GasPrice          | uint64   | required | GasPrice                                 |
| GasLimit        | uint64   | required | GasLimit                                |
| PdpVersion        | uint64   | required | pdp版本号                                 |
| P2pProtocol        | string   | required | p2p协议类型                                 |
| P2pListenAddr      | string   | required | p2p协议监听地址                              |
| P2pNetworkId       | uint64   | required | p2p网络标示ID                               |
| BlockConfirm       | uint64   | required | 等待区块确认数                               |

#### 文件上传选项 upload_option 定义：


| 参数名              | 类型      | 是否必须  | 说明                                       |
| ------------------ | -------- | -------- | ----------------------------------------- |
| FilePath           | string   | required | 文件目录                                   |
| FileDesc           | string   | required | 文件描述                                   |
| TimeExpired        | uint64   | required | 文件过期时间，unix时间戳                     |
| PdpInterval            | uint64   | required | Pdp证明提交间隔           建议为4 * 60 * 60 即4小时，如果网络内所有存储节点的MinPdpInterval都小于此值，则无法找到可用服务器                     |
| CopyNum            | uint64   | required | 文件备份数量                                |
| FirstPdp        | bool   | required | ontfs节点是否计算第一次pdp证明，snark版pdp模式下，第一次不计算pdp可以节省上传后立即下载的等待时间      |
| StorageType        | uint64   | required | 存储类型：0表示租户模式; 1表示文件租用模式      |
| FileSize           | uint64   | required | 文件真实大小                                |
| Encrypt            | bool     | required | 是否加密                                   |
| EncryptPassword         | string   | required | 加密密码                                   |
| WhiteList          | []string | optional | 白名单，暂不支持                            |

#### 文件下载选项 download_option 定义


| 参数名      | 类型   | 是否必须 | 说明                                         |
| ----------- | ------ | -------- | -----------------------------------------|
| FileHash    | string | required | 文件哈希                                  |
| InOrder     | bool   | required | 是否按文件块顺序下载，暂只支持true            |
| MaxPeerCnt  | int    | required | 下载文件的最多存储节点源数量                  |
| OutFilePath    | string | required | 自定义文件下载路径，仅名称，则下载到默认路径中     |
| DecryptPwd  | string | required | 解密密码                                   |



#### 文件解密选项 decrypt_option 定义

| 参数名      | 类型   | 是否必须 | 说明                                         |
| ----------- | ------ | -------- | -----------------------------------------|
| FilePath    | string | required | 源文件路径                                  |
| OutFilePath    | string | required | 自定义文件下载路径，仅名称，则下载到默认路径中     |
| DecryptPwd  | string | required | 解密密码                                   |



## RPC接口列表
| Method | Parameters | Description | Note |
| :---| :---| :---| :---|
| [startsdk](#0-startsdk) | sdk_option | 启动sdk服务 | sdk_option参数见文件上传选项定义 |
| [uploadfile](#1-uploadfile) | upload_option | 上传文件 | upload_option参数见文件上传选项定义 |
| [downloadfile](#2-downloadfile) | download_option | 下载文件 | download_option参数文件下载选项定义 |
| [decryptfile](#3-decryptfile) | decrypt_option | 解密文件 | decrypt_option参数文件解密选项定义 |
| [renewfile](#4-renewfile) | file_hash,add_time | 文件续费 |  |
| [deletefiles](#5-deletefiles) | [file_hash1,file_hash2] | 批量删除文件 |  |
| [getfileinfo](#6-getfileinfo) | file_hash | 查询单个已上传的文件信息 |  |
| [getfilelist](#7-getfilelist) | | 查询单用户所有文件列表 |  |
| [changefileowner](#8-changefileowner) | file_hash,new_owner | 更改文件所有权 |  |
| [getfilereadpledge](#9-getfilereadpledge) | file_hash | 查询下载文件在合约中的质押情况 |  |
| [cancelfilereadpledge](#10-cancelfilereadpledge) | file_hash | 从下载文件合约质押中提款 |  |
| [getfilepdpinfolist](#11-getfilepdpinfolist) | file_hash | 查询文件的pdp证明记录信息 |  |
| [getspaceinfo](#12-getspaceinfo) | |获取用户空间信息 |  |
| [createspace](#13-createspace) | volume,copy_num,time_expired | 创建用户空间 |  |
| [deletespace](#14-deletespace) | | 删除用户空间 |  |
| [updatespace](#15-updatespace) | volume,time_expired | 更新用户空间 |  |
| [getfsnodeslist](#16-getfsnodeslist) | limit | 获取存储节点信息列表 |  |


### 0. startsdk

启动sdk，进行sdk初始化操作，使用其他任何RPC接口，需确保sdk以初始化，只需一次

#### 参数定义
sdk_option: sdk初始化选项

P2pNetworkId应当与ontfs网络的network id保持一致

#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "startsdk",
    "params": [{
        "ChainRpcAddr": "http://127.0.0.1:20336",
        "WalletPath": "./wallet.dat",
        "WalletPwd": "pwd",
        "GasPrice": 500,
        "GasLimit": 20000,
        "PdpVersion": 1,
        "P2pProtocol": "tcp",
        "P2pListenAddr": "127.0.0.1:20556",
        "P2pNetworkId": 0,
        "BlockConfirm": 1
    }],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```

### 1. uploadfile

上传文件

#### 参数定义
upload_option: 上传选项
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "uploadfile",
    "params": [{
        "FilePath": "../testfile.tar.gz",
        "FileDesc": "testfile.tar.gz",
        "FileSize": 12341412,
        "TimeExpired": 23423434,
        "FirstPdp": true,
        "PdpInterval": 4 * 60 * 60,
        "CopyNum": 3,
        "StorageType": 1,
        "Encrypt": true,
        "EncryptPassword": "ontfspwd",
        "WhiteList": []
    }],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": {
        "Tx": "e4b5fd08dc48160211b528f15002a80819c439d4f3f1edefb18c3ca138bdfef9",
        "FileHash": "SeNKJ5konzonQ4rqN7RRtNAmKD3hxcLuJKNAtSvjZxcyKQea",
        "Url": "ontfs://SeNKJ5konzonQ4rqN7RRtNAmKD3hxcLuJKNAtSvjZxcyKQea\u0026name=config.json\u0026owner=ALJwq2WYwL26E55dWJs66cAF1E79cDpXeN\u0026size=167\u0026blocknum=1"
    }
}
```

### 2. downloadfile

下载文件

#### 参数定义
download_option: 下载选项
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "downloadfile",
    "params": [{
        "FileHash": "SeNKJ5konzonQ4rqN7RRtNAmKD3hxcLuJKNAtSvjZxcyKQea",
        "InOrder": true,
        "MaxPeerCnt": 3,
        "OutFilePath": "./testfile.tar.gz"
        "DecryptPwd": "ontfspwd"
    }],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```

### 3. decryptfile

解密文件

#### 参数定义
decrypt_option: 解密选项
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "decryptfile",
    "params": [{
        "FilePath": "./testfile.tar.gz",
        "OutFilePath": "./testfile_decrypted.tar.gz",
        "DecryptPwd": "ontfspwd"
    }],

    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```


### 4. renewfile

文件续费

#### 参数定义
file_hash: 文件hash
add_time: 增加时间，单位秒
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "renewfile",
    "params": ["SeNKJ5konzonQ4rqN7RRtNAmKD3hxcLuJKNAtSvjZxcyKQea", 3600],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```

### 5. deletefiles

批量删除文件

#### 参数定义
file_hash: 文件hash
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "deletefiles",
    "params": [
        ["SeNKJ5konzonQ4rqN7RRtNAmKD3hxcLuJKNAtSvjZxcyKQea", "Sk9yPZdThcHikj1L1sQmxgXAJap9x24vMVJUdG2cky4KEpAe"]
    ],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```


### 6. getfileinfo

查询单个已上传的文件信息

#### 参数定义
file_hash: 文件hash
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "getfileinfo",
    "params": ["Sk9yPZdThcHikj1L1sQmxgXAJap9x24vMVJUdG2cky4KEpAe"],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": {
        "FileHash": "Sk9yPZdThcHikj1L1sQmxgXAJap9x24vMVJUdG2cky4KEpAe",
        "FileOwner": "ALJwq2WYwL26E55dWJs66cAF1E79cDpXeN",
        "FileDesc": "ont-fs-sdk_0.1.0.tgz",
        "FileBlockCount": 13,
        "RealFileSize": "2.8 MB",
        "CopyNumber": 2,
        "PayAmount": "0.002715648 ONG",
        "RestAmount": "0.002156544 ONG",
        "FileCost": "0.000559104 ONG",
        "FirstPdp": true,
        "PdpInterval": 14400,
        "TimeStart": "2019-12-09 19:05:14 +0800 CST",
        "TimeExpired": "2019-12-12 15:04:05 +0800 CST",
        "PdpParam": "gQFrQHmalXSUBnZ1M7Bu0BC+JCCd1+UsPO4g6jwa56VmHl8TWwBINIgnUh5/PMoQRPHHRNRSmJDV+YrJ6u2EXzdAeRbVWptVuPEVSvWQlzKZuTiRsaovm2nVTVAgFJBHKTcUxTzLFtmKCLJ5OzP1ZLXNiRZYUx91kJ1j2OTUwmu+gkBHeO+3LfIc81loeRAjL/wK9MvWdTYUlCL6/zork4hNG1KKuA0z8XMxUJlWL8vvJa9Iyhc8HYAWO0jTj0d8tQp+gQEvn4dLat/J6+k/UTyjHbKSb18Wvblc6t/qgg+6WozuAzTqEbBcBJ050HtVCIUXfAJ+My5be+39lhPlv5Dw27t5N4pjwyl4kpGp8NqRMhhYlp1TrpixpSX79wWpdXDVYuUjMU6hmpNe8KMQGZJi6bgw58nZdmEpkfWgfEH6xo6ZqSDOnaRlFuMEJ0EiSn+QYeMYGlpNF6u6crboKSKvN1PXVg==",
        "ValidFlag": true,
        "StorageType": 1
    }
}
```

### 7. getfilelist

查询单用户所有文件列表

#### 参数定义

#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "getfilelist",
    "params": [],
    "id": "1"
}
```


Response:
```
{
    "desc": "SUCCESS",
    "error": 0,
    "id": "1",
    "jsonrpc": "2.0",
    "result": [
        "SeNK9CUPQUycH29qHUNWHkvjk9kY1QcB1VdpYTG3rnSfqKaN",
        "Sk9yJBSzGRwEdcuWiECz6hTNMSjwbF7Zq2tbi3TTubuYEBPm",
        "Sk9yNEbq84Bmm1ydGsCZWqvAJefnh2C8G1BAU4tfFyrzCXgw",
        "Sk9yNUHUgWR2BUBqqZpCDBw5BsVodrNxoEqhCautqo2MAWpE"
    ]
}
```

### 8. changefileowner

更改文件所有权

#### 参数定义
file_hash: 文件hash
new_owner: 文件所有权新拥有者地址
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "changefileowner",
    "params": ["Sk9yPZdThcHikj1L1sQmxgXAJap9x24vMVJUdG2cky4KEpAe", "ATa3TJYs4vU4EJWiFjUpxcQZjZkWs813aj"],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```

### 9. getfilereadpledge

查询下载文件在合约中的质押情况

#### 参数定义
file_hash: 文件hash
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "getfilereadpledge",
    "params": ["Sk9yPZdThcHikj1L1sQmxgXAJap9x24vMVJUdG2cky4KEpAe"],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": {
        "FileHash": "Sk9yPZdThcHikj1L1sQmxgXAJap9x24vMVJUdG2cky4KEpAe",
        "Downloader": "ALJwq2WYwL26E55dWJs66cAF1E79cDpXeN",
        "BlockHeight": 56025,
        "ExpireHeight": 56136,
        "RestMoney": 145408,
        "ReadPlans": [
            {
                "NodeAddr": "AZxSPsXBnNrWdMyrhTG6CqTxFQgZoiN2Xd",
                "MaxReadBlockNum": 81,
                "HaveReadBlockNum": 40
            },
            {
                "NodeAddr": "AJeuPaxfvrzJjTdpLZXpVgBtdQcHVaNM8f",
                "MaxReadBlockNum": 81,
                "HaveReadBlockNum": 41
            }
        ]
    }
}
```



### 10. cancelfilereadpledge

从下载文件合约质押中提款

#### 参数定义
file_hash: 文件hash
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "cancelfilereadpledge",
    "params": ["Sk9yPZdThcHikj1L1sQmxgXAJap9x24vMVJUdG2cky4KEpAe"],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```

### 11. getfilepdpinfolist

查询文件的pdp证明记录信息

#### 参数定义
file_hash: 文件hash
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "getfilepdpinfolist",
    "params": ["Sk9yPZdThcHikj1L1sQmxgXAJap9x24vMVJUdG2cky4KEpAe"],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": [
        {
            "NodeAddr": "AJeuPaxfvrzJjTdpLZXpVgBtdQcHVaNM8f",
            "FileHash": "Sk9yJBSzGRwEdcuWiECz6hTNMSjwbF7Zq2tbi3TTubuYEBPm",
            "FileOwner": "ALJwq2WYwL26E55dWJs66cAF1E79cDpXeN",
            "PdpCount": 29,
            "LastPdpTime": "2019-12-12 08:06:18 +0800 CST",
            "NextHeight": 52504,
            "SettleFlag": false
        },
        {
            "NodeAddr": "AZxSPsXBnNrWdMyrhTG6CqTxFQgZoiN2Xd",
            "FileHash": "Sk9yJBSzGRwEdcuWiECz6hTNMSjwbF7Zq2tbi3TTubuYEBPm",
            "FileOwner": "ALJwq2WYwL26E55dWJs66cAF1E79cDpXeN",
            "PdpCount": 29,
            "LastPdpTime": "2019-12-12 08:46:18 +0800 CST",
            "NextHeight": 52506,
            "SettleFlag": false
        }
    ]
}
```

### 12. getspaceinfo

获取用户空间信息

#### 参数定义

#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "getspaceinfo",
    "params": [],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": {
        "SpaceOwner": "ALJwq2WYwL26E55dWJs66cAF1E79cDpXeN",
        "Volume": "10 MB",
        "RestVol": "10 MB",
        "CopyNumber": 1,
        "PdpInterval": 14400,
        "PayAmount": "1.0720256 ONG",
        "RestAmount": "1.0720256 ONG",
        "TimeStart": "2019-12-16 14:06:37 +0800 CST",
        "TimeExpired": "2021-12-12 14:20:53 +0800 CST",
        "ValidFlag": true
    }
}
```

### 13. createspace

创建用户空间

#### 参数定义
volume: 空间大小，单位KB，example 10GB=10485760,
pdp_interval: Pdp证明提交间隔，建议为4 * 60 *60 即4小时，如果网络内所有存储节点的MinPdpInterval都小于此值，测无法找到可用服务器可能导致创建空间失败。
copy_num: 空间文件备份数量
time_expired: 过期unix时间戳
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "createspace",
    "params": [10485760, 3, 1607762042],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": {
        "SpaceOwner": "ALJwq2WYwL26E55dWJs66cAF1E79cDpXeN",
        "Volume": "10 MB",
        "RestVol": "10 MB",
        "CopyNumber": 1,
        "PdpInterval": 14400,
        "PayAmount": "1.0720256 ONG",
        "RestAmount": "1.0720256 ONG",
        "TimeStart": "2019-12-16 14:06:37 +0800 CST",
        "TimeExpired": "2021-12-12 14:20:53 +0800 CST",
        "ValidFlag": true
    }
}
```

### 14. deletespace

删除用户空间

#### 参数定义

#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "deletespace",
    "params": [],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```

### 15. updatespace

更新用户空间

#### 参数定义
volume: 空间大小，单位KB，example 10GB=10485760,
time_expired: 过期unix时间戳
#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "updatespace",
    "params": [10485760, 1607762042],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": null
}
```

### 16. getfsnodeslist

获取存储节点信息列表

#### 参数定义

limit: 返回记录最大条数

#### Example

Request:

```
{
    "jsonrpc": "2.0",
    "method": "getfsnodeslist",
    "params": [50],
    "id": "1"
}
```

Response:

```
{
    "desc":"SUCCESS",
    "error":0,
    "jsonrpc": "2.0",
    "id": "1",
    "result": [
        {
            "Pledge": 9765625,
            "Profit": 38694400,
            "Volume": "9.3 GB",
            "RestVol": "8.8 GB",
            "ServiceTime": "2019-12-30 08:00:00 +0800 CST",
            "MinPdpInterval": 14400,
            "NodeAddr": "AJeuPaxfvrzJjTdpLZXpVgBtdQcHVaNM8f",
            "NodeNetAddr": "127.0.0.1:30335"
        },
        {
            "Pledge": 10485760,
            "Profit": 32311552,
            "Volume": "10 GB",
            "RestVol": "9.6 GB",
            "ServiceTime": "2019-12-30 08:00:00 +0800 CST",
            "MinPdpInterval": 14400,
            "NodeAddr": "AZxSPsXBnNrWdMyrhTG6CqTxFQgZoiN2Xd",
            "NodeNetAddr": "127.0.0.1:30445"
        }
    ]
}
```

### 错误代码

|错误码|内容|含义|
|---|---|---|
0|SUCCESS               |成功
41001|SESSION_EXPIRED   |无效或超时的会话
41002|SERVICE_CEILING   |达到服务上限
41003|ILLEGAL_DATAFORMAT|不合法的数据格式
41004|INVALID_VERSION   |无效的版本号
42001|INVALID_METHOD        |无效的方法
42002|INVALID_PARAMS        |无效的参数
42003|INVALID_PARAMS_LENGTH |参数长度不正确
43001|INVALID_CONFIG_TYPE           |配置文件类型不正确
43002|INVALID_FILEHASH_TYPE         |文件类型错误
43003|INVALID_UPLOAD_OPTION_TYPE    |上传参数错误
43004|INVALID_DOWNLOAD_OPTION_TYPE  |下载参数错误
43005|INVALID_FILE_URL_TYPE         |文件url类型错误
43006|INVALID_FILEHASHES_TYPE       |文件Hash列表类型错误
43007|INVALID_ADD_TIME_TYPE         |新增时间类型错误
43008|INVALID_OWNER_TYPE            |所有权拥有者类型错误
43009|INVALID_LIMIT_TYPE            |最大限制类型错误
43010|INVALID_VOLUME_TYPE           |容量类型错误
43011|INVALID_COPY_NUM_TYPE         |文件备份数量类型错误
43012|INVALID_TIME_EXPIRED_TYPE     |过期时间类型错误
44001|INTERNAL_ERROR        |内部错误
44002|INVOKE_CONTRACT_ERROR |智能合约执行错误
45001|SDK_NOT_STARTED       |sdk没有初始化
45002|SDK_ALREADY_STARTED   |sdk已经完成初始化
