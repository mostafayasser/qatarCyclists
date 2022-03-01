import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';

import '../../widgets/header_color.dart';

class ShopTap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          buildHeaderStack(context),
          Expanded(child: buildBody(context)),
        ],
      ),
    );
  }

  Stack buildHeaderStack(context) {
    final locale = AppLocalizations.of(context);

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        HeaderColor(
          hasTitle: true,
          title: locale.get('Shop') ?? 'Shop'.toUpperCase(),
          titleImage: 'shop_cart.png',
          titleImageColor: Color(0xffFFB900),
          trailingWidget: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Image.asset(
                'assets/images/shop_cart.png',
                height: 22,
              ),
              Positioned(
                right: -10,
                top: -8,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Color(0xffFF6969)),
                  constraints: BoxConstraints(
                    minWidth: 20,
                    minHeight: 15,
                  ),
                  child: Text(
                    '0',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Center buildBody(context) {
    final locale = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/soon.png',
            height: ScreenUtil.portrait ? ScreenUtil.screenHeightDp * .25 : ScreenUtil.screenHeightDp * .30,
          ),
          SizedBox(height: 10),
          Text(
            locale.get('soon') ?? 'COMING SOON',
            style: TextStyle(color: Color(0xff92143B), fontSize: ScreenUtil.portrait ? 20 : 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
