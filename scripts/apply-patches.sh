#!/bin/bash
# 应用补丁脚本
# 作者: 李杰
# 功能: 应用各种编译修复补丁

PATCH_DIR="$(dirname "$0")/../patches"

# 检查补丁目录
if [ ! -d "$PATCH_DIR" ]; then
    echo "错误: 补丁目录不存在"
    exit 1
 fi

# 应用ksmbd内核兼容性补丁
if [ -d "package/kernel/ksmbd" ]; then
    echo "应用ksmbd内核兼容性补丁..."
    patch -p1 -d package/kernel/ksmbd < "$PATCH_DIR/0001-fix-ksmbd-kernel-compatibility.patch"
    
    if [ $? -eq 0 ]; then
        echo "✓ ksmbd 补丁应用成功"
    else
        echo "✗ ksmbd 补丁应用失败"
        exit 1
    fi
else
    echo "ksmbd目录不存在，跳过补丁应用"
fi

# 应用libc.so修复补丁
if [ -d "package/network/services/samba4" ]; then
    echo "应用libc.so修复补丁..."
    patch -p1 -d package/network/services/samba4 < "$PATCH_DIR/0002-fix-libc-so-not-found.patch"
    
    if [ $? -eq 0 ]; then
        echo "✓ libc.so 补丁应用成功"
    else
        echo "✗ libc.so 补丁应用失败"
        exit 1
    fi
else
    echo "samba4目录不存在，跳过补丁应用"
fi

echo "所有补丁应用完成"
