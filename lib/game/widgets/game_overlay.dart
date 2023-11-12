// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../doodle_dash.dart';
import 'widgets.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;
  TouchState state = TouchState.NONE;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onPanDown: (details) {
                move(context, details.localPosition.dx);
              },
              onPanUpdate: (details) {
                move(context, details.localPosition.dx);
              },
              onPanEnd: (details) {
                stop();
              },
              onPanCancel: () {
                stop();
              },
            ),
          ),
          Positioned(
            top: 30,
            left: 30,
            child: ScoreDisplay(game: widget.game),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
              child: isPaused
                  ? const Icon(
                      Icons.play_arrow,
                      size: 48,
                    )
                  : const Icon(
                      Icons.pause,
                      size: 48,
                    ),
              onPressed: () {
                (widget.game as DoodleDash).togglePauseState();
                setState(
                  () {
                    isPaused = !isPaused;
                  },
                );
              },
            ),
          ),
          if (isPaused)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 72.0,
              right: MediaQuery.of(context).size.width / 2 - 72.0,
              child: const Icon(
                Icons.pause_circle,
                size: 144.0,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }

  void stop() {
    (widget.game as DoodleDash).player.resetDirection();
    state = TouchState.NONE;
  }

  void move(BuildContext context, double touchX) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (touchX < screenWidth / 2) {
      if(state == TouchState.LEFT) return;
      (widget.game as DoodleDash).player.moveLeft();
      state = TouchState.LEFT;
    } else {
      if(state == TouchState.RIGHT) return;
      (widget.game as DoodleDash).player.moveRight();
      state = TouchState.RIGHT;
    }
  }

}

enum TouchState {
  NONE, LEFT, RIGHT;
}
