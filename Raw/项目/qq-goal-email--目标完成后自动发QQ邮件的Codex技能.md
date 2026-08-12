time: 2026.8.12
tag:
title: qq-goal-email：让 Codex 干完活主动给你发 QQ 邮件

# 缘起

长任务跑起来之后，最怕的就是人不在电脑前。

改一堆文件、部署上线、跑自动化……这些活儿丢给 Codex 之后，你往往就切去做别的事了。等回来一看，任务十分钟前就结束了，白等。

"能不能让它干完活自己来通知我？"

于是就有了这个 skill：**qq-goal-email**——目标或长任务完成后，自动往你的 QQ 邮箱发一封详细的完成摘要。

# 这是什么

一个 Codex Skill，放在 `~/.codex/skills/` 里就能被 Codex 自动发现。它的工作方式很简单：

> 完成一个目标（goal）、跑完一个耗时长或改动大的任务后，不用你开口，Codex 自动整理一份详细的结构化摘要，通过 QQ 邮箱 SMTP 发到你的邮箱。

# 它能做什么

1. **完成即自动发送**：目标结束后自动触发，不需要手动提醒"记得发邮件"
2. **主动判断该不该发**：改动文件多、耗时长、涉及仓库/部署/自动化，或你可能不在电脑前——这些情况都会自动发；闲聊和小改动不会打扰你
3. **详细的结构化摘要**：目标、时间、执行过程、结果与产出、问题与解决、未完成与风险，一项不落
4. **HTML 渲染**：带样式的 HTML 邮件，同时自动附带纯文本兜底，兼容各种邮件客户端
5. **只依赖 Python 标准库**：smtplib + email，零第三方依赖
6. **支持预览**：`--dry-run` 可以先生成邮件内容看效果，不真的发送

# 使用方式

安装：把 `qq-goal-email` 文件夹复制到 Codex 的 skills 目录。

```bash
# Windows
copy /y qq-goal-email %USERPROFILE%\.codex\skills\

# macOS / Linux
cp -r qq-goal-email ~/.codex/skills/
```

重启 Codex 后，skill 自动生效。

首次配置需要 QQ 邮箱的 SMTP 授权码（不是登录密码）：QQ邮箱 → 设置 → 账户 → 开启 POP3/SMTP 服务 → 生成授权码。

```bash
python qq-goal-email/scripts/send_qq_email.py --save-config \
  --from me@qq.com --auth-code xxxx --to me@qq.com
```

配置保存在 `~/.config/qq-goal-email/config.json`。也可以直接用环境变量：

```bash
export QQ_MAIL_FROM=me@qq.com
export QQ_MAIL_AUTH_CODE=xxxx
export QQ_MAIL_TO=me@qq.com
```

之后只要对 Codex 说一句"完成后发 QQ 邮箱给我"，它就会照做。

# 技术实现

整个 skill 就两个核心部分：

- **SKILL.md**：告诉 Codex 什么时候该主动发邮件、摘要怎么写、HTML 模板长什么样
- **scripts/send_qq_email.py**：发送脚本，基于 `smtplib` + `email`，连 `smtp.qq.com:465`（SSL）

几个设计细节：

**配置优先级。** 命令行参数 > 环境变量 > 配置文件，三层覆盖，灵活不冲突。

**自动签名。** 每封邮件末尾自动附带"本邮件由 Codex 的 qq-goal-email skill 自动发送"，不用手动加。

**权限保护。** 保存授权码时自动把配置文件权限收紧到 600，README 里也明确警告不要把授权码提交到仓库。

**发件人可自定义。** 默认显示名 `Codex`，可以用 `--from-name` 或 `QQ_MAIL_FROM_NAME` 环境变量改。

# 项目链接

- GitHub: [github.com/YHSome/SentMeGoal](https://github.com/YHSome/SentMeGoal)
