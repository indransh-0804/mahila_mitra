class mySvgAssets {
  static final mySvgAssets _instance = mySvgAssets._internal();

  factory mySvgAssets() {
    return _instance;
  }

  mySvgAssets._internal();

  Map<AssetName, String> assets = {
    AssetName.vectorBottom: "assets/images/Vector.svg",
    AssetName.vectorTop: "assets/images/Vector-1.svg",
  };
}

enum AssetName {
  vectorBottom,
  vectorTop,
}
