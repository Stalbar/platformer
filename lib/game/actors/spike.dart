import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:platformer/game/actors/player.dart';
import 'package:platformer/game/game.dart';

class Spike extends SpriteComponent with CollisionCallbacks, HasGameRef<SimplePlatformer> {
  
  Spike(
    Image image, {
    Vector2? targetPosition,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(
          image,
          srcPosition: Vector2(0, 0),
          srcSize: Vector2.all(32),
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        );
  
  @override
  Future<void>? onLoad() {
    add(CircleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      other.hit();
      if (gameRef.playerData.health.value > 0)  {
        gameRef.playerData.health.value -= 1;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}

