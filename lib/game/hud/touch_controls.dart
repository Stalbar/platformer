import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';

import '../actors/player.dart';

class TouchControls extends HudMarginComponent {
  Player? _player;
  Image arrows;

  TouchControls(
      this.arrows,
      {EdgeInsets? margin,
      Vector2? position,
      Vector2? size,
      Vector2? scale,
      double? angle,
      Anchor? anchor,
      Iterable<Component>? children,
      int? priority})
      : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          children: children,
          priority: priority,
        );

  void connectPlayer(Player player) {
    _player = player;
  }

  @override
  Future<void> onLoad() {
    const offset = 10.0;

    final leftButton = HudButtonComponent(
        button: SpriteComponent.fromImage(
          arrows,
          srcPosition: Vector2(200, 200),
          srcSize: Vector2.all(160),
          size: Vector2.all(60),
        ),
        buttonDown: SpriteComponent.fromImage(
          arrows,
          srcPosition: Vector2(200, 200),
          srcSize: Vector2.all(160),
          size: Vector2.all(60),
        ),
        margin: const EdgeInsets.only(bottom: offset, left: offset),
        onPressed: () {
          _player?.hAxisInput = -1;
        },
        onReleased: () {
          _player?.hAxisInput = 0;
        });
    add(leftButton);

    final rightButton = HudButtonComponent(
        button: SpriteComponent.fromImage(
          arrows,
          srcPosition: Vector2(0, 200),
          srcSize: Vector2.all(160),
          size: Vector2.all(60),
        ),
        buttonDown: SpriteComponent.fromImage(
          arrows,
          srcPosition: Vector2(0, 200),
          srcSize: Vector2.all(160),
          size: Vector2.all(60),
        ),
        position: Vector2(
          leftButton.position.x + leftButton.size.x + 15,
          leftButton.position.y,
        ),
        onPressed: () {
          _player?.hAxisInput = 1;
        },
        onReleased: () {
          _player?.hAxisInput = 0;
        });
    add(rightButton);

    final jumpButton = HudButtonComponent(
        button: SpriteComponent.fromImage(
          arrows,
          srcPosition: Vector2(0, 400),
          srcSize: Vector2.all(160),
          size: Vector2.all(60),
        ),
        buttonDown: SpriteComponent.fromImage(
          arrows,
          srcPosition: Vector2(0, 400),
          srcSize: Vector2.all(160),
          size: Vector2.all(60),
        ),
        margin: const EdgeInsets.only(bottom: offset, right: offset + 15),
        onPressed: () {
          _player?.jumpInput = true;
        },
        onReleased: () {
          _player?.jumpInput = false;
        });
    add(jumpButton);

    return super.onLoad();
  }
}
