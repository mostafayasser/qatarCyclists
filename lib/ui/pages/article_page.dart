import 'package:flutter/material.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:html/parser.dart' show parse;

class ArticlePage extends StatelessWidget {
  String date;
  String title;
  String content;
  String image;
  ArticlePage({this.content, this.date, this.title, this.image});

  @override
  Widget build(BuildContext context) {
    var document = parse(content);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseWidget<ArticlePageModel>(
          model: ArticlePageModel(
            local: AppLocalizations.of(context),
          ),
          builder: (context, model, _) {
            return SingleChildScrollView(
              child: FocusWidget(
                child: Column(
                  children: [
                    // app bar.
                    buildHeaderColor(context),

                    Stack(
                      children: <Widget>[
                        // image & title
                        Container(
                          child: Image.network(image),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        date,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.normal,
                                            fontSize: 10),
                                      ),
                                      // Container(
                                      //     width: 20,
                                      //     height: 20,
                                      //     child: Image.asset(
                                      //         'assets/images/article.png')),
                                    ],
                                  ),
                                  Text(
                                    title,
                                    style: TextStyle(
                                        color: AppColors.secondaryText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  Expanded(
                                    child: ListView(
                                      children: [Text(document.body.text)],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            width: 300,
                            height: 500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Container buildLoadingScreen(context) {
    return Container(
      width: ScreenUtil.screenWidthDp,
      height: ScreenUtil.screenHeightDp,
      child: Column(
        children: <Widget>[
          buildHeaderColor(context),
          Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  // Header color & icon.
  HeaderColor buildHeaderColor(context) {
    final locale = AppLocalizations.of(context);

    return HeaderColor(
      hasTitle: true,
      title: locale.get('Articles & News') ?? 'Articles & News',
      //titleImage: 'profile_bar.png',
      titleImageColor: AppColors.accentElement,
      hasBack: true,
    );
  }
}

class ArticlePageModel extends BaseNotifier {
  AppLocalizations local;

  ArticlePageModel({this.local}) {}
}
