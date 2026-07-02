# 📱 Modern Job Board Application - TalentStream

A high-performance, cross-platform mobile application developed with Flutter, designed to deliver a seamless job searching, filtering, and offline application experience. This project implements state management and  best practices to handle high-traffic real-time data streaming elegantly.

---

## ✨ Features

* **Event-Driven Infinite Scroll:** Implements optimized lazy loading and pagination pipelines that dynamically fetch job listings seamlessly as the user scrolls.
* **Predictive State Handling:** Explicitly manages complex asynchronous life cycles, rendering specific, user-friendly states for active data loading, network anomalies, and empty results.
* **Robust Offline Caching:** Integrates a local SQLite persistence loop. Saved bookmarks are stored safely on-disk, enabling instantaneous offline data retrieval without cellular data links.
* **Hardware Integration:** Parses complex contact payload metadata to establish direct system triggers, handing off deep links to telephony services or WhatsApp configurations smoothly.

---

## 🛠️ Tech Stack

* **Core Framework:** Flutter & Dart (Cross-Platform Android/iOS deployment targets)
* **State Management:** `flutter_bloc` & `equatable` (Enforces strict unidirectional data flows and immutable state tracking)
* **Local Persistence Engine:** `sqflite` paired with `path_provider` for custom SQLite on-device database orchestration
* **Networking Layer:** Asynchronous REST API communications utilizing Dart’s native `http` payload architecture
* **System Triggers:** Platform-native deep-linking pipelines via `url_launcher`

---

## 🏗️ Deep Dive: State Management (BLoC)

The application leverages the **BLoC Pattern** to decouple business logic from presentation layer layouts. Views emit pure intent events (e.g., `FetchJobsEvent`), which are processed sequentially by background asynchronous routines:

1. **`JobInitial`**: Pre-boot configuration verification.
2. **`JobLoading`**: Spawns loading indicators on first-page initialization queries.
3. **`JobLoaded`**: Compiles previous payloads with newly streamed records while tracking current pagination boundaries (`page`, `hasReachedMax`).
4. **`JobError`**: Intercepts structural network glitches or status breakdowns safely to trigger localized error interfaces.

---

## 🚀 Installation & Local Environment Setup

Ensure you have the Flutter SDK environment configured correctly before pulling down dependencies.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/nk-31012002/TalentStream.git
   cd taletstream

2. **Retrieve package dependencies:**
   ```flutter pub get```

3. **Verify analyzer guidelines and lint rules:**
   ```flutter analyze```

4. **Launch the build on a connected test target:**
   ```flutter run --debug```
