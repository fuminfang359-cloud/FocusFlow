# FocusFlow v0.1.0

FocusFlow 是一个 Flutter 番茄钟 MVP，包含专注计时、任务管理、统计、成长奖励和设置页面。

## 项目结构

此 ZIP 为适合通过手机上传到 GitHub 的扁平源码包。Dart 源文件位于根目录，GitHub Actions 会自动生成原生平台目录，并将 Dart 文件放入 `lib/`。

- `pubspec.yaml`：Flutter 项目依赖和版本配置
- `main.dart`：应用入口和底部导航
- `app_state.dart`：应用状态、计时逻辑和本地持久化
- `timer_screen.dart`：番茄钟计时页面
- `tasks_screen.dart`：任务管理页面
- `stats_screen.dart`：专注统计页面
- `growth_screen.dart`：等级和成就页面
- `settings_screen.dart`：时长、提醒、主题及数据设置
- `ui.dart`：通用 UI 组件和主题
- `ad_service.dart`：广告位占位与测试 ID 常量
- `.github/workflows/build-android.yml`：云端 APK 构建流程

## 通过 GitHub Actions 构建 APK

1. 将 ZIP 解压，把其中所有文件和 `.github` 目录上传到 GitHub 仓库根目录。
2. 默认分支使用 `main`。推送到 `main` 会自动触发构建，也可以进入仓库的 **Actions** 页面，选择 **Build FocusFlow Android APK**，点击 **Run workflow**。
3. 构建成功后，打开该次工作流运行记录，在 **Artifacts** 区域下载 `focusflow-android-apk`。
4. 解压 Artifact，找到 `app-release.apk`，再传到 Android 手机安装测试。

工作流在临时目录生成原生 Android/iOS 工程，再复制平台目录到项目中，避免 `flutter create` 覆盖本项目的 `pubspec.yaml`。流程会执行依赖解析、Dart 格式化、静态分析和 release APK 构建。任一步失败都会将工作流标记为失败，便于查看日志。

## 本地构建

需要安装 Flutter SDK、Android SDK 和 Java 17。解压 ZIP 后，在项目根目录运行：

```bash
flutter create --project-name focusflow --org com.focusflow --platforms=android,ios /tmp/focusflow_scaffold
mkdir -p android ios lib
cp -a /tmp/focusflow_scaffold/android/. android/
cp -a /tmp/focusflow_scaffold/ios/. ios/
cp ./*.dart lib/
flutter pub get
dart format lib
flutter analyze
flutter build apk --release
```

## 当前版本限制

- 源码需要在真实 Flutter 环境中执行构建和设备测试。本交付环境没有 Flutter SDK，无法在此直接验证 APK。
- 计时结束后会在应用恢复前台时校准状态；系统后台通知尚未接入。
- 广告目前为 UI 占位，没有真正请求广告。正式发布前需接入 Google Mobile Ads、替换正式广告 ID，并完成隐私披露和用户同意流程。
- “去除广告”目前是本地测试开关，没有应用内购买。
