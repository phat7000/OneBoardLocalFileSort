# OneBoard Local File Sort

**Organize local files with local AI, while staying in control of every change.**

OneBoard Local File Sort is a Windows utility that uses local AI to suggest file categories, folder structures, and cleaner filenames. It is an independent modified distribution of [AI File Sorter](https://github.com/hyperfield/ai-file-sorter), based on upstream release v1.9.2.

## Features

- Local AI file categorization, document analysis, and image analysis
- Filename, category, and subcategory suggestions
- Mandatory review before apply by default
- Dry Run and Undo Last Run
- Category whitelists and local learned behavior
- Project-folder protection
- Local drives, external drives, and supported mounted/network folders

## Privacy and network use

OneBoard v1.0.0 does not expose cloud LLM providers in normal use. Files, filenames, document text, and learned behavior stay on the device. OneBoard has no server that receives user files.

Internet access is required only when the user explicitly downloads local model assets. The recommended model is Gemma 3 4B IT Q4_K_M. Model weights are not bundled with the application or its releases. After required assets are cached, normal analysis uses local inference and does not require a cloud LLM.

The upstream application updater, upstream storage-plugin catalog, upstream Explorer-extension download workflow, and network reverse geocoding are disabled in the OneBoard build.

## Safe workflow

Use a disposable test folder first:

1. Choose or download a local model.
2. Scan files and generate suggestions.
3. Review every proposed move and rename.
4. Use Dry Run when unsure.
5. Confirm to apply.
6. Use Undo Last Run when the filesystem state still permits restoration.

No software can guarantee perfect categorization or rollback after unrelated external filesystem changes. Keep backups of important data.

## Windows source build

The Windows build is not dependency-free. It requires Git with submodule support, Visual Studio 2022 Build Tools or Visual Studio with the MSVC x64 C++ workload and Windows SDK, CMake 3.21 or newer, PowerShell, and a writable vcpkg checkout. NSIS is also required to build the installer.

```powershell
git clone --recurse-submodules https://github.com/phat7000/OneBoardLocalFileSort.git
cd OneBoardLocalFileSort
git submodule update --init --recursive
git clone https://github.com/microsoft/vcpkg.git D:\dev\vcpkg
D:\dev\vcpkg\bootstrap-vcpkg.bat -disableMetrics
powershell -NoProfile -ExecutionPolicy Bypass -File .\app\build_windows.ps1 `
  -VcpkgRoot D:\dev\vcpkg `
  -Configuration Release `
  -Variants Standalone `
  -Clean
```

The manifest in `app/vcpkg.json` and its pinned baseline supply Qt 6 and other native dependencies. See `TESTS.md` for the upstream-derived test layout. Release builds and packages are produced only after the OneBoard regression gates pass.

## License and attribution

The application is distributed under the GNU Affero General Public License v3.0. See [LICENSE](LICENSE), [NOTICE.md](NOTICE.md), [UPSTREAM.md](UPSTREAM.md), [TRADEMARKS.md](TRADEMARKS.md), and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

Website: https://oneboard.io.vn

Source: https://github.com/phat7000/OneBoardLocalFileSort
