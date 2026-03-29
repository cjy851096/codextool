# Clipboard Snip Helper

一个基于 AutoHotkey v2 的 Windows 小工具，提供以下能力：

- `Win + Shift + S` 截图后自动保存到自定义目录，并把图片路径写入剪贴板（可直接 `Ctrl + V` 粘贴路径）。
- `Ctrl + C` 复制文本后自动移除回车换行，`Ctrl + V` 粘贴为单行文本。

## 功能说明

### 1) 截图自动保存并复制路径

按下 `Win + Shift + S` 后：

1. 调起系统截图（Snipping Tool）。
2. 截图完成后，自动将图片保存为 `png`。
3. 将保存后的完整文件路径写入剪贴板。

默认文件名格式：

`snip_yyyyMMdd_HHmmss_mmm.png`

示例：

`D:\Snips\snip_20260329_225248_546.png`

### 2) 复制文本自动去换行

按下 `Ctrl + C` 复制纯文本后，脚本会自动删除：

- `CRLF` (`\r\n`)
- `LF` (`\n`)
- `CR` (`\r`)

这样在 `Ctrl + V` 时会得到单行文本。  
文件复制、图片复制等非纯文本内容不会被修改。

## 环境要求

- Windows 10/11
- AutoHotkey v2（运行 `.ahk` 时需要）

说明：

- 你也可以直接运行仓库内的 `clipboard_snip_helper.exe`（无需单独安装 AHK）。

## 快速开始

1. 打开 [`clipboard_snip_helper.ahk`](/e:/code1/codextools/clipboard_snip_helper.ahk)。
2. 修改配置项 `SaveDir` 为你的截图保存目录。
3. 双击运行脚本（或运行 `clipboard_snip_helper.exe`）。
4. 使用以下热键测试：
   - `Win + Shift + S`：截图并保存，剪贴板变为图片路径。
   - `Ctrl + C`：复制文本并去掉换行。
   - `Win + Shift + Alt + S`：显示“脚本正在运行”（用于自检脚本是否生效）。

## 配置项

在脚本顶部可以修改：

- `SaveDir`：截图保存目录（默认 `D:\Snips`）
- `ImageExt`：保存格式（当前实现固定保存为 `png`，建议保持 `png`）

## 常见问题

### 热键不生效

- 确认使用的是 AutoHotkey v2，而不是 v1。
- 查看系统托盘中是否有 AHK 图标。
- 尝试重新启动脚本。

### 截图没有保存成功

- 确认 `SaveDir` 目录可写。
- 在管理员权限程序中截图时，建议将脚本也“以管理员身份运行”。
- 截图取消或超时时不会保存文件。

### `Ctrl + C` 复制后内容异常

- 该功能仅对“纯文本”生效；文件、图片、富文本场景会跳过处理。

## 文件结构

- [`clipboard_snip_helper.ahk`](/e:/code1/codextools/clipboard_snip_helper.ahk)：脚本源码
- `clipboard_snip_helper.exe`：可直接运行版本

## 许可证

本项目采用 MIT 许可证，详见 [`LICENSE`](/e:/code1/codextools/LICENSE)。
