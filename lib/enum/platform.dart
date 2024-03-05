/// 平台裝置的類型列舉
enum Platform {
  /// 手機
  mobile(0),

  /// 平板
  tablet(720),

  /// 電腦
  computer(1280);

  /// 平台裝置的最小寬度
  final double minWidth;

  const Platform(this.minWidth);
}
