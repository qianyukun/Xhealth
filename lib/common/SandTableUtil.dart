import 'package:health/routes/sandTable/SandTableScene.dart';

class SandTableSceneUtil {
  static List<SandTableScene> _sandTableScenes = [];

  SandTableSceneUtil._();

  static SandTableSceneUtil? _instance;

  static SandTableSceneUtil getInstance() {
    if (_instance == null) {
      _instance = SandTableSceneUtil._();
    }
    return _instance!;
  }

  Future<List<SandTableScene>> getSandTableScenes() async {
    if (_sandTableScenes.length == 0) {
      _sandTableScenes = [
        SandTableScene(
            id: 1,
            sourceId: "oh-cards-4",
            imgUrl: "imgs/sandtable/ohcards_l_4.png",
            sceneName: "Fragment"),
        SandTableScene(
            id: 2,
            sourceId: "oh-cards-10",
            imgUrl: "imgs/sandtable/ohcards_l_10.png",
            sceneName: "Monster"),
        SandTableScene(
            id: 3,
            sourceId: "oh-cards-14",
            imgUrl: "imgs/sandtable/ohcards_l_14.png",
            sceneName: "Uwirl"),
        SandTableScene(
            id: 4,
            sourceId: "oh-cards-15",
            imgUrl: "imgs/sandtable/ohcards_l_15.png",
            sceneName: "Burden horse"),
        SandTableScene(
            id: 5,
            sourceId: "oh-cards-20",
            imgUrl: "imgs/sandtable/ohcards_l_20.png",
            sceneName: "Stake stie"),
        SandTableScene(
            id: 6,
            sourceId: "oh-cards-23",
            imgUrl: "imgs/sandtable/ohcards_l_23.png",
            sceneName: "Lonely people"),
        SandTableScene(
            id: 7,
            sourceId: "oh-cards-63",
            imgUrl: "imgs/sandtable/ohcards_l_63.png",
            sceneName: "Split people"),
        SandTableScene(
            id: 8,
            sourceId: "oh-cards-88",
            imgUrl: "imgs/sandtable/ohcards_l_88.png",
            sceneName: "Crown")
      ];
    }
    return _sandTableScenes;
  }

  SandTableScene getSandTableSceneById(int id) {
    if (_sandTableScenes.length == 0) {
      getSandTableScenes();
    }

    for (SandTableScene sandTableScene in _sandTableScenes) {
      if (sandTableScene.id == id) {
        return sandTableScene;
      }
    }
    return _sandTableScenes[0];
  }
}
