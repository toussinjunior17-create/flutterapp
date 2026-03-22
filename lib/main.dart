import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Gallery',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
        useMaterial3: true,
        // Assurez-vous d'ajouter une police comme 'SpaceGrotesk' dans votre pubspec.yaml
        fontFamily: 'sans-serif', 
      ),
      home: const PageOne(),
    );
  }
}

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  List<Map<String, String>> images = [
    {'id': '1', 'url': 'https://picsum.photos/seed/nature/800/600', 'title': 'Nature'},
    {'id': '2', 'url': 'https://picsum.photos/seed/city/800/600', 'title': 'City'},
    {'id': '3', 'url': 'https://picsum.photos/seed/tech/800/600', 'title': 'Tech'},
    {'id': '4', 'url': 'https://picsum.photos/seed/food/800/600', 'title': 'Food'},
    {'id': '5', 'url': 'https://picsum.photos/seed/travel/800/600', 'title': 'Travel'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Djuidje belva,toussinde idriss', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final img = images[index];
                return GestureDetector(
                  onDoubleTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => FullScreenPage(url: img['url']!),
                    ));
                  },
                  onLongPressStart: (details) {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                      ),
                      items: [
                        const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Modifier'))),
                        const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Supprimer'))),
                      ],
                    ).then((value) {
                      if (value == 'delete') {
                        setState(() => images.removeAt(index));
                      }
                    });
                  },
                  child: Hero(
                    tag: img['url']!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(img['url']!, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PageTwo()),
              ),
              icon: const Text('La page suivante'),
              label: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$count', style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w900)),
            const Text('NOMBRE DE TAPES', style: TextStyle(letterSpacing: 4, color: Colors.grey)),
            const SizedBox(height: 60),
            GestureDetector(
              onTap: () => setState(() => count++),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Center(
                  child: Text('TAPEZ MOI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenPage extends StatelessWidget {
  final String url;
  const FullScreenPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: url,
                child: Image.network(url, fit: BoxFit.contain),
              ),
            ),
            const Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text('Glissez vers le bas pour quitter', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
