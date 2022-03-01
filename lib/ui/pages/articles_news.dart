import 'package:flutter/material.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/core/models/newsarticles.dart';
import 'package:qatarcyclists/ui/pages/article_page.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:html/parser.dart' show parse;

class ArticlesNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseWidget<ArticlesNewsModel>(
          initState: (m) => m.getNewsArticles(context),
          model: ArticlesNewsModel(
            local: AppLocalizations.of(context),
            api: Provider.of(context),
            auth: Provider.of(context),
          ),
          builder: (context, model, _) {
            return FocusWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // app bar.
                  buildHeaderColor(context),
                  // image & title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      locale.get('Articles & News') ?? 'Articles & News',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey[600],
                          fontSize: 15),
                    ),
                  ),
                  model.busy
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(child: listCard(context, model))
                ],
              ),
            );
          }),
    );
  }

  Widget listCard(BuildContext context, ArticlesNewsModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: model.newsArticles.responsee.result.data.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                UI.push(
                    context,
                    ArticlePage(
                      content:
                          model.newsArticles.responsee.result.data[i].content,
                      date: model.newsArticles.responsee.result.data[i].dateTime
                          .substring(0, 11),
                      title: model.newsArticles.responsee.result.data[i].title,
                      image: model
                          .newsArticles.responsee.result.data[i].media[0].url,
                    ));
              },
              child: Card(
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          model.newsArticles.responsee.result.data[i].media[0]
                              .url,
                          fit: BoxFit.cover,
                          height: 100.0,
                          width: 150.0,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.newsArticles.responsee.result.data[i]
                                    .title,
                                maxLines: 2,
                                style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                model.newsArticles.responsee.result.data[i]
                                    .dateTime
                                    .substring(0, 11),
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                parse(model.newsArticles.responsee.result
                                        .data[i].content)
                                    .body
                                    .text
                                    .substring(0, 250),
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      'Read more',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.secondaryText),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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

class ArticlesNewsModel extends BaseNotifier {
  AppLocalizations local;
  NewsArticlesModel newsArticles;
  final HttpApi api;
  final AuthenticationService auth;

  ArticlesNewsModel({this.local, this.api, this.auth}) {}

  getNewsArticles(context) async {
    setBusy();
    try {
      newsArticles = await api.getNewsArticles(context);
      print("News and Articles");
      print(newsArticles.responsee.result.data.length);
    } catch (e) {
      setError();
    }
    setIdle();
  }
}
