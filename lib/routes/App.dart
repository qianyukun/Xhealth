import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/db/DbHelper.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/res/strings/CustomLocalizationsDelegates.dart';
import 'package:health/res/strings/StringLocalizations.dart';
import 'package:health/routes/breath/BreathRoute.dart';
import 'package:health/routes/guide/GuideRoute.dart';
import 'package:health/routes/sound/SoundRoute.dart';
import 'package:health/routes/breath/BreatheFeelingCheck.dart';
import 'package:health/routes/breath/BreatheResult.dart';
import 'package:provider/provider.dart';

import 'sandTable/SandTableDetailRoute.dart';
import 'selfAssessment/SelfAssessmentRoute.dart';
import 'HomeRoute.dart';
import 'SplashRoute.dart';
import 'sandTable/SandTableRoute.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DbHelper(),
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [
          ReportUtil.getInstance().firebaseAnalyticsObserver
        ],
        localizationsDelegates: [
          // 本地化的代理类
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          CustomLocalizationsDelegates.delegate,
        ],
        locale: Locale('en', 'US'),
        supportedLocales: [
          const Locale('en', 'US'), // 美国英语
        ],

        ///当传入的是不支持的语种，可以根据这个回调，返回相近,并且支持的语种
        localeResolutionCallback: (local, support) {
          ///当前软件支行的语言 也就是[supportedLocales] 中配制的语种
          if (support.contains(local)) {
            return local;
          }

          ///返回一种默认的语言环境
          return const Locale('en', 'US');
        },
        onGenerateTitle: (context) {
          return StringLocalizations.of(context)?.appName;
        },
        theme: ThemeData(
          primaryColor: Color(0xFF6F86FF),
        ),
        home: SplashRoute(),
        routes: <String, WidgetBuilder>{
          SplashRoute.splashName: (context) => SplashRoute(),
          GuideRoute.guideName: (context) => GuideRoute(),
          HomeRoute.homeName: (context) => HomeRoute(),
          SelfAssessmentRoute.selfAssessmentName: (context) =>
              SelfAssessmentRoute(),
          SandTableRoute.sandTableName: (context) => SandTableRoute(),
          SandTableDetailRoute.sandTableDetailName: (context) =>
              SandTableDetailRoute(),
          BreathRoute.breathRouteName: (context) => BreathRoute(),
          BreatheFeelingCheck.breatheFeelingCheckName: (context) =>
              BreatheFeelingCheck(),
          BreatheResult.breatheResultName: (context) => BreatheResult(),
          SoundRoute.soundName: (context) => SoundRoute(),
        },
      ),
    );
  }
}
