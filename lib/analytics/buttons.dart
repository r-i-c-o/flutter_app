import 'package:flutter/material.dart';
import 'events/widget_events.dart';
import 'firebase_instance.dart';

class KadoLoggingButton extends StatelessWidget {
  final Widget child;
  @userSubAction
  final String subAction;
  final String widgetName;

  const KadoLoggingButton({
    Key? key,
    required this.subAction,
    required this.child,
    required this.widgetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FirebaseInstance.instance.logEvent(
          name: UserAction.buttonClick
              .replaceFirst(EventPathParam.subAction, subAction),
          parameters: {
            EventQueryParam.viewName: widgetName,
          },
        );
      },
      child: child,
    );
  }
}
