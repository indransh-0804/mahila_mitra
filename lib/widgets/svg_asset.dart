import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mahila_mitra/utils/icons.dart';

class SvgAsset extends StatelessWidget {
  final AssetName? assetName;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  const SvgAsset(
      {Key? key, this.assetName, this.height, this.width, this.fit, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      width: width,
      child: SvgPicture.asset(
        mySvgAssets().assets[assetName]!,
        fit: fit ?? BoxFit.cover,
        color: colorScheme.onSurface
      ),
    );
  }
}
