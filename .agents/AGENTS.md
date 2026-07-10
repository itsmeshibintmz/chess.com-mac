# Chess.com macOS — Project Rules

## Release Workflow

Whenever the user asks to create a new release or release notes:

1. **Always bump the version first** — update `MARKETING_VERSION` in BOTH Debug and Release configurations inside `ChessMac.xcodeproj/project.pbxproj` before doing anything else.

2. **Always rebuild the DMG** — run `bash build_dmg.sh` from the repo root after bumping the version.

3. **Always share the release note in chat** — output it as a fenced markdown code block (` ```markdown `) directly in the response so the user can copy-paste it straight to GitHub. Never write it to a file or artifact — always inline in chat.

4. **Release note format** — always follow this exact template:

```
Chess.com macOS Web App — vX.Y.Z

One-line summary of what this release is about.

### 🔧 Fixes & Improvements  (or 🎨 / 🐛 / ⚙️ as appropriate)

*   **Feature/Fix Name**: Description of what changed and why it matters.
*   **Another Fix**: Description.

---

### 📦 Installation
1. Download `Chess.com.dmg` from this release (or find it directly in your local Downloads folder).
2. Open the DMG and drag **Chess.com** to your **Applications** folder.
```

## Version History Reference

| Version | Notes |
|---------|-------|
| v1.0.0  | Initial release |
| v1.2.0  | (version was stuck here due to missing bump) |
| v1.3.0  | Monkeytype Themes Integration |
| v1.3.1  | Version display fix (MARKETING_VERSION was 1.2.0 at runtime) |
| v1.4.0  | Chess.com pawn icon (transparent bg, all sizes correct) |
| v1.4.1  | Icon dark mode / tinting fix (removed white background) |
