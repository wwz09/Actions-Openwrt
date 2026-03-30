#!/bin/bash
# 应用补丁脚本
# 作者: 李杰
# 功能: 应用ksmbd内核兼容性补丁

PATCH_DIR="$(dirname "$0")/../patches"

# 检查补丁目录
if [ ! -d "$PATCH_DIR" ]; then
    echo "错误: 补丁目录不存在"
    exit 1
 fi

# 检查ksmbd目录
if [ ! -d "package/kernel/ksmbd" ]; then
    echo "错误: ksmbd目录不存在"
    exit 1
 fi

# 应用补丁
echo "应用ksmbd内核兼容性补丁..."
patch -p1 -d package/kernel/ksmbd < "$PATCH_DIR/0001-fix-ksmbd-kernel-compatibility.patch"

if [ $? -eq 0 ]; then
    echo "✓ 补丁应用成功"
else
    echo "✗ 补丁应用失败"
    exit 1
fi

echo "补丁应用完成"
