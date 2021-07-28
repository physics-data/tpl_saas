# SHA256 as a Service

## 问题背景

[供应链攻击](http://left-pad.io)是日渐严峻的安全隐患，需要警惕 `coreutils` 维护者在 `sha256sum` 命令中加入 [Rickroll](https://www.youtube.com/watch?v=dQw4w9WgXcQ)，使得新的 Linux 安装无法在不听歌的情况下校验软件包的校验和。

因此，使用安装有旧版本 `coreutils` 的 Linux 提供 SHA256 as a Service 在线服务是当务之急。

## 问题描述

在仓库的根目录中有一个文件 `saas.example.sh`，请将其重命名为 `saas.sh` 并仔细阅读其内容。其中包含有你需要开始着手此问题的信息。后续更改请直接在 `saas.sh` 中进行。

你需要完成一个简单的 HTTP 服务器，监听 1080 端口，提供 HTTP/1.1 协议的一个子集。对于来源的 HTTP 访问，请进行以下回应：

- 对于路径 `/api`：
  - 方法 `GET`：检查是否有 Query 参数 `content`
    - 如果没有，返回状态码 `400 Bad Request`
    - 如果有，计算 `content` 的值的 SHA256。你 **无需** 处理转义字符，在测试中保证请求中所有 Query 参数的名字和值只包含大小写英文字母及数字。
  - 方法 `POST`: 计算 Post 体的 SHA256。你 **无需** 区分 Post 体的不同格式，直接作为字节流处理即可。
  - 其他方法：返回状态码 `405 Method Not Allowed`
- 对于其他任意路径：返回状态码 `404 Not Found`

当完成了 SHA256 的计算之后，请返回状态码 `200 OK`，回应体包含一个小写 16 进制编码的串，共 64 个字符长，表示输入的 SHA256 校验和。

关于你需要了解的 HTTP/1.1 协议子集细节，请见 `docs/http.md`。关于（助教认为）你所需要的命令的说明，请见 `docs/cmd.md`。

## 注意事项

对于非 `200` 的回应，回应体可自由选择，在检查时将被忽略，你只需要保证状态码正确，以及 **回应格式满足协议**。

所有本题没有用到的 HTTP 请求头请忽略，回应头推荐只给出必要的，评测器将会依照 HTTP 1.1 的语意进行解析。

你的 HTTP 服务器应该 **持续运行并接受新请求**。当你在手动测试的时候，可以使用 Ctrl-C 快捷键终止正在执行的脚本。

你 **无需** 实现请求的并发处理。在自动测试中，我们将会 **顺序依次** 发送多个请求，每个请求之间将会间隔至少 1s (一秒钟, one second)。当所有请求都完成后，评测器会使用 `kill -9` 结束服务器。

最后，请注意各种地方的换行符 (`\n` 和 `\r`)

## 样例与评测

本题目评测使用 **随机生成数据** 评测。

你可以使用 `./scripts/judge.sh` 在本地运行评测。发生错误的请求将会被打印出来，如果是 POST 请求，对应的文件将会放置在 `./failed` 目录下。在线评测中你可以从 Artifacts 下载这些文件。

执行 `./scripts/judge_boot.sh` 将会自动启动 `./saas.sh`，进行测试，并且自动关闭服务器。GitHub Actions 使用的是这个测试方法。

此外，你也可以使用 `./scripts/judge_get.sh`, `./scripts/judge_post.sh` 和 `./scripts/judge_misc.sh` 进行单次 GET，POST 及其他随机请求的评测。

本题分数构成为：

- 黑盒：根据子任务是否通过分别给分。当所有测例都达成了一个子任务，那么得到这个子任务的分数。
  - HTTP 服务器正常接受请求，给出回应，没有超时: 40 分
  - HTTP 回应格式正确，给出正确的状态码：20 分
  - SHA256 校验和计算全部正确（如果存在）：20 分
- 白盒：代码风格与 Git 使用 20 分（包括恰当注释、合理命名、提交日志等）。

举例：如果总共进行 100 次测试，其中所有请求都正确返回回应，但是存在一个请求校验和计算错误，那么得到黑盒前两个子任务的分数，黑盒共 60 分。

本题不设置运行空间限制，对控制台输出不做要求。保证需要计算 SHA256 的数据长度不超过 4096 字节，请在请求开始后的 60s 内传回 HTTP 回应。

助教以 deadline 前 GitHub 上最后一次提交为准进行评测。
