import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color? bgcolor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Widget? icon;
  final Function()? onTap;

  const SmallCard({
    Key? key,
    this.title,
    this.subtitle,
    this.bgcolor,
    this.height,
    this.width,
    this.borderRadius,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double radius = borderRadius ?? 16;

    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap ?? () {},
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: bgcolor ?? colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              if (icon != null)
                Positioned(
                  top: -10,
                  right: -10,
                    child: SizedBox(
                      height: 88,
                      width: 88,
                      child: icon,
                    ),
                  ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
