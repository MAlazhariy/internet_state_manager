## [1.7.0]

### Added
- `checkConnectionTimeout` option to set the timeout duration when checking real internet connection.

---

## [1.6.1]

### Added
- Change `checkConnection` return type to `Future<bool>` to return if connection is available or not.

---

## [1.5.0]

### Enhanced
- Recheck the connection if `autoCheckConnection` is TRUE or if connection lost.

---

## [1.4.2]

### Fixed
- internet_connection_checker version, set to any

---

## [1.4.1]

### Added
- `internetCheck()` context extension to allow to check internet form context extension.

---

## [1.3.1]

### Added
- `internetStateStream` accessed from `context` to listen for internet connection changes only (**without listening to loading states**), i.e: `context.internetStateStream.listen((status){})`.

### Fixed
- ios 12+ known issue with `ConnectivityPlus` that get none even if the local network is available,
the bloc is now check the real internet connection on `ios` **even if the local network is none**.

---

## [1.2.0]

### Enhancements
- Optimized the emission of the **loading** state to occur only when disconnected and a local network (e.g., Wi-Fi) is available, reducing unnecessary state emissions.
- Improved overall efficiency by decreasing the emission of unnecessary states, avoiding the loading state in cases where it isn't required.

### Added
- `showLogs` option to enable or disable log prints, providing better control over console output.
- `disconnectionCheckPeriodic` option to set the `Duration` for periodic checks during a disconnection state, allowing more granular control over connectivity checks.

### Updated
- Example project to reflect the latest changes and improvements.
- `README.md` file with updated instructions and information.

---

## [1.1.0]

### Added
- Implemented a `Stream` that checks internet connectivity every 10 seconds, emitting a new state if the connection status changes.
- Introduced the `autoCheck` option to control whether internet connectivity should be checked automatically. Set to `false` to disable automatic checks.
- Added an option to customize the check interval, controlling the time between connectivity checks.
- Created an `Object` for translations, allowing easier addition or customization of translations, such as Arabic or specific texts to display when no internet connection is available.

### Changed
- Updated the `builder` widget to remove the direct ability to add `noInternetScreen`. Customization of the no internet screen is now done via the builder function, providing greater flexibility in UI design.


