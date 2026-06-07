import 'package:flutter/material.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/service/audio_service.dart';
import 'package:praktikum_1/service/language_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final LanguageService _lang = LanguageService();
  double _currentVolume = GameConfig.volume;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _nameController.text = GameConfig.username;
    _selectedLanguage = _lang.currentLanguage;
  }

  String _t(String key) => _lang.translate('settings', key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_card_city.png'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _t('title'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // USERNAME
                        Text(
                          _t('username'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: _t('hint'),
                            filled: true,
                            fillColor: Colors.blue[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.person, color: Colors.blue),
                          ),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // VOLUME
                        Text(
                          _t('volume'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _currentVolume > 0 ? Icons.volume_up : Icons.volume_off,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_currentVolume > 0) {
                                    _currentVolume = 0;
                                  } else {
                                    _currentVolume = 0.5;
                                  }
                                });
                                GameConfig.volume = _currentVolume;
                                AudioService.updateVolume();
                              },
                            ),
                            Expanded(
                              child: Slider(
                                value: _currentVolume,
                                onChanged: (value) {
                                  setState(() {
                                    _currentVolume = value;
                                  });
                                  GameConfig.volume = value;
                                  AudioService.updateVolume();
                                },
                                activeColor: Colors.blueAccent,
                                inactiveColor: Colors.blue[100],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        
                        // BGM TOGGLE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "MUSIK LATAR (BGM)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Switch(
                              value: _currentVolume > 0,
                              onChanged: (value) {
                                setState(() {
                                  _currentVolume = value ? 0.5 : 0.0;
                                });
                                GameConfig.volume = _currentVolume;
                                AudioService.updateVolume();
                                AudioService.toggleBGM(value);
                              },
                              activeColor: Colors.blueAccent,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // LANGUAGE
                        Text(
                          _t('language'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildLanguageOption("Bahasa Indonesia", "id"),
                            const SizedBox(width: 12),
                            _buildLanguageOption("English", "en"),
                          ],
                        ),

                        const SizedBox(height: 48),

                        // SAVE BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_nameController.text.trim().isNotEmpty) {
                                GameConfig.username = _nameController.text.trim();
                                GameConfig.volume = _currentVolume;
                                GameConfig.language = _selectedLanguage;
                                _lang.changeLanguage(_selectedLanguage);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_t('success')),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              _t('save'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String label, String code) {
    bool isSelected = _selectedLanguage == code;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLanguage = code;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.blue[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.blue[100]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
