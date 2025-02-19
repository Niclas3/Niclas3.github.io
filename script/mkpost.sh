#!/bin/bash

# 获取当前日期
today=$(date +"%Y-%m-%d")

# 提示用户输入文章标题
read -p "Enter post title: " title

# 处理标题，转换为 URL 友好的格式（小写，空格替换为“-”）
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

# 生成文件路径
filename="./${today}-${slug}.md"

# 检查是否已存在相同文件
if [ -f "$filename" ]; then
  echo "Error: File '$filename' already exists!"
  exit 1
fi

# 创建 Markdown 文件并填充 Front Matter
cat <<EOF > "$filename"
---
layout: post
title: "$title"
date: $today
categories: []
tags: []
---

Write your content here...
EOF

echo "✅ New post created: $filename"
