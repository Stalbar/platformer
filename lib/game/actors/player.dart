import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:platformer/game/actors/platform.dart';
import 'package:platformer/game/game.dart';
import 'dart:async' as asyn;

class Player extends SpriteComponent
    with CollisionCallbacks, KeyboardHandler, HasGameRef<SimplePlatformer> {
  final Vector2 _velocity = Vector2.zero();
  int _hAxisInput = 0;
  bool _jumpInput = false;
  bool _isOnGround = false;
  bool _canBeHit = true;

  final Vector2 _up = Vector2(0, -1);
  final double _moveSpeed = 200;
  final double _gravity = 5;
  final double _jumpSpeed = 290;
  late Vector2 _minClamp;
  late Vector2 _maxClamp;

  Player(
    Image image, {
    required Rect levelBounds,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(
          image,
          srcPosition: Vector2.zero(),
          srcSize: Vector2.all(32),
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    _minClamp = levelBounds.topLeft.toVector2() + (size!);
    _maxClamp = levelBounds.bottomRight.toVector2() - (size);
  }

  @override
  void onMount() {
    gameRef.touchControls.connectPlayer(this);
    super.onMount();
  }

  @override
  Future<void>? onLoad() {
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _velocity.x = _hAxisInput * _moveSpeed;
    _velocity.y += _gravity;

    if (_jumpInput) {
      if (_isOnGround) {
        _velocity.y = -_jumpSpeed;
        _isOnGround = false;
      }
      _jumpInput = false;
    }

    _velocity.y = _velocity.y.clamp(-_jumpSpeed, 150);

    position += _velocity * dt;

    position.clamp(_minClamp, _maxClamp);

    if (_hAxisInput < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_hAxisInput > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyA) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyD) ? 1 : 0;

    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;
        final collisionNormal = absoluteCenter - mid;
        final separateDistance = (size.x / 2) - collisionNormal.length;

        collisionNormal.normalize();

        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        }

        position += collisionNormal.scaled(separateDistance);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!_canBeHit) {
      return;
    }
    if (gameRef.playerData.health.value > 0)  {
          gameRef.playerData.health.value -= 1;
    }
    _canBeHit = false;
    asyn.Timer(const Duration(milliseconds: 1000), removeInvulnerable);
    add(OpacityEffect.fadeOut(EffectController(
      alternate: true,
      duration: 0.1,
      repeatCount: 5,
    )));
  }

  void jump() {
    _jumpInput = true;
    _isOnGround = true;
  }

  set hAxisInput(int value) {
    _hAxisInput = value;
  }

  set jumpInput(bool value) {
    _jumpInput = value;
  }

  set canBeHit(bool value) {
    _canBeHit = value;
  }

  void removeInvulnerable() {
    _canBeHit = true;
  }
}
