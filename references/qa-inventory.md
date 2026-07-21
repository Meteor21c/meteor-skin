# QA inventory

## User-visible claims

1. Every theme folder scanned from `themes/` and `themes-private/` is available at runtime; `node scripts/injector.mjs --themes` lists them with the resolved default theme/layout.
2. Every theme supports two persisted home layouts: top banner and fullscreen canvas.
3. The real Codex suggestion buttons occupy the visual middle and the real project selector/composer stays at the bottom in both layouts.
4. Normal tasks use a separate, faint, subject-focused chat-art layer with a light wash; message text remains dominant.
5. The sidebar is warm glass rather than merely changing the accent color.
6. All real Codex controls remain interactive; the skin is not a screenshot overlay and has no on-screen switch UI of its own (switching is programmatic via `scripts/set-theme.mjs`).
7. The skin survives route changes and renderer reloads while the injector daemon runs.
8. The official Store package and `app.asar` remain unchanged.
9. Restore removes the injected DOM/CSS and install/restore can be repeated.
10. Adaptive themes follow Codex Settings → Appearance without reapplying the Meteor Skin theme or restarting Codex.
11. Installers create a stable runtime and a reusable activation entry; an existing unskinned Codex is never restarted without approval.

## Functional checks

- Home feature card: click one card and confirm the real composer is populated or the normal action occurs.
- Project selector: click the real project chip under the "选择项目" label and confirm the native project menu opens.
- Sidebar: open a real task, then return to New Task.
- Composer: type text, verify caret/readability, then clear it without sending.
- Theme switch: `node scripts/set-theme.mjs <name> [layout]` for each scanned theme; confirm the header copy, accents, home art, and chat art all update, the command's `persisted` output matches, and the final choice survives reload.
- Appearance switch: for every `adaptive` theme, switch official Appearance light → dark → system/light and confirm root mode, mode metadata, semantic surfaces, card glass, settings, and dialogs update without calling `set-theme.mjs` again.
- Layout switch: switch between `banner` and `fullscreen`; confirm the native suggestion buttons remain centered and the native composer remains bottom-aligned; confirm the final choice survives reload.
- Chat route: open a real task in every theme and confirm the full chat-art layer appears only behind the task, not on the home screen.
- Reload: use CDP `Page.reload`, wait, and confirm the injection marker returns.
- Normal restart safety: launch Codex normally without debug arguments and confirm the watcher logs the missing port but never terminates or restarts the app. Then use the activation entry, approve the prompt, and confirm the saved theme/layout returns.
- Closed-app behavior: leave Codex closed for at least two watcher polls and confirm the watcher remains idle instead of launching the app.
- Desktop pet: confirm the `initialRoute=/avatar-overlay` renderer has no Dream Skin class, style, chrome, or state and its computed body background is transparent; reload that renderer and confirm it stays clean.
- Restore/reapply cycle: remove live skin, verify marker absent (no `codex-dream-skin`/`dream-theme-*`/`dream-layout-*` classes, no injected nodes, no state object, no inline `--dream-*` vars, no `.dream-new-task` marker, composer placeholder back to the native text), apply again, verify marker present.
- Hit testing: `document.elementsFromPoint` at the center of the sidebar new-task button, the profile button, every suggestion card, the composer input, and the send button must resolve to the real control (or a descendant), with the chrome layer and every sticker computed as `pointer-events: none`.
- Card subtitles: themes with `cards.subtitles` show them under the native card titles; narrowing the window so the native grid drops to 3 and 2 cards must drop the matching subtitles with no misalignment; themes without the field show no subtitle.
- Stickers: only themes with a `stickers` field show them, fullscreen home only (never banner, never chat), never overlapping a native control; public demo themes ship without stickers and README screenshots must not contain personal promo text.
- Themed placeholder: only themes with `composer.placeholder` change the home composer placeholder; the chat/task composer keeps its native placeholder in every theme.
- Theme validation: a theme with a missing required token, a bad folder name, or an unscoped `extra.css` must be skipped/rejected with a `[dream-skin]` warning on stderr and must not break the remaining themes.
- Update resilience: Windows resolves the current `OpenAI.Codex` Appx location dynamically; macOS discovers `ChatGPT.app` / `Codex.app` and reads `CFBundleExecutable` from `Info.plist`. Never store a versioned executable path.
- macOS lifecycle: launch the app bundle through LaunchServices and confirm it remains alive after the invoking shell exits; do not execute `Contents/MacOS/ChatGPT` directly.
- macOS screenshot: `verify-dream-skin.sh --screenshot <path>` captures the Codex window itself by Quartz window ID even when another app overlaps it; it must not use CDP `Page.captureScreenshot`.
- macOS simple install: with `PATH` restricted to system utilities and no external `node`, `meteor-skin-macos.sh install --no-start --no-auto-recover` uses the official app's bundled Node.js, applies the base theme, creates the backup, and does not install a LaunchAgent.
- macOS stable install: after installation, move the source checkout and confirm the installed runtime can still activate, verify, switch themes, repair its injector, and uninstall. Reinstalling atomically refreshes the runtime without leaving the old watcher/injector alive.
- macOS remembered defaults: install with a non-default port and app path, then run `start`, `theme`, `verify`, `doctor`, and `uninstall` without repeating them; each command must use `install-state.json`. Full uninstall must succeed repeatedly even when no base-color backup remains.
- macOS quick-theme: generate one light and one dark route from PNG/JPG fixtures, confirm exactly 28 tokens and valid injector discovery, repeat generation safely, reject a built-in/manual name collision, refresh the stable runtime, and confirm private themes survive. When CDP is active, reload without restarting Codex and apply the requested layout.
- macOS Finder entry points: the install, image-to-theme, and uninstall `.command` files are executable, resolve paths relative to themselves, surface failures without closing immediately, use a native file chooser for theme art, and require confirmation before restarting or uninstalling.
- Safe activation: when CDP is already active, activation must hot-reload without changing the Codex PID; when Codex is open without CDP, activation must leave it untouched unless the user explicitly approves a restart; after an approved restart, verify the app window and injector both recover.
- Stable Windows runtime: shortcuts and watcher point to `%LOCALAPPDATA%\CodexDreamSkin\runtime`, not an extracted/downloaded source directory; move the source package after installation and confirm activate/verify/restore still work.
- Non-destructive lifecycle: scan the distributed Skill for recursive destructive deletion (`rm -rf`, recursive `fs.rm`, `Remove-Item -Recurse`, `rd /s`, `rmdir /s`); the result must be empty. Reinstall/uninstall must archive old runtime/theme/Skill directories.
- Portable package: build on macOS and Windows, validate `PACKAGE.json`, verify every entry in `SHA256SUMS.txt`, install from a path containing spaces/non-ASCII text, and confirm the intended private adaptive theme is available.

