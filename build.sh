#!/usr/bin/env python3

import base64
import hashlib
import re

# 1. 读取官方GFWList
with open("list.txt", "r", encoding="utf-8") as f:
    gfw = f.read()

# 2. 读取你的自定义规则
with open("list.my.txt", "r", encoding="utf-8") as f:
    myrules = [line.strip() for line in f if line.strip() and not line.startswith("!")]

# 3. 找到 General List End 分隔符，插入自定义规则
marker = "!##############General List End#################"
parts = gfw.split(marker)
if len(parts) == 2:
    merged_txt = parts[0] + marker + "\n" + "\n".join(myrules) + "\n" + parts[1]
else:
    # 如果没找到 marker，就简单追加到文件末尾
    merged_txt = gfw.strip() + "\n" + "\n".join(myrules) + "\n"

# 4. 去掉旧的校验和
merged_txt = re.sub(r"! Checksum: .+\n", "", merged_txt)

# 5. 重新计算并插入校验和
# 只用ASCII范围字符算md5
checksum_raw = re.sub(r"[^\x20-\x7E]", "", merged_txt)
md5 = hashlib.md5(checksum_raw.encode("utf-8")).digest()
checksum = base64.b64encode(md5).decode("utf-8")

# 插入校验和到第二行
lines = merged_txt.splitlines()
if lines[0].startswith("[") and not lines[1].startswith("! Checksum:"):
    lines.insert(1, f"! Checksum: {checksum}")
else:
    # 没有头部，直接插在最前面
    lines.insert(0, f"! Checksum: {checksum}")
final_txt = "\n".join(lines) + "\n"

# 6. base64编码
b64_txt = base64.b64encode(final_txt.encode("utf-8")).decode("utf-8")

# 7. 输出
with open("gfwlist.new.txt", "w", encoding="utf-8") as f:
    f.write(b64_txt)

print("合并并生成 base64 完成，输出文件：gfwlist.new.txt")
