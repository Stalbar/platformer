import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:platformer/game/hud/touch_controls.dart';
import 'package:platformer/game/model/player_data.dart';
import 'package:platformer/game/model/user.dart';



class SimplePlatformer extends FlameGame with HasTappables, HasCollisionDetection, HasKeyboardHandlerComponents {
  late Image spriteSheet;
  late Image blob;
  late Image spikes;
  late Image star;
  late Image crown;
  late Image arrows;
  late TouchControls touchControls;
  final playerData = PlayerData();

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    spriteSheet = await images.load('Spritesheet.png');
    blob = await images.load('blob_stand2.png');
    spikes = await images.load('Spike_Pixel.png');
    star = await images.load('Star.png');
    crown = await images.load('Crown spritesheet.png');
    arrows = await images.load('arrows.png');

    camera.viewport = FixedResolutionViewport(
      Vector2(640, 330),
    );
    
    return super.onLoad();
  }
}
