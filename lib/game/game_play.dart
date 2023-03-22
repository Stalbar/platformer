import 'package:flame/components.dart';
import 'package:platformer/game/game.dart';

import 'hud/hud.dart';
import 'hud/touch_controls.dart';
import 'level/level.dart';
import 'model/user.dart';

class GamePlay extends Component with HasGameRef<SimplePlatformer> {
  Level? _currentLevel;

  final hud = Hud(priority: 1);
  final String username;
  GamePlay({required this.username});

  @override
  Future<void>? onLoad() async {
    loadLevel('Level1.tmx');
    await gameRef.add(hud);
    gameRef.touchControls = TouchControls(gameRef.arrows, position: Vector2.zero(), priority: 1);
    gameRef.add(gameRef.touchControls);
    gameRef.playerData.score.value = 0;
    gameRef.playerData.health.value = 3;
    gameRef.playerData.userName = username;
    return super.onLoad();
  }

  @override
  void onRemove() {
    gameRef.remove(hud);
    super.onRemove();
  }

  
  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }
}