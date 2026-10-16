import 'package:flutter/material.dart';

import 'ui.dart';

/// 广告配置。以下全部是 Google 官方测试 ID，上线前必须替换为自己的 AdMob ID。
///
/// 接入真实广告的步骤（v1.1）：
/// 1. pubspec.yaml 增加 google_mobile_ads 依赖；
/// 2. AndroidManifest.xml 写入 APPLICATION_ID 元数据，Info.plist 写入 GADApplicationIdentifier；
/// 3. main() 中调用 MobileAds.instance.initialize()；
/// 4. 把下面的 AdBanner 占位替换成 BannerAd + AdWidget；
/// 5. 上线前接入用户同意流程（UMP）并补充隐私政策。
class AdConfig {
  static const androidAppTestId = 'ca-app-pub-3940256099942544~3347511713';
  static const iosAppTestId = 'ca-app-pub-3940256099942544~1458002511';
  static const androidBannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const iosBannerTestId = 'ca-app-pub-3940256099942544/2934735716';
}

/// 底部横幅广告位（目前是占位）。adsRemoved 为 true（已购买去广告）时不显示。
class AdBanner extends StatelessWidget {
  const AdBanner({super.key, required this.adsRemoved});
  final bool adsRemoved;

  @override
  Widget build(BuildContext context) {
    if (adsRemoved) return const SizedBox.shrink();
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: lineColor(context))),
      ),
      child: Text(
        '广告位（预留 · Google Mobile Ads）',
        style: TextStyle(fontSize: 12, color: mutedColor(context)),
      ),
    );
  }
}
