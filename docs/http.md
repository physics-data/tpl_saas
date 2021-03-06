# HTTP/1.1 协议子集

HTTP 是超文本传输协议。下面将会介绍一个 HTTP/1.1 协议的子集，可以满足本题的需求。

HTTP 协议的一次交互包括：

- 客户端向服务器传输**请求** (Request)
- 服务器对每个请求进行**回应** (Response)

**注意**：所有 HTTP 传输中的换行符都是 `CRLF \r\n`，和 Bash 默认的换行符 (`LF \n`) 不一致，在按行读入的时候可能会读出来一个 `\r` 小尾巴，打印时也需要在最后附加一个 `\r`，请注意处理。

## 请求

请求的格式为

```
[方法] [资源] HTTP/1.1
[请求头1]: [值1]
[请求头2]: [值2]
(空行)
[请求体]
```

**方法** (Method) 代表客户端请求所要做的操作，比如：

- `GET`: 请求服务器下发一个资源
- `POST`: 向服务器传输一些数据，然后获得回应

**资源** 指定操作对应的资源。比如在浏览器中访问 `http://jia.je/index.html` 中，资源将会是 `/index.html`

**请求头** (Request Header) 是一系列键值对，表示请求的元信息，比如：
- `Host`: 请求的时候写在网址里的主机名 (https://baidu.com/abcdefg 中的 baidu.com)
- `Content-Length`: 在 POST 中的请求体的长度（按字节）

**请求体** 在请求头后一个空行后传输，是其他客户端需要向服务器传输的数据，长度由 `Content-Length` 请求头指定。

**注意**: GET、HEAD 等方法的请求不允许带有回应体，因此你的服务器在收到这些方法的请求时，可能不会存在 `Content-Type` 请求头。但是请求头结束后的空行依旧存在。因此请先检查方法，再处理请求头。

### 示例

```
GET /api?content=test HTTP/1.1
Host: localhost:1080

```

```
POST /api HTTP/1.1
Host: localhost:1080
Content-Length: 14
Content-Type: text/plain

POST BODY HERE
```

## 回应

回应的格式为
```
HTTP/1.1 [回应状态码] [状态码的描述]
[回应头1]: [值1]
[回应头2]: [值2]
(空行)
[回应体]
```

回应状态码和对应的描述表示请求成功与否、发生了什么错误。一些例子是：

- `200 OK`: 请求成功
- `400 Bad Request`: 请求格式有误（缺少参数等）
- `404 Not Found`: 资源没有找到
- `405 Method Not Allowed`: 对于这个资源，请求给出的方法不适用

对应每个情况你需要给出的回应在 README 中有详述。

在失败的情况下只需要传达状态即可，但是如果请求成功，就需要传输更多数据，这个时候需要传输回应体和相关的回应头元数据。回应头和回应体格式和请求一致。关键的回应头包括

- `Content-Type`: 返回的数据类型。如果是文本，可以使用 `text/plain`
- `Content-Length`: 回应体的长度（按字节）

例如如果你要传输 `abcdefg` 字符串，请设置如下回应头：

- `Content-Type`: `text/plain`，表示传输的内容是纯文本
- `Content-Length`: `7`，表示传输的回应体共7字节。

## 回应示例

```
HTTP/1.1 404 Not Found

```

```
HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 18

RESPONSE BODY HERE
```
