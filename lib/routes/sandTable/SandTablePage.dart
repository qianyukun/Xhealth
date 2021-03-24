import 'package:flutter/material.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/common/SandTableUtil.dart';
import 'package:health/db/DbHelper.dart';
import 'package:health/report/ReportUtil.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:health/routes/sandTable/SandTableDetailRoute.dart';
import 'package:health/routes/sandTable/SandTableScene.dart';
import 'package:provider/provider.dart';
import 'package:health/extension/ScreenExtension.dart';

class SandTablePage extends StatefulWidget {
  int moodCheckId;

  SandTablePage(this.moodCheckId);

  @override
  State<StatefulWidget> createState() {
    return _SandTablePageState();
  }
}

class _SandTablePageState extends State<SandTablePage> {
  int selectedIndex = -1;
  List<SandTableScene> scenes = [];
  Future<List<SandTableScene>> futureSandTableScenes;

  DbHelper get dbHelper => Provider.of<DbHelper>(context, listen: false);

  PageController _pageController = PageController(viewportFraction: 0.5);

  @override
  void initState() {
    super.initState();
    futureSandTableScenes = initSandTableScenes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imgs/bg/bg_guide.jpg"), fit: BoxFit.fitWidth),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: 52.pt, left: 38.pt, right: 38.pt, bottom: 51),
                  child: Text(
                    "These thoughts look like?",
                    style: TextStyle(
                        fontSize: 20.pt,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w400),
                  ),
                ),
                flex: 2,
              ),
              FutureBuilder<List<SandTableScene>>(
                  future: futureSandTableScenes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      scenes = snapshot.data ?? [];
                      return Container(
                        height: 249.pt,
                        alignment: Alignment.center,
                        child: PageView.builder(
                          controller: _pageController,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildPageItem(index);
                          },
                          itemCount: scenes.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      );
                    } else {
                      return Align();
                    }
                  }),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder()),
                      backgroundColor: selectedIndex != -1
                          ? MaterialStateProperty.all(Color(0xFF6F86FF))
                          : MaterialStateProperty.all(Color(0xFFDDDEE4)),
                    ),
                    onPressed: selectedIndex != -1 ? _onNext : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.pt, vertical: 10.pt),
                      child: Text(
                        "That's it",
                        style: TextStyle(
                            fontSize: 20.pt,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildPageItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedIndex == index) {
            selectedIndex = -1;
          } else {
            selectedIndex = index;
            Map<String, dynamic> map = Map();
            map.putIfAbsent("card", () => scenes[selectedIndex].sceneName);
            ReportUtil.getInstance().trackEvent(
                eventName: EventConstants.cards_choose, parameters: map);
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutQuart);
          }
        });
      },
      child: Hero(
        tag: scenes[index].sceneName,
        child: Card(
          elevation: 4,
          shadowColor: Colors.black26,
          margin: EdgeInsets.symmetric(horizontal: 10.2.pt, vertical: 8.pt),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10.pt)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(
                child: Image.asset(scenes[index].imgUrl),
              ),
              Container(
                color: selectedIndex == -1
                    ? null
                    : selectedIndex == index
                        ? null
                        : Colors.white.withOpacity(0.5),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<SandTableScene>> initSandTableScenes() {
    return SandTableSceneUtil.getInstance().getSandTableScenes();
  }

  _onNext() async {
    if (widget.moodCheckId != null) {
      var entity = await dbHelper.queryMoodCheckById(widget.moodCheckId).first;
      entity.sandTableSceneId = scenes[selectedIndex].id;
      dbHelper.updateMoodCheck(entity);
      Map<String, dynamic> map = Map();
      map.putIfAbsent("moodCheckId", () => widget.moodCheckId);
      map.putIfAbsent("scene", () => scenes[selectedIndex]);
      Navigator.of(context).pop();
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return SandTableDetailRoute();
          },
          transitionDuration: Duration(seconds: 2),
          settings: RouteSettings(arguments: map)));

      ReportUtil.getInstance().trackEvent(eventName: EventConstants.cards_next);
    }
  }
}
