# jenkinsTestFlutter
test jenkins with flutter

## App version

Edit the Flutter version in `pubspec.yaml` before running Jenkins:

```yaml
version: 1.0.0+1
```

Jenkins reads this value with `scripts/app_version.ps1`, shows it on the build, and passes it to `flutter build apk` as the APK version name and build number.
