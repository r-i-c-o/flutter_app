import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onLeadingPressed;
  final bool shrink;

  const AppTopBar(
      {Key? key,
      required this.title,
      this.onLeadingPressed,
      this.shrink = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double toolbarPadding = shrink ? 8.0 : 16.0;
    MediaQueryData data = MediaQuery.of(context);
    double topPadding = data.padding.top;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        toolbarPadding + topPadding,
        16.0,
        toolbarPadding,
      ),
      child: Row(
        children: [
          if (onLeadingPressed != null)
            IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: onLeadingPressed,
            ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onLeadingPressed != null) SizedBox(width: 48.0),
        ],
      ),
    );
  }
}
