import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/routes/guide/GuidePageBanner.dart';
import 'package:health/routes/selfAssessment/SelfAssessmentRoute.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:health/extension/ScreenExtension.dart';

class GuideRoute extends StatefulWidget {
  static const String guideName = "/guide";

  @override
  State<StatefulWidget> createState() {
    return _GuideRouteState();
  }
}

class _GuideRouteState extends State<GuideRoute> {
  List<BannerBean> bannerData;
  final PageController _pageController = PageController();
  final PageController _pageBgController = PageController();
  var topPageOffset = 0.0;
  var screenWidth = 0.0;

  int topCurrentLeftPageIndex = 0;

  double currentPageOffsetPercent = 0;
  double bgCurrentPageOffsetPercent = 0;

  @override
  void initState() {
    bannerData = _initBannerData();
    super.initState();
    _pageController.addListener(_offsetChanged);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageBgController,
              itemBuilder: (context, index) {
                var bgCurrentLeftPageIndex = topPageOffset.floor();
                bgCurrentPageOffsetPercent =
                    topPageOffset - bgCurrentLeftPageIndex;
                return Transform.translate(
                  offset: Offset((topPageOffset - index) * screenWidth, 0),
                  child: Opacity(
                    opacity: bgCurrentLeftPageIndex == index
                        ? 1 - bgCurrentPageOffsetPercent
                        : bgCurrentPageOffsetPercent,
                    child: index == bannerData.length
                        ? _buildFeedbackGuide()
                        : Container(
                            child: Image.asset(bannerData[index].bannerUrl,
                                fit: BoxFit.cover),
                          ),
                  ),
                );
              },
              itemCount: bannerData.length + 1,
            ),
          ),
          Container(
            width: double.infinity,
            child: PageView.builder(
              itemBuilder: (context, index) {
                return _buildGuidePage(index);
              },
              itemCount: bannerData.length + 1,
              controller: _pageController,
            ),
          ),
          _buildGuideBottom()
        ],
      ),
    );
  }

  /// 初始化 banner 数据
  List<BannerBean> _initBannerData() {
    List<BannerBean> bannerList = [
      BannerBean(
          bannerUrl: "imgs/guide/introduce1.png",
          bannerTitle: "Know yourself",
          bannerDesc: "Help check your feelings, thoughts and emotions."),
      BannerBean(
          bannerUrl: "imgs/guide/introduce2.png",
          bannerTitle: "Reduce anxiety",
          bannerDesc:
              "Learn to face and cope with the our thoughts, and care for our mental health."),
      BannerBean(
          bannerUrl: "imgs/guide/introduce3.png",
          bannerTitle: "Be focus and relax",
          bannerDesc:
              "Natural sounds and deep breathing exercises let go of all the tension in your body."),
    ];
    return bannerList;
  }

  Widget _buildGuidePage(int index) {
    if (index == 3) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 225.pt),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.pt, horizontal: 26.pt),
              child: Text(
                "We are still at an early stage of developing FLOW. Your feedback is greatly appreciated and very important to us. Free feel to try it out any time. Also, stay tune for more amazing features.😃",
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(leading: 1.4),
                style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 16.pt,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 225.pt),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.pt),
            child: Text(
              bannerData[index].bannerTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.pt,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.pt),
            child: Text(
              bannerData[index].bannerDesc,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.pt,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  _buildGuideBottom() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 111.pt),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 31.pt),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: bannerData.length + 1,
                effect: SwapEffect(
                    dotColor: Colors.white.withOpacity(0.2),
                    activeDotColor: Colors.white,
                    dotHeight: 8.pt,
                    dotWidth: 8.pt,
                    spacing: 9.pt),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xFF6F86FF))),
              onPressed: onNext,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 30.pt, vertical: 8.pt),
                child: Text(
                  "Get started",
                  style: TextStyle(
                      fontSize: 20.pt,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _offsetChanged() {
    setState(() {
      topPageOffset = _pageController.offset / screenWidth;
      _pageBgController.jumpTo(_pageController.offset);
    });
  }

  void onNext() {
    Navigator.of(context).pop();
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return SelfAssessmentRoute();
        },
        settings: RouteSettings()));
  }

  _buildFeedbackGuide() {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imgs/splash/bg_splash.jpg"),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.pt),
                    child: Image.asset(
                      "imgs/appicon/ic_launcher_512x512.png",
                      height: 90.pt,
                      width: 90.pt,
                    )),
              ),
              flex: 8,
            ),
            Expanded(
              child: Container(),
              flex: 5,
            )
          ],
        ));
  }
}
