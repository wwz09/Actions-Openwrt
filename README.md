# OpenWrt 自动云编译项目

## 项目概述

本项目是一个基于 GitHub Actions 的 OpenWrt 自动云编译工作流，支持多种 IPQ60XX 平台路由器的固件编译。

**作者**: 李杰  
**源码仓库**: [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)  
**插件仓库**: [wwz09/QCA-Package](https://github.com/wwz09/QCA-Package)

## 支持的设备

| 设备名称 | 目标平台 | 配置文件 |
|---------|---------|---------|
| JDC AX1800 | ipq60xx | [configs/jdc-ax1800.config](configs/jdc-ax1800.config) |
| CMCC RAX3000M | mediatek | [configs/cmcc-rax3000.config](configs/cmcc-rax3000.config) |
| Qihoo 360 V6 | ipq60xx | [configs/qihoo-360v6.config](configs/qihoo-360v6.config) |

## 功能特性

### 默认包含功能
- ✅ **WiFi无线功能** - 2.4G/5G双频WiFi支持
- ✅ **常用网络插件** - DDNS、SmartDNS、网络唤醒等
- ✅ **第三方QCA插件包** - 来自QCA-Package的丰富插件
- ✅ **中文界面** - 默认中文语言支持
- ✅ **Argon主题** - 美观的Argon主题界面

### 预装插件列表

#### 网络工具
- `luci-app-adguardhome` - AdGuard Home广告拦截
- `luci-app-aria2` - Aria2下载工具
- `luci-app-ddns` - 动态DNS客户端
- `luci-app-ddns-go` - DDNS-Go动态DNS
- `luci-app-smartdns` - SmartDNS智能DNS
- `luci-app-mosdns` - MOSDNS域名解析

#### 系统工具
- `luci-app-fileassistant` - 文件管理助手
- `luci-app-filebrowser` - 文件浏览器
- `luci-app-filemanager` - 文件管理器
- `luci-app-ramfree` - 内存释放工具
- `luci-app-cpufreq` - CPU频率调节

#### 网络管理
- `luci-app-netspeedtest` - 网络速度测试
- `luci-app-wol` / `luci-app-wolplus` - 网络唤醒
- `luci-app-socat` - Socat网络工具
- `luci-app-eqos` - 网络流量均衡
- `luci-app-guest-wifi` - 访客WiFi
- `luci-app-wrtbwmon` - 带宽监控

#### 控制功能
- `luci-app-control-timewol` - 定时唤醒
- `luci-app-control-webrestriction` - 网页访问限制
- `luci-app-control-weburl` - 网址过滤
- `luci-app-timecontrol` - 时间控制
- `luci-app-poweroff` - 关机功能

#### 主题
- `luci-theme-argon` - Argon主题
- `luci-app-argon-config` - Argon主题配置
- `luci-app-aurora-config` - Aurora主题配置

## 默认配置

### 网络配置
- **默认IP**: `192.168.1.1`
- **默认密码**: `password`
- **主机名**: `OpenWrt-AutoBuild`
- **时区**: `CST-8` (中国标准时间)

### WiFi配置
- **2.4G SSID**: `OpenWrt-2.4G`
- **5G SSID**: `OpenWrt-5G`
- **WiFi密码**: `12345678`
- **加密方式**: WPA2-PSK

### 管理界面
- **主题**: Argon (深色模式)
- **语言**: 简体中文
- **HTTP端口**: 80
- **HTTPS端口**: 443

## 使用方法

### 手动触发编译

1. 进入 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 选择 **Build OpenWrt Firmware** 工作流
4. 点击 **Run workflow** 按钮
5. 选择要编译的设备:
   - `all` - 编译所有设备
   - `jdc-ax1800` - 仅编译JDC AX1800
   - `cmcc-rax3000m` - 仅编译CMCC RAX3000M
   - `qihoo-360v6` - 仅编译Qihoo 360 V6
6. 可选: 启用SSH调试
7. 点击 **Run workflow** 开始编译

### 自动触发

- **定时编译**: 每周日凌晨3点自动编译
- **代码推送**: 当配置文件或工作流文件更新时自动触发

### 下载固件

编译完成后，固件将自动发布到 GitHub Releases 页面:

1. 进入仓库的 **Releases** 页面
2. 找到最新的发布版本
3. 下载对应设备的固件文件

### 固件说明

| 文件类型 | 用途 | 说明 |
|---------|------|------|
| `*factory.bin` | 首次刷机 | 用于从原厂固件刷入OpenWrt |
| `*sysupgrade.bin` | 系统升级 | 用于OpenWrt系统升级 |

## 刷机指南

### 首次刷机 (Factory固件)

1. 下载对应设备的 `*factory.bin` 固件
2. 通过路由器管理界面的固件升级功能上传固件
3. 等待刷机完成，路由器自动重启
4. 访问 `http://192.168.1.1` 进入OpenWrt管理界面

### 系统升级 (Sysupgrade固件)

1. 下载对应设备的 `*sysupgrade.bin` 固件
2. 进入OpenWrt管理界面
3. 系统 → 备份/升级 → 刷写固件
4. 选择下载的固件文件，点击刷写
5. 等待升级完成

### 注意事项

⚠️ **刷机有风险，请谨慎操作**

1. 刷机前请备份重要配置
2. 确保电源稳定，刷机过程中请勿断电
3. 首次刷机建议使用factory固件
4. 系统升级建议使用sysupgrade固件
5. 刷机后首次启动可能需要3-5分钟

## 项目结构

```
.
├── .github/
│   └── workflows/
│       └── build-openwrt.yml    # GitHub Actions工作流
├── configs/
│   ├── jdc-ax1800.config        # JDC AX1800配置
│   ├── cmcc-rax3000.config      # CMCC RAX3000M配置
│   └── qihoo-360v6.config       # Qihoo 360 V6配置
├── scripts/
│   ├── diy-part1.sh             # DIY脚本Part 1 (feeds更新前)
│   └── diy-part2.sh             # DIY脚本Part 2 (feeds更新后)
└── README.md                    # 项目说明文档
```

## 自定义配置

### 修改配置文件

1. 编辑 `configs/` 目录下的设备配置文件
2. 提交更改并推送到GitHub
3. 工作流将自动触发编译

### 添加自定义插件

在 `scripts/diy-part1.sh` 中添加:

```bash
# 添加自定义软件源
echo "src-git custom_package https://github.com/username/repo" >> feeds.conf.default

# 克隆自定义软件包
git clone https://github.com/username/custom-package.git package/custom-package
```

### 修改默认设置

在 `scripts/diy-part2.sh` 中修改:

```bash
# 修改默认IP
sed -i 's/192.168.1.1/你的IP/g' package/base-files/files/etc/config/network

# 修改默认密码
sed -i 's/原密码/新密码/g' package/lean/default-settings/files/zzz-default-settings
```

## 常见问题

### Q: 编译失败怎么办?
A: 
1. 检查配置文件语法是否正确
2. 查看Actions日志获取详细错误信息
3. 尝试启用SSH调试进行手动排查
4. 清理缓存后重新编译

### Q: 如何启用SSH调试?
A: 在手动触发工作流时，将 `ssh` 参数设置为 `true`

### Q: 固件大小超过限制怎么办?
A: 
1. 在配置文件中禁用不必要的插件
2. 启用固件压缩选项
3. 使用外部存储扩展

### Q: WiFi无法正常工作?
A:
1. 确认无线驱动已正确安装
2. 检查无线配置文件
3. 尝试重置无线配置

## 技术参数

### 编译环境
- **运行环境**: Ubuntu 22.04
- **编译器**: GCC (随OpenWrt源码)
- **目标架构**: ARM Cortex-A53 (aarch64)
- **目标平台**: Qualcomm IPQ60XX

### 系统优化
- **TCP拥塞控制**: BBR
- **默认队列规则**: FQ
- **CPU调度器**: Performance模式
- **内存管理**: 优化swappiness参数

## 更新日志

### 2024-XX-XX
- 初始版本发布
- 支持JDC AX1800、CMCC RAX3000、Qihoo 360 V6
- 集成QCA-Package第三方插件

## 贡献指南

欢迎提交Issue和Pull Request来改进本项目。

## 许可证

本项目基于 [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede) 开源项目，遵循原项目的许可证。

## 致谢

- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede) - OpenWrt源码
- [wwz09/QCA-Package](https://github.com/wwz09/QCA-Package) - 第三方插件包
- [jerrykuku/luci-theme-argon](https://github.com/jerrykuku/luci-theme-argon) - Argon主题

## 联系方式

如有问题或建议，请通过GitHub Issues联系。

---

**免责声明**: 本固件仅供学习和研究使用，使用本固件造成的任何损失由使用者自行承担。
