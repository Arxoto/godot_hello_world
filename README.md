# Godot Hello World

## 工作流配置

### VSCode

godot-tools 插件配置 `.vscode/setting.json`
```
"godotTools.editorPath.godot4": "C:\\Users\\UserName\\scoop\\apps\\godot\\current\\godot.exe",
"godotTools.lsp.headless": true,
```

> When using Godot >3.6 or >4.2, Headless LSP mode is available.
> In Headless mode, the extension will attempt to launch a windowless instance of the Godot editor to use as its Language Server.

若版本支持，建议始终打开无头 LSP 模式的，他在与 Godot 启动的时候也不会冲突

### Godot

将 VSCode 设为 Godot 默认的脚本编辑器 `Editor Settings > Text Editor > External` （打开高级设置）
```
~/AppData/Local/Programs/Microsoft VS Code/bin/code.cmd
{project} --goto {file}:{line}:{col}
```

让 Godot 无缝重载在 VSCode 中编辑的脚本
```
Editor Settings > Text Editor > Behavior > Files > Auto Reload Scripts on External Change
Editor Settings > Interface > Editor > Save on Focus Loss
Editor Settings > Interface > Editor > Import Resources When Unfocused
```
