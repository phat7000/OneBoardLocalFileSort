# Third-party notices

OneBoard Local File Sort uses third-party software including Qt, llama.cpp, curl, SQLite, OpenSSL, zlib, libwebp, fmt, spdlog, gettext, MediaInfo, PDFium, libzip, pugixml, JSONCPP, and Catch2 for tests. Their license files and notices remain in the corresponding source/dependency distributions; vcpkg supplies many Windows dependencies under their respective upstream terms.

The recommended separately downloaded model is **Gemma 3 4B IT Q4_K_M**, provided by its respective authors and hosted by Hugging Face. OneBoard v1.0.0 pins the download URL to model-repository revision `d0976223747697cb51e056d85c532013931fe52e`. Model weights are not part of the OneBoard source or binary packages. Gemma is subject to the [Gemma Terms of Use](https://ai.google.dev/gemma/terms) and the incorporated prohibited-use policy. Users are shown this information before initiating a model download.

AI File Sorter attribution and AGPL terms are documented in `NOTICE.md`, `UPSTREAM.md`, `TRADEMARKS.md`, and `LICENSE`.
