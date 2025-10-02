import 'package:flutter/material.dart';
import 'package:mahila_mitra/utils/icons.dart';
import 'package:mahila_mitra/widgets/svg_asset.dart';

class Cards extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double height;
  final double width;
  final List<Widget>? actions; // optional row of icons/buttons
  final Widget? vectorBottom;
  final Widget? vectorTop;
  final VoidCallback? onTap;
  final String? tag;

  const Cards({
    super.key,
    required this.title,
    this.subtitle,
    this.gradientStartColor = const Color(0xff441DFC),
    this.gradientEndColor = const Color(0xff4E81EB),
    this.height = 120,
    this.width = double.infinity, // default full width
    this.actions,
    this.vectorBottom,
    this.vectorTop,
    this.onTap,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [gradientStartColor, gradientEndColor],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Container(
            height: height,
            width: width,
            child: Stack(
              children: [
                // Background vectors
                vectorBottom ??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SvgAsset(
                        height: height,
                        width: width,
                        assetName: AssetName.vectorBottom,
                      ),
                    ),
                vectorTop ??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SvgAsset(
                        height: height,
                        width: width,
                        assetName: AssetName.vectorTop,
                      ),
                    ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: tag ?? '',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              subtitle!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (actions != null)
                        Row(
                          children: actions!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
