# Stack Mapping Matrix — Mobile Development Cross-Reference

Reference file for `mobile-dev-study`. Maps core mobile development concepts across all 4 target stacks: **React Native, Flutter, Kotlin (Jetpack Compose), and Swift (SwiftUI)**.

---

## 🗺️ Cross-Stack Concept Matrix

| Conceptual Feature Category | React Native (TypeScript) | Flutter (Dart) | Kotlin Native (Jetpack Compose) | Swift Native (SwiftUI) |
|---|---|---|---|---|
| **UI Components & Layout** | JSX, `View`, `Text`, `FlatList`, Flexbox | `Widget`, `StatelessWidget`, `ListView`, Flex | `@Composable`, `Box`, `Column`, `LazyColumn` | `View`, `VStack`, `HStack`, `List` |
| **Local State Management** | `useState`, `useReducer`, `useMemo` | `StatefulWidget`, `ValueNotifier` | `remember`, `mutableStateOf` | `@State`, `@Binding`, `@FocusState` |
| **Global/Shared State** | Zustand, Redux Toolkit, React Context | Bloc, Riverpod, Provider | ViewModel + StateFlow / SharedFlow | `@StateObject`, `@ObservedObject`, `@EnvironmentObject` |
| **Async & Side Effects** | `useEffect`, `useCallback`, Promises/Async-Await | `Future`, `Stream`, `StreamBuilder` | `LaunchedEffect`, `coroutines`, `Flow` | `task`, `async/await`, Combine |
| **Navigation & Routing** | React Navigation, Expo Router | GoRouter, Navigator 2.0 | Jetpack Navigation Compose | `NavigationStack`, `NavigationPath` |
| **Local Storage & Caching** | MMKV, SQLite (WatermelonDB/Expo-SQLite) | Hive, Isar, Shared Preferences | Room DB, DataStore | SwiftData, CoreData, UserDefaults |
| **Networking & HTTP** | Axios, Fetch API, TanStack Query | Dio, Http package | Retrofit, Ktor Client | URLSession, Alamofire |
| **Dependency Injection** | InversifyJS / React Context / Factory functions | GetIt, Injectable | Hilt, Koin | Factory / Swift DI / Environment |

---

## 💡 How to Use in Prerequisites

When generating prerequisite guides under `prerequisites/`, reference the column matching the student's chosen stack. Keep code examples generic and focused on the architectural pattern.
