import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/animation.dart';
import 'package:platformer/game/actors/player.dart';
import 'package:platformer/game/game.dart';

class Crown extends SpriteComponent with CollisionCallbacks, HasGameRef<SimplePlatformer> {
  Crown(
    Image image, {
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

    add(
      MoveEffect.by(
        Vector2(0, -7), 
        EffectController(
          alternate: true,
          infinite: true,
          duration: 1,
          curve: Curves.ease
        )
      )
    );

    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      add(
        OpacityEffect.fadeOut(
          LinearEffectController(0.3),
          onComplete: () {
            add(RemoveEffect());
          },        
        )
      );

      gameRef.playerData.score.value += 10;
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}