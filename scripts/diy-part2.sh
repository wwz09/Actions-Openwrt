#!/bin/bash
# OpenWrt DIY脚本 Part 2
# 作者: 李杰
# 功能: 在更新feeds之后执行的自定义操作
# 执行时机: feeds更新和安装完成后

echo "============================================"
echo "开始执行 DIY Part 2 脚本"
echo "当前目录: $(pwd)"
echo "============================================"

# ==================== 修改默认主题设置 ====================
echo "修改默认主题..."
# 修改默认主题为Argon
if [ -f "feeds/luci/modules/luci-base/root/etc/config/luci" ]; then
    sed -i 's/Bootstrap/Argon/g' feeds/luci/modules/luci-base/root/etc/config/luci
    echo "✓ 默认主题修改为Argon"
fi

# ==================== 修改默认语言为中文 ====================
echo "设置默认语言为中文..."
if [ -f "feeds/luci/modules/luci-base/root/etc/config/luci" ]; then
    sed -i 's/en/zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci
    echo "✓ 默认语言设置为中文"
fi

# ==================== 修改默认时区 ====================
echo "修改默认时区..."
if [ -f "package/base-files/files/etc/config/system" ]; then
    sed -i 's/UTC/CST-8/g' package/base-files/files/etc/config/system
    sed -i 's/"UTC"/"CST-8"/g' package/base-files/files/etc/config/system
    echo "✓ 时区修改为CST-8"
fi

# ==================== 修改默认主机名 ====================
echo "修改默认主机名..."
if [ -f "package/base-files/files/etc/config/system" ]; then
    sed -i 's/OpenWrt/OpenWrt-AutoBuild/g' package/base-files/files/etc/config/system
    echo "✓ 主机名修改为OpenWrt-AutoBuild"
fi

# ==================== 修改默认WiFi设置 ====================
echo "配置默认WiFi..."
# 创建默认WiFi配置
mkdir -p package/base-files/files/etc/config
cat > package/base-files/files/etc/config/wireless << 'EOF'
config wifi-device 'radio0'
    option type 'mac80211'
    option path 'platform/soc/c000000.wifi'
    option channel 'auto'
    option band '2g'
    option htmode 'HE40'
    option country 'CN'
    option disabled '0'

config wifi-iface 'default_radio0'
    option device 'radio0'
    option network 'lan'
    option mode 'ap'
    option ssid 'OpenWrt-2.4G'
    option encryption 'psk2'
    option key '12345678'

config wifi-device 'radio1'
    option type 'mac80211'
    option path 'platform/soc/c000000.wifi+1'
    option channel 'auto'
    option band '5g'
    option htmode 'HE80'
    option country 'CN'
    option disabled '0'

config wifi-iface 'default_radio1'
    option device 'radio1'
    option network 'lan'
    option mode 'ap'
    option ssid 'OpenWrt-5G'
    option encryption 'psk2'
    option key '12345678'
EOF
echo "✓ WiFi配置完成"

# ==================== 修改网络配置 ====================
echo "修改网络配置..."
if [ -f "package/base-files/files/etc/config/network" ]; then
    # 修改LAN口IP
    sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/etc/config/network
    echo "✓ 网络配置修改完成"
fi

# ==================== 添加自定义启动脚本 ====================
echo "添加自定义启动脚本..."
mkdir -p package/base-files/files/etc/rc.local
cat > package/base-files/files/etc/rc.local << 'EOF'
# 自定义启动脚本
# 作者: 李杰

# 设置CPU性能模式
echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null

# 启用BBR拥塞控制
echo net.core.default_qdisc=fq > /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
sysctl -p

exit 0
EOF
chmod +x package/base-files/files/etc/rc.local
echo "✓ 启动脚本添加完成"

# ==================== 修改banner信息 ====================
echo "修改banner信息..."
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/banner << 'EOF'
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__|  OpenWrt AutoBuild by 李杰
 -----------------------------------------------------
  固件版本: OpenWrt AutoBuild
  编译时间: $(date '+%Y-%m-%d %H:%M:%S')
  源码仓库: coolsnowwolf/lede
  插件仓库: wwz09/QCA-Package
 -----------------------------------------------------
