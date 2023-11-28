import 'package:flutter/material.dart';

class DashedLineWidget extends StatelessWidget {
  final bool vertical;
  final double dash;
  final double space;
  final Color color;
  final bool invertDash;

  /// DashedLineWidget initialization
  const DashedLineWidget({
    super.key,
    this.vertical = false,
    this.dash = 3,
    this.space = 3,
    required this.color,
    this.invertDash = false,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double size = vertical ? constraints.maxHeight : constraints.maxWidth;

        int count = (size / (dash + space)).round();

        if (vertical) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 1,
                height: space,
                color: invertDash ? color : null,
              ),
              for (int i = 0; i < count - 1; i++) ...[
                Container(
                  width: 1,
                  height: dash,
                  color: invertDash ? null : color,
                ),
                Container(
                  width: 1,
                  height: space,
                  color: invertDash ? color : null,
                ),
              ],
            ],
          );
        } else {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: space,
                height: 1,
                color: invertDash ? color : null,
              ),
              for (int i = 0; i < count - 1; i++) ...[
                Container(
                  width: dash,
                  height: 1,
                  color: invertDash ? null : color,
                ),
                Container(
                  width: space,
                  height: 1,
                  color: invertDash ? color : null,
                ),
              ],
            ],
          );
        }
      },
    );
  }
}
