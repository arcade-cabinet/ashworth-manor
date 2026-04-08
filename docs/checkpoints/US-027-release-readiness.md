# US-027 — Release Readiness

## Debug-Packaged Evidence

With the Android SDK and build-tools exported into the environment:

```bash
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/36.1.0:$PATH"
```

the following succeeded:

- `godot --headless --path . --export-debug "Android" build/android/ashworth-manor-debug.apk`
- `adb install --no-incremental -r build/android/ashworth-manor-debug.apk`
- `adb shell am start -W -n com.arcadecabinet.ashworthmanor/com.godot.game.GodotAppLauncher`

Artifacts and evidence:

- debug APK:
  - `build/android/ashworth-manor-debug.apk`
- signed-APK verification:
  - `apksigner verify --verbose --print-certs build/android/ashworth-manor-debug.apk`
- device screenshot:
  - `reports/android/debug-launch.png`

## Release Export Result

Attempted:

- `godot --headless --path . --export-release "Android" build/android/ashworth-manor-release.apk`

Current blocker:

- release keystore credentials are not configured

Observed failure:

- `WARNING: Code Signing: Could not find release keystore, unable to export.`

## Outcome

`US-027` is blocked on local release-signing credentials. The repo-owned export
surface is in place and debug packaged validation is real, but release-candidate
proof cannot be completed honestly until a release keystore is configured.