EOF
echo "✓ Banner修改完成"

# ==================== 添加motd信息 ====================
echo "添加motd信息..."
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/motd << 'EOF'

欢迎使用 OpenWrt AutoBuild 固件!

系统信息:
  - 固件版本: OpenWrt AutoBuild
  - 默认IP: 192.168.1.1
  - 默认密码: password
  - 默认WiFi: OpenWrt-2.4G / OpenWrt-5G
  - WiFi密码: 12345678

常用命令:
  - 查看系统信息: cat /etc/os-release
  - 查看网络状态: ifconfig
  - 查看无线状态: iwinfo
  - 重启系统: reboot
  - 重置配置: firstboot

技术支持:
  - 源码: https://github.com/coolsnowwolf/lede
  - 插件: https://github.com/kenzok8/openwrt-packages

EOF
echo "✓ motd添加完成"

# ==================== 修改opkg软件源 ====================
echo "配置opkg软件源..."
mkdir -p package/base-files/files/etc/opkg
cat > package/base-files/files/etc/opkg/distfeeds.conf << 'EOF'
src/gz openwrt_core https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/22.03.5/targets/ipq60xx/generic/packages
src/gz openwrt_base https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/22.03.5/packages/aarch64_cortex-a53/base
src/gz openwrt_luci https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/22.03.5/packages/aarch64_cortex-a53/luci
src/gz openwrt_packages https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/22.03.5/packages/aarch64_cortex-a53/packages
src/gz openwrt_routing https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/22.03.5/packages/aarch64_cortex-a53/routing
src/gz openwrt_telephony https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/22.03.5/packages/aarch64_cortex-a53/telephony
EOF
echo "✓ opkg软件源配置完成"

# ==================== 添加定时任务 ====================
echo "添加定时任务..."
mkdir -p package/base-files/files/etc/crontabs
cat > package/base-files/files/etc/crontabs/root << 'EOF'
# 每天凌晨3点自动更新软件包列表
0 3 * * * opkg update

# 每周日凌晨4点清理日志
0 4 * * 0 logread -C

# 每天凌晨5点重启网络服务
0 5 * * * /etc/init.d/network restart
EOF
echo "✓ 定时任务添加完成"

# ==================== 优化系统参数 ====================
echo "优化系统参数..."
mkdir -p package/base-files/files/etc/sysctl.d
cat > package/base-files/files/etc/sysctl.d/99-custom.conf << 'EOF'
# 网络优化
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# 文件描述符限制
fs.file-max = 65535

# 内存优化
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
EOF
echo "✓ 系统参数优化完成"

# ==================== 添加自定义防火墙规则 ====================
echo "添加自定义防火墙规则..."
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/firewall.user << 'EOF'
# 自定义防火墙规则
# 作者: 李杰

# 允许ICMP ping
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

# 允许本地回环
iptables -A INPUT -i lo -j ACCEPT

# 允许已建立的连接
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 允许SSH访问
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 允许HTTP/HTTPS访问
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
EOF
echo "✓ 防火墙规则添加完成"

# ==================== 修复 luci-app-ota 依赖问题 ====================
echo "修复 luci-app-ota 依赖问题..."
echo "当前目录: $(pwd)"
echo "检查 package/feeds/qca_package 目录..."
if [ -d "package/feeds/qca_package" ]; then
    echo "qca_package 目录存在"
    ls -la package/feeds/qca_package/
    
    if [ -d "package/feeds/qca_package/luci-app-ota" ]; then
        echo "移除有依赖问题的 luci-app-ota 包..."
        rm -rf package/feeds/qca_package/luci-app-ota
        echo "✓ luci-app-ota 包已移除"
    else
        echo "luci-app-ota 包不存在，跳过移除"
    fi
else
    echo "qca_package 目录不存在，跳过移除"
fi

