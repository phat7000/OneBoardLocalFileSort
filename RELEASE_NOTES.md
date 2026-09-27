# OneBoard Local File Sort v1.0.0

First public release of OneBoard Local File Sort.

OneBoard Local File Sort uses local AI to help organize files into cleaner folder structures and suggest clearer filenames while keeping the user in control of every change.

## Highlights

- Local AI categorization
- Local document and image analysis
- Category, subcategory, and filename suggestions
- Review before apply
- Dry Run and Undo Last Run
- Category whitelists and local learned behavior
- Project-folder protection and file preview
- External-drive and supported mounted-folder workflows
- Windows x64 portable package and per-user installer

## Local-first design

Cloud LLM providers are disabled in the OneBoard build. The selected local model must be downloaded once before first use. After required model assets are available locally, normal analysis works without a cloud LLM. User files are not uploaded to a OneBoard server.

## Safety

AI suggestions are reviewed before files are moved or renamed. Dry Run previews planned changes. Undo Last Run can reverse the previous applied run where the filesystem state permits it.

## Downloads

- Portable: `OneBoardLocalFileSort-1.0.0-win-x64.zip`
- Installer: `OneBoardLocalFileSort-Setup-1.0.0-win-x64.exe`
- Checksums: `SHA256SUMS.txt`

## Open source

OneBoard Local File Sort is an independent modified distribution based on [AI File Sorter](https://github.com/hyperfield/ai-file-sorter). OneBoard source is available at https://github.com/phat7000/OneBoardLocalFileSort. The software is distributed under the applicable GNU Affero General Public License v3.0 terms. Upstream names and branding belong to their respective owner.
