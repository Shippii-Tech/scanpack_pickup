
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final Widget body;

  final List<Function()> resources;
  const MainLayout({super.key, required this.body, required this.resources});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  @override
  void initState() {
    _pullRefresh();

    super.initState();
  }

  Future<void> _pullRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var i = 0; i < widget.resources.length; ++i) {
        await widget.resources[i]();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        strokeWidth: 2.0,
        onRefresh: _pullRefresh,
        notificationPredicate: (ScrollNotification notification) {
          return notification.depth >= 0;
        },
        child: SafeArea(
          child: widget.body,
        ),
      ),
    );
  }
}
