import 'package:flutter/material.dart';
import 'package:tvapixa/main.dart';
import 'dart:async';

import 'package:webview_windows/webview_windows.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class TvHolder extends StatefulWidget {
  final TvLink tvLink;
  const TvHolder({Key key, this.tvLink}) : super(key: key);

  @override
  _TvHolderState createState() => _TvHolderState();
}

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  SlidingAppBar({
    this.child,
    this.controller,
    this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}

class _TvHolderState extends State<TvHolder> {
  final _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    await _controller.initialize();

    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.loadUrl(widget.tvLink.link);

    if (!mounted) return;

    setState(() {});
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return CircularProgressIndicator();
    } else {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Webview(
                _controller,
                permissionRequested: _onPermissionRequested,
              ),
              StreamBuilder<LoadingState>(
                  stream: _controller.loadingState,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data == LoadingState.loading) {
                      return LinearProgressIndicator();
                    } else {
                      return Container();
                    }
                  }),
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FloatingActionButton(
            foregroundColor: Colors.white,
            mini: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Center(
        child: compositeView(),
      ),
      backgroundColor: Color.fromRGBO(16, 16, 16, 1),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
