import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class AppDrawer extends StatelessWidget {
  final BuildContext ctx;
  const AppDrawer({this.ctx});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(child: SingleChildScrollView(child: Container())));
  }
}