## Visual checks

- 1280x820 initial home: in both layouts, hero, native cards, real project selector, and composer are all visible without horizontal scrolling or header overlap.
- First-entry density: the hero anchors the top/canvas, suggestions occupy the middle, and the real project selector/composer stays at the bottom; reject a large accidental empty band or collisions.
- Swappable art: changing a theme's home or chat image may require only that theme's crop/wash tokens in its `theme.json`; hero/card/composer geometry must not depend on a specific subject position.
- Ghost-text ban: zoom into every corner of both layouts; no readable text, UI fragments, or border lines from the source art may remain. Prefer a heavier overlay over any ghosting (see THEME-SPEC.md §5).
- Chat readability: the subject may be recognizable, but fake source text/cards and high-contrast detail must not compete with real messages.
- Narrower window: accept Codex's native responsive behavior; no essential control is covered and the polaroid intentionally hides at 1400px and below.
- Normal task: messages remain readable and composer does not overlap content.
- Inspect the sidebar, header, hero edges, card labels, composer controls, scrollbar, ribbon, and bottom-right decoration.
- Component matrix in both appearances: sidebar rows, account card/menu, composer, model/effort picker, project selector, suggestion cards, quick-mode banner, diff/file cards, environment popover, context usage, toast, menu/listbox, settings navigation/search/cards/select/switch, generic dialog, permission dialog, links, disabled controls, and destructive actions.
- Contrast: normal text should meet 4.5:1 where practical; large text, icons, borders, and focus indicators should meet 3:1. Reject dark text on dark surfaces, pale text on pale surfaces, and semantic-danger colors flattened by broad overrides.
- Glass: background art remains recognizable through suggestion cards, while titles/subtitles stay readable over the most detailed part of the art. Check configured blur, saturation, border, hover, and both light/dark alpha values.
- Fullscreen geometry: verify configurable inset/radius at 1280×820, 1470×923, and a large display; the canvas should approach the main border without clipping cards, project selector, composer, or rounded corners.
- Reject black/transparent sidebar artifacts, clipped cards, duplicated/disconnected project labels, rasterized native controls, deep chat fills, readable fake controls from source art, weak contrast, or decorations intercepting clicks.
- Reject any colored square, gradient, or opaque panel behind a desktop pet. Auxiliary overlay windows must remain transparent even while the main window is fully skinned.

## Exploratory checks

- Start when the debug port is occupied: fail with a clear message or use a caller-selected port.
- Start after Codex updates: package discovery and injection still work without patching installed files.
- Start with zero valid themes: the injector must fail with a clear "No valid themes found" error instead of injecting a broken payload.
