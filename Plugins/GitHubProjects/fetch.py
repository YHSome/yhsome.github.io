#!/usr/bin/env python3
"""
GitHubProjects 插件 — 从 GitHub API 拉取 YHSome 的公开仓库列表。

用法:
    python OpenBlogger/Plugins/GitHubProjects/fetch.py
"""

import json, urllib.request, sys
from pathlib import Path

# Windows 控制台编码修复
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

API = "https://api.github.com/users/YHSome/repos?per_page=100&sort=updated"
OUT = Path(__file__).resolve().parent / "projects.json"

try:
    req = urllib.request.Request(API, headers={"User-Agent": "OpenBlogger"})
    with urllib.request.urlopen(req) as r:
        raw = json.loads(r.read().decode())
except Exception as e:
    print(f"❌ API 请求失败: {e}")
    sys.exit(1)

if isinstance(raw, dict) and "message" in raw:
    print(f"❌ API 错误: {raw['message']}")
    sys.exit(1)

# 清洗数据，只保留需要的字段
cleaned = []
for r in raw:
    desc = (r.get("description") or "").encode("utf-8", errors="replace").decode("utf-8", errors="replace")
    cleaned.append({
        "name": r["name"],
        "full_name": r["full_name"],
        "description": desc,
        "language": r.get("language") or "",
        "stars": r.get("stargazers_count", 0),
        "forks": r.get("forks_count", 0),
        "has_pages": r.get("has_pages", False),
        "homepage": r.get("homepage") or "",
        "html_url": r["html_url"],
        "updated_at": r.get("updated_at", ""),
        "topics": r.get("topics", []),
    })

OUT.write_text(json.dumps(cleaned, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"✅ {len(cleaned)} 个仓库 → {OUT}")
for r in cleaned:
    pages = "PAGES" if r["has_pages"] else ""
    print(f"   {r['name']:30s} {pages:6s} ⭐{r['stars']}")
