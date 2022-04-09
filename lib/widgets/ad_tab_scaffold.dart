import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'banner_widget.dart';

class AdTabScaffold extends StatefulWidget {
  final CupertinoTabBar tabBar;
  final IndexedWidgetBuilder tabBuilder;

  const AdTabScaffold({
    Key? key,
    required this.tabBar,
    required this.tabBuilder,
  }) : super(key: key);
  @override
  _AdTabScaffoldState createState() => _AdTabScaffoldState();

  static _AdTabScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AdTabScaffoldState>();
  }
}

class _AdTabScaffoldState extends State<AdTabScaffold> {
  late final ValueNotifier<int> _controller;

  void setPage(int index) => _controller.value = index;

  @override
  void initState() {
    super.initState();
    _controller = ValueNotifier(widget.tabBar.currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: _controller,
              builder: (_, value, __) => _TabSwitchingView(
                currentTabIndex: value,
                tabCount: widget.tabBar.items.length,
                tabBuilder: widget.tabBuilder,
              ),
            ),
          ),
          //BannerWidget(),
          ValueListenableBuilder<int>(
            valueListenable: _controller,
            builder: (_, value, __) => widget.tabBar.copyWith(
              currentIndex: value,
              onTap: (int newIndex) {
                _controller.value = newIndex;
                widget.tabBar.onTap?.call(newIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    required this.currentTabIndex,
    required this.tabCount,
    required this.tabBuilder,
  }) : assert(tabCount > 0);

  final int currentTabIndex;
  final int tabCount;
  final IndexedWidgetBuilder tabBuilder;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  final List<bool> shouldBuildTab = <bool>[];
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];

  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];

  @override
  void initState() {
    super.initState();
    shouldBuildTab.addAll(List<bool>.filled(widget.tabCount, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final int lengthDiff = widget.tabCount - shouldBuildTab.length;
    if (lengthDiff > 0) {
      shouldBuildTab.addAll(List<bool>.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildTab.removeRange(widget.tabCount, shouldBuildTab.length);
    }
    _focusActiveTab();
  }

  void _focusActiveTab() {
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount));
        tabFocusNodes.removeRange(widget.tabCount, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount - tabFocusNodes.length,
            (int index) => FocusScopeNode(),
          ),
        );
      }
    }
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  @override
  void dispose() {
    for (final FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (final FocusScopeNode focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List<Widget>.generate(widget.tabCount, (int index) {
        final bool active = index == widget.currentTabIndex;
        shouldBuildTab[index] = active || shouldBuildTab[index];

        return HeroMode(
          enabled: active,
          child: Offstage(
            offstage: !active,
            child: TickerMode(
              enabled: active,
              child: FocusScope(
                node: tabFocusNodes[index],
                child: Builder(builder: (BuildContext context) {
                  return shouldBuildTab[index]
                      ? widget.tabBuilder(context, index)
                      : Container();
                }),
              ),
            ),
          ),
        );
      }),
    );
  }
}
