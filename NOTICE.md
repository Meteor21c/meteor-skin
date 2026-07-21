# Attribution, licensing, and legal notice

Last reviewed: 2026-07-21

This notice records the provenance and licensing boundaries of **Meteor
Skin**, published at <https://github.com/Meteor21c/meteor-skin>. It is provided
for transparency and is not legal advice.

## 1. Upstream project

This repository is a derivative fork of:

- **Project:** Codex AutoSkin
- **Upstream:** <https://github.com/Finderchangchang/codex-autoskin>
- **Upstream revision used as the base:**
  `25edb4d095684796ded92f1fc2ed6af50a64f0dc`
- **Original copyright notice:** Copyright (c) 2026 Vikicc
- **Upstream license:** MIT License; the original text and copyright notice are
  retained unchanged in [LICENSE](LICENSE).

The upstream Git history is preserved in this fork. It is the authoritative
record for authorship of the base project. Upstream macOS support also credits
GitHub contributor [@keyuchen21](https://github.com/keyuchen21).

## 2. Modifications in this fork

Meteor Skin is maintained by
[@Meteor21c](https://github.com/Meteor21c). Version 2.3.0 adds or revises,
among other things:

- adaptive light/dark theme schema and semantic surface tokens;
- settings, dialog, popover, contrast, glass, and layout coverage;
- stable Windows and macOS runtimes and safe activation entry points;
- a watcher policy that never closes or restarts Codex without user consent;
- non-destructive runtime, theme, and Skill archival;
- portable macOS/Windows packages, checksums, and package verification;
- installation, runtime, distribution, QA, and theme-authoring guidance.

To the extent that copyright subsists in these modifications and is owned by
the maintainer, the modifications are offered under the same MIT License. No
statement here removes or replaces any upstream copyright or contributor
credit.

## 3. AI-assisted development disclosure

Some design, implementation, documentation, debugging, and validation work in
this fork was performed with assistance from OpenAI Codex. The human
maintainer selected the requirements, reviewed and integrated changes, and is
responsible for publishing this fork. This disclosure is informational; it
does not imply authorship, sponsorship, certification, or endorsement by
OpenAI.

## 4. Scope of the software license

The MIT License applies to the software and documentation in this repository
only to the extent the relevant copyright holder has authority to license
them. It does **not** grant rights to:

- OpenAI, Codex, ChatGPT, or other third-party names, logos, product designs,
  or trademarks;
- artwork, photographs, characters, likenesses, fonts, or other material
  supplied by users or third parties without an express compatible license;
- private themes stored under `themes-private/`.

`themes-private/` is intentionally excluded from this public repository. In
particular, the maintainer's private character-based theme artwork is not part
of this publication and is not offered under the MIT License. Users must own
or obtain all rights needed for any image they use or redistribute.

The bundled public demo themes were inherited from upstream. Any upstream
asset-specific notice remains controlling. Do not assume that a software
license transfers third-party trademark, character, publicity, or likeness
rights.

## 5. OpenAI and product-mark disclaimer

This is an independent, unofficial community project. It is not affiliated
with, sponsored by, certified by, or endorsed by OpenAI. “OpenAI,” “Codex,”
“ChatGPT,” and related marks are owned by their respective rights holders and
are used only to identify compatibility or the target product.

Use of OpenAI marks must follow the current
[OpenAI brand guidelines](https://openai.com/brand/). Do not use this project
or its presentation in a way that implies an official OpenAI product or
partnership.

## 6. Technical and user-content boundaries

Meteor Skin uses a loopback Chromium DevTools Protocol connection to inject a
reversible renderer layer. It does not replace, patch, redistribute, re-sign,
or claim ownership of the official Codex/ChatGPT application or `app.asar`.
Compatibility can change when the official application changes.

Legacy internal identifiers such as `dream-*`, `CodexDreamSkin`, and
`com.codex-autoskin.watcher` are retained only for safe migration and backward
compatibility. They do not identify the current project name or alter upstream
attribution.

Users and downstream distributors are responsible for:

- verifying that they have permission to use and distribute theme assets;
- preserving this notice, the MIT license, and upstream attribution when
  redistributing substantial portions;
- complying with applicable law, platform terms, and current brand rules;
- reviewing scripts before running them in their own environment.

## 7. Warranty

The project is provided without warranty, as stated in the MIT License. This
notice does not create additional warranties, indemnities, or representations.

---

# 归属、许可与法律声明

最近审阅日期：2026-07-21

Meteor Skin 发布于 <https://github.com/Meteor21c/meteor-skin>，本公开仓库派生自
[Finderchangchang/codex-autoskin](https://github.com/Finderchangchang/codex-autoskin)，
基础版本为提交
`25edb4d095684796ded92f1fc2ed6af50a64f0dc`。原始版权声明为
“Copyright (c) 2026 Vikicc”，原 MIT 许可证及署名已在
[LICENSE](LICENSE) 中完整保留；上游 Git 历史是基础内容作者归属的权威记录，
macOS 上游贡献同时保留对 [@keyuchen21](https://github.com/keyuchen21) 的致谢。

Meteor Skin 由 [@Meteor21c](https://github.com/Meteor21c) 维护。2.3.0
版本包含自适应明暗主题、原生组件语义配色、稳定运行时、安全激活、非破坏性归档、
跨平台分发包与校验器等修改。在相关修改依法构成著作权且权利属于维护者的范围内，
这些修改同样按 MIT 许可证提供；这不会删除、替代或弱化任何原作者及贡献者署名。

部分设计、代码、文档、调试和验证工作由 OpenAI Codex 辅助完成。需求选择、审阅、
整合和公开发布由人类维护者负责。本说明不代表 OpenAI 对本项目存在作者身份、合作、
认证、赞助或背书关系。

MIT 许可证只覆盖相应权利人有权许可的软件与文档，不授予 OpenAI、Codex、ChatGPT
等第三方商标、产品设计、人物形象、角色、美术作品、照片、字体或用户素材的权利。
`themes-private/` 已从公开仓库排除；维护者的私人角色主题图片不属于本次公开内容，
也不按 MIT 许可证授权。用户必须自行确保拥有主题素材的使用和再分发权利。

本项目是独立、非官方的社区项目，与 OpenAI 不存在隶属、合作、认证或背书关系。
相关名称仅用于说明兼容对象，使用时应遵守最新的
[OpenAI 品牌指南](https://openai.com/brand/)。

Meteor Skin 仅通过本机回环 CDP 注入可恢复的渲染层，不替换、修改、再签名或分发官方
Codex/ChatGPT 应用及 `app.asar`。项目按 MIT 许可证“现状”提供，不作额外保证。
本声明用于透明披露，不构成法律意见。

`dream-*`、`CodexDreamSkin`、`com.codex-autoskin.watcher` 等旧内部标识仅为迁移和
向后兼容而保留，不代表当前项目名称，也不会改变任何上游署名。
