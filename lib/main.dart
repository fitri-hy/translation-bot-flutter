import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String _selectedLanguage = 'en';

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xffffffff),
        ),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xfff1f5f9),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
        ),
      ),
      themeMode: _themeMode,
      home: MyHomePage(
        title: 'Translation Bot',
        toggleTheme: _toggleTheme,
        selectedLanguage: _selectedLanguage,
        changeLanguage: _changeLanguage,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.toggleTheme,
    required this.selectedLanguage,
    required this.changeLanguage,
  }) : super(key: key);

  final String title;
  final VoidCallback toggleTheme;
  final String selectedLanguage;
  final void Function(String) changeLanguage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://i-as.dev/api/translate?text=${Uri.encodeComponent(message)}&target=${widget.selectedLanguage}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final String translatedText = jsonResponse['translation'] ?? 'Translation not available';
      setState(() {
        _messages.add({'sender': 'bot', 'text': translatedText});
        _isLoading = false;
      });
    } else {
      setState(() {
        _messages.add({'sender': 'bot', 'text': 'Failed to get response. Try again.'});
        _isLoading = false;
      });
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: widget.toggleTheme,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                final int itemIndex = _messages.length - index - 1;
                if (_isLoading && index == _messages.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final message = _messages[itemIndex];
                return Align(
                  alignment: message['sender'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'user' ? Color(0xffffffff) : Color(0xffc7d2fe),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: TextStyle(color: Color(0xff000000)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.language),
                  onSelected: (String language) {
                    widget.changeLanguage(language);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
					  value: 'en',
					  child: Text('English'),
					),
					PopupMenuItem<String>(
					  value: 'id',
					  child: Text('Indonesian'),
					),
					PopupMenuItem<String>(
					  value: 'es',
					  child: Text('Spanish'),
					),
					PopupMenuItem<String>(
					  value: 'fr',
					  child: Text('French'),
					),
					PopupMenuItem<String>(
					  value: 'de',
					  child: Text('German'),
					),
					PopupMenuItem<String>(
					  value: 'zh',
					  child: Text('Chinese'),
					),
					PopupMenuItem<String>(
					  value: 'ja',
					  child: Text('Japanese'),
					),
					PopupMenuItem<String>(
					  value: 'ru',
					  child: Text('Russian'),
					),
					PopupMenuItem<String>(
					  value: 'ko',
					  child: Text('Korean'),
					),
					PopupMenuItem<String>(
					  value: 'ar',
					  child: Text('Arabic'),
					),
					PopupMenuItem<String>(
					  value: 'pt',
					  child: Text('Portuguese'),
					),
					PopupMenuItem<String>(
					  value: 'it',
					  child: Text('Italian'),
					),
					PopupMenuItem<String>(
					  value: 'hi',
					  child: Text('Hindi'),
					),
					PopupMenuItem<String>(
					  value: 'bn',
					  child: Text('Bengali'),
					),
					PopupMenuItem<String>(
					  value: 'pa',
					  child: Text('Punjabi'),
					),
					PopupMenuItem<String>(
					  value: 'ur',
					  child: Text('Urdu'),
					),
					PopupMenuItem<String>(
					  value: 'vi',
					  child: Text('Vietnamese'),
					),
					PopupMenuItem<String>(
					  value: 'tr',
					  child: Text('Turkish'),
					),
					PopupMenuItem<String>(
					  value: 'fa',
					  child: Text('Persian'),
					),
					PopupMenuItem<String>(
					  value: 'pl',
					  child: Text('Polish'),
					),
					PopupMenuItem<String>(
					  value: 'nl',
					  child: Text('Dutch'),
					),
					PopupMenuItem<String>(
					  value: 'th',
					  child: Text('Thai'),
					),
					PopupMenuItem<String>(
					  value: 'ms',
					  child: Text('Malay'),
					),
					PopupMenuItem<String>(
					  value: 'sw',
					  child: Text('Swahili'),
					),
					PopupMenuItem<String>(
					  value: 'ta',
					  child: Text('Tamil'),
					),
					PopupMenuItem<String>(
					  value: 'te',
					  child: Text('Telugu'),
					),
					PopupMenuItem<String>(
					  value: 'mr',
					  child: Text('Marathi'),
					),
					PopupMenuItem<String>(
					  value: 'kn',
					  child: Text('Kannada'),
					),
					PopupMenuItem<String>(
					  value: 'gu',
					  child: Text('Gujarati'),
					),
					PopupMenuItem<String>(
					  value: 'ml',
					  child: Text('Malayalam'),
					),
					PopupMenuItem<String>(
					  value: 'or',
					  child: Text('Odia'),
					),
					PopupMenuItem<String>(
					  value: 'as',
					  child: Text('Assamese'),
					),
					PopupMenuItem<String>(
					  value: 'sd',
					  child: Text('Sindhi'),
					),
					PopupMenuItem<String>(
					  value: 'am',
					  child: Text('Amharic'),
					),
					PopupMenuItem<String>(
					  value: 'ne',
					  child: Text('Nepali'),
					),
					PopupMenuItem<String>(
					  value: 'si',
					  child: Text('Sinhala'),
					),
					PopupMenuItem<String>(
					  value: 'my',
					  child: Text('Burmese'),
					),
					PopupMenuItem<String>(
					  value: 'km',
					  child: Text('Khmer'),
					),
					PopupMenuItem<String>(
					  value: 'lo',
					  child: Text('Lao'),
					),
					PopupMenuItem<String>(
					  value: 'mn',
					  child: Text('Mongolian'),
					),
					PopupMenuItem<String>(
					  value: 'jv',
					  child: Text('Javanese'),
					),
					PopupMenuItem<String>(
					  value: 'su',
					  child: Text('Sundanese'),
					),
					PopupMenuItem<String>(
					  value: 'tl',
					  child: Text('Tagalog'),
					),
					PopupMenuItem<String>(
					  value: 'cy',
					  child: Text('Welsh'),
					),
					PopupMenuItem<String>(
					  value: 'gd',
					  child: Text('Scottish Gaelic'),
					),
					PopupMenuItem<String>(
					  value: 'ga',
					  child: Text('Irish'),
					),
					PopupMenuItem<String>(
					  value: 'mt',
					  child: Text('Maltese'),
					),
					PopupMenuItem<String>(
					  value: 'is',
					  child: Text('Icelandic'),
					),
					PopupMenuItem<String>(
					  value: 'hy',
					  child: Text('Armenian'),
					),
					PopupMenuItem<String>(
					  value: 'az',
					  child: Text('Azerbaijani'),
					),
					PopupMenuItem<String>(
					  value: 'kk',
					  child: Text('Kazakh'),
					),
					PopupMenuItem<String>(
					  value: 'uz',
					  child: Text('Uzbek'),
					),
                  ],
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your text ...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
