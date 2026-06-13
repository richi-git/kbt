import 'package:flutter/material.dart';
import 'package:praktikum_1/service/leaderboard_service.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/service/language_service.dart';

class GameDialogHelper {
  static final LanguageService _lang = LanguageService();
  static String _t(String key) => _lang.translate('dialog', key);

  static void showWinDialog(BuildContext context, {int score = 0}) {
    if (score > 0) {
      LeaderboardService().saveScore(GameConfig.username, score);
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(_t('win_title'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.green)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_t('win_content'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text("${_t('win_score')}$score",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            child: Text(_t('win_button'),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  static void showLoseDialog(BuildContext context, String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(_t('lose_title'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.red)),
        content: Text("$reason${_t('lose_content')}",
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            child: Text(_t('lose_button'),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  static void showPauseMenu(BuildContext context,
      {required VoidCallback onResume, required VoidCallback onRestart}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.only(
                    top: 60, bottom: 24, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blue[200]!, width: 4),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        offset: Offset(0, 5)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.menu_book_rounded,
                              size: 60, color: Colors.white),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _t('pause_status'),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black26,
                                          offset: Offset(2, 2),
                                          blurRadius: 2)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _t('pause_subtitle'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildPauseButton(
                          _t('resume'),
                          Colors.green,
                          Colors.lightGreen,
                          () {
                            Navigator.of(context).pop();
                            onResume();
                          },
                        ),
                        _buildPauseButton(
                          _t('restart'),
                          Colors.blue,
                          Colors.lightBlue,
                          () {
                            Navigator.of(context).pop();
                            onRestart();
                          },
                        ),
                        _buildPauseButton(
                          _t('home'),
                          Colors.orange,
                          Colors.orangeAccent,
                          () => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.yellow[600]!, width: 4),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black45,
                          blurRadius: 8,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Text(
                    _t('pause_title'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.yellow,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 4)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildPauseButton(String text, MaterialColor baseColor,
      Color topColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: baseColor[600],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(color: baseColor[900]!, offset: const Offset(0, 4)),
            const BoxShadow(
                color: Colors.black26, offset: Offset(0, 6), blurRadius: 4),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black38, offset: Offset(1, 1), blurRadius: 2)
            ],
          ),
        ),
      ),
    );
  }
}