# ==================== 修复 luci-app-eqos 编译问题 ====================
echo "修复 luci-app-eqos 编译问题..."
echo "当前目录: $(pwd)"
echo "检查 package/feeds/kenzok8_packages 目录..."
if [ -d "package/feeds/kenzok8_packages" ]; then
    echo "kenzok8_packages 目录存在"
    
    if [ -d "package/feeds/kenzok8_packages/luci-app-eqos" ]; then
        echo "移除有编译问题的 luci-app-eqos 包..."
        rm -rf package/feeds/kenzok8_packages/luci-app-eqos
        echo "✓ luci-app-eqos 包已移除"
    else
        echo "luci-app-eqos 包不存在，跳过移除"
    fi
else
    echo "kenzok8_packages 目录不存在，跳过移除"
fi

# ==================== 修复 ksmbd 内核模块编译问题 ====================
echo "修复 ksmbd 内核模块编译问题..."
echo "当前目录: $(pwd)"

# 检查ksmbd目录
if [ -d "package/kernel/ksmbd" ]; then
    echo "ksmbd 目录存在"
    
    # 检查补丁目录是否存在
    if [ -d "$(dirname "$0")/../patches" ]; then
        echo "补丁目录存在，应用内核兼容性补丁..."
        
        # 应用补丁
        if [ -f "$(dirname "$0")/apply-patches.sh" ]; then
            bash "$(dirname "$0")/apply-patches.sh"
            if [ $? -eq 0 ]; then
                echo "✓ 所有补丁应用成功"
            else
                echo "✗ 补丁应用失败，回退到移除方案"
                rm -rf package/kernel/ksmbd
                echo "✓ ksmbd 包已移除"
            fi
        else
            echo "补丁脚本不存在，使用备选方案..."
            # 直接修改smb1pdu.c文件
            if [ -f "package/kernel/ksmbd/src/smb1pdu.c" ]; then
                echo "修改 smb1pdu.c 文件以修复内核兼容性问题..."
                
                # 修复ksmbd_vfs_fp_rename函数调用
                sed -i 's/rc = ksmbd_vfs_fp_rename(work, fp, newname);/#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 12, 0)\n\trc = ksmbd_vfs_rename(work, fp->f_path.dentry->d_inode, oldname, newname);\n#else\n\trc = ksmbd_vfs_fp_rename(work, fp, newname);\n#endif/' package/kernel/ksmbd/src/smb1pdu.c
                
                # 修复file_lock结构成员访问
                sed -i 's/flock->fl_type = F_RDLCK;/#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 12, 0)\n\t\t\t\t\tflock->l_type = F_RDLCK;\n#else\n\t\t\t\t\tflock->fl_type = F_RDLCK;\n#endif/' package/kernel/ksmbd/src/smb1pdu.c
                sed -i 's/flock->fl_type = F_WRLCK;/#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 12, 0)\n\t\t\t\t\tflock->l_type = F_WRLCK;\n#else\n\t\t\t\t\tflock->fl_type = F_WRLCK;\n\t\t\t\t\tflock->fl_flags |= FL_SLEEP;\n#endif/' package/kernel/ksmbd/src/smb1pdu.c
                sed -i 's/flock->fl_flags |= FL_SLEEP;//' package/kernel/ksmbd/src/smb1pdu.c
                sed -i 's/flock->fl_pid = current->tgid;//' package/kernel/ksmbd/src/smb1pdu.c
                sed -i 's/cmp_lock->fl->fl_file/cmp_lock->fl->l_file/g' package/kernel/ksmbd/src/smb1pdu.c
                sed -i 's/smb_lock->fl->fl_file/smb_lock->fl->l_file/g' package/kernel/ksmbd/src/smb1pdu.c
                sed -i 's/flock->fl_file/flock->l_file/g' package/kernel/ksmbd/src/smb1pdu.c
                
                echo "✓ ksmbd 内核兼容性修复完成"
            else
                echo "smb1pdu.c 文件不存在，移除ksmbd包"
                rm -rf package/kernel/ksmbd
                echo "✓ ksmbd 包已移除"
            fi
        fi
    else
        echo "补丁目录不存在，移除ksmbd包"
        rm -rf package/kernel/ksmbd
        echo "✓ ksmbd 包已移除"
    fi
else
    echo "ksmbd 包不存在，跳过修复"
fi

echo "============================================"
echo "DIY Part 2 脚本执行完成"
echo "==========================================="
