# Upstream

- Upstream project: AI File Sorter
- Upstream author/project owner: hyperfield
- Repository: https://github.com/hyperfield/ai-file-sorter
- Upstream release: v1.9.2
- Baseline commit: `7d4876a6ec971bbd5da085b587ad237326e160a2`
- Upstream license: AGPL-3.0
- OneBoard version: 1.0.0

The `upstream-main` branch records the pristine baseline. OneBoard modifications are maintained on `main`.

For a future upstream update:

1. Run `git fetch upstream --tags`.
2. Review a stable upstream release and its license/trademark changes.
3. Advance `upstream-main` to the selected upstream release without rewriting history.
4. Merge or cherry-pick appropriate upstream changes into `main`.
5. Preserve and re-audit the OneBoard local-only, branding, updater, plugin, geocoding, and file-safety patches.
6. Rebuild and run the full regression and packaging suite before release.
