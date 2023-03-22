import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:platformer/game/actors/fast_enemy.dart';
import 'package:platformer/game/actors/player.dart';
import 'package:platformer/game/actors/spike.dart';
import 'package:platformer/game/game.dart';
import 'package:tiled/tiled.dart';

import '../actors/coin.dart';
import '../actors/crown.dart';
import '../actors/door.dart';
import '../actors/enemy.dart';
import '../actors/platform.dart';
import '../actors/star.dart';
import '../game_play.dart';

class Level extends Component with HasGameRef<SimplePlatformer>, ParentIsA<GamePlay> {
  final String levelName;
  late Player _player;
  late Rect _levelBounds;

  Level(this.levelName) : super();

  @override
  Future<void>? onLoad() async {
    final level = await TiledComponent.load(
      levelName,
      Vector2.all(32)
    );
    add(level);

    _levelBounds = Rect.fromLTWH(
      0, 
      0,
      (level.tileMap.map.width * level.tileMap.map.tileWidth).toDouble(),
      (level.tileMap.map.height * level.tileMap.map.tileHeight).toDouble(),
    );

    _spawnActors(level.tileMap);
    _setupCamera();

    return super.onLoad();
  }

  void _spawnActors(RenderableTiledMap tileMap) {
    final platformsLayer = tileMap.getLayer<ObjectGroup>('Platforms');

    for (final platfromObject in platformsLayer!.objects) {
      final platform = Platform(
        position: Vector2(platfromObject.x, platfromObject.y),
        size: Vector2(platfromObject.width, platfromObject.height),
      );
      add(platform);
    }

    final spawnPointsLayer = tileMap.getLayer<ObjectGroup>('SpawnPoints');
    
    for (final spawnPoint in spawnPointsLayer!.objects) {
      final position = Vector2(spawnPoint.x, spawnPoint.y - spawnPoint.height);
      switch (spawnPoint.type) {
        case 'Player':
          _player = Player(
            gameRef.spriteSheet,
            position: position,
            size: Vector2(spawnPoint.width, spawnPoint.height),
            levelBounds: _levelBounds,
            anchor: Anchor.center,
          );
          add(_player);
          break;
        case 'Coin':
          final coin = Coin(
            gameRef.spriteSheet,
            position: position,
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(coin);
          break;
        case 'Enemy':
          final targetObjectId = int.parse(spawnPoint.properties.first.value);
          final target = spawnPointsLayer.objects
                  .firstWhere((element) => element.id == targetObjectId);
          final enemy = Enemy(
            gameRef.spriteSheet,
            position: position,
            size: Vector2(spawnPoint.width, spawnPoint.height),
            targetPosition: Vector2(target.x, target.y),
          );
          add(enemy);
          break;
        case 'FastEnemy':
          final targetObjectId = int.parse(spawnPoint.properties.first.value);
          final target = spawnPointsLayer.objects
                    .firstWhere((element) => element.id == targetObjectId);
          final fastEnemy = FastEnemy(
            gameRef.blob,
            position: position,
            size: Vector2(spawnPoint.width, spawnPoint.height),
            targetPosition: Vector2(target.x, target.y),
          );
          add(fastEnemy);
          break;
        case 'Spike':
          final spike = Spike(
            gameRef.spikes,
            position: position,
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(spike);
          break;
        case 'Door': 
          final door = Door(
            gameRef.spriteSheet,
            position: position,
            size: Vector2(spawnPoint.width, spawnPoint.height),
            onPlayerEnter: () {
              parent.loadLevel(spawnPoint.properties.first.value);
            }
          );
          add(door);
          break;
        case 'Crown':
          final crown = Crown(
            gameRef.crown,
            position: position,
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(crown);
          break;
        case 'Star':
          final star = Star(
            gameRef.star,
            position: position,
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(star);
          break;
      } 
    }
  }

  void _setupCamera() {
    gameRef.camera.followComponent(_player);
    gameRef.camera.worldBounds = _levelBounds;
  }
}