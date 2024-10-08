import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gallery_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GalleryProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Image Gallery',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GalleryScreen(),
      ),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final galleryProvider = Provider.of<GalleryProvider>(context, listen: false);
    galleryProvider.fetchImages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !galleryProvider.isLoading) {
        galleryProvider.fetchImages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
      ),
      body: Consumer<GalleryProvider>(
        builder: (context, galleryProvider, child) {
          return GridView.builder(
            controller: _scrollController,
            itemCount: galleryProvider.images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) {
              final image = galleryProvider.images[index];
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        image['webformatURL'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Likes: ${image['likes']}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Views: ${image['views']}'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
