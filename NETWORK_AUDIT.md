# OneBoard Local File Sort v1.0.0 Network Audit

This audit distinguishes production network behavior from source-only compatibility code,
tests, build tooling, legal attribution, and upstream documentation. The Windows x64
Standalone release is built with application updates disabled and an empty storage-plugin
catalog URL.

## Production behavior

| Surface | Classification | OneBoard v1.0.0 behavior |
| --- | --- | --- |
| Hugging Face model artifacts | USER_APPROVED_MODEL_DOWNLOAD | Used only after the user selects **Download Local Model**. The default Gemma artifact is pinned to an immutable model-repository revision. |
| `api.openai.com` | INTERNAL_REFERENCE | The upstream client remains compiled to reduce merge risk, but remote choices are absent from normal UI, stored remote choices migrate to the local default, credentials are discarded, and client creation rejects every remote choice. |
| `generativelanguage.googleapis.com` | INTERNAL_REFERENCE | Same defense-in-depth restrictions as OpenAI; unreachable through OneBoard production settings and UI. |
| Custom OpenAI-compatible endpoints | INTERNAL_REFERENCE | The upstream implementation remains in source, but UI controls are hidden, endpoint definitions are not loaded or saved, and remote client construction is rejected. |
| `filesorter.app` update feed | UPDATE_INFRA | Disabled at compile time for the Standalone release. No update check is scheduled. |
| `filesorter.app` storage catalog | PLUGIN_INFRA | The production catalog URL is empty in both CMake and Make defaults; runtime catalog fetching receives no URL. |
| Upstream Explorer extension | USER_FACING_PRODUCT_LINK | Install/download actions and prompts are disabled; no upstream download page is opened. |
| `nominatim.openstreetmap.org` | INTERNAL_REFERENCE | Network reverse-geocoding is disabled. Local EXIF values and an existing local cache may still be used. |
| OneBoard website/repository | USER_FACING_PRODUCT_LINK | Links may be opened only after an explicit user action such as choosing About/Website/Source; the app sends no files or filenames to OneBoard. |

After model assets are cached, scan, analysis, review, dry run, apply, and undo use local
filesystem, database, metadata, and llama.cpp paths. Prompt logging remains disabled unless a
developer-only logging mode is explicitly enabled.

## Retained source occurrences

- `hyperfield/ai-file-sorter` and the upstream product name in `LICENSE`, `NOTICE.md`,
  `UPSTREAM.md`, `TRADEMARKS.md`, the About credits, and release documentation are
  **LEGAL_ATTRIBUTION** or **UPSTREAM_DOCUMENTATION**.
- `filesorter.app` URLs under updater unit tests are **TEST_FIXTURE** values used to verify
  disabled and parser behavior; they are not the production feed configuration.
- macOS/Linux packaging scripts and historical script documentation are
  **UPSTREAM_DOCUMENTATION** and are not part of the Windows x64 Standalone release.
- Names such as `AI_FILE_SORTER_*`, `aifilesorter` target identifiers, settings keys, and
  database-compatible identifiers are **INTERNAL_REFERENCE** values retained to avoid data
  migration and upstream-merge breakage.
- SourceForge and Microsoft Store references, where retained in non-Windows-Standalone
  tooling or tests, are **TEST_FIXTURE** or **UPSTREAM_DOCUMENTATION**, not runtime endpoints
  in this release.

The final portable and installer payloads are separately scanned before release. Any
unexpected runtime-loaded `filesorter.app`, OpenAI, Gemini, or Nominatim configuration in
those payloads is a release blocker.
