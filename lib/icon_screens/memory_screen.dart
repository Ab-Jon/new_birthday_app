import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
part 'memory_screen.g.dart'; // Hive type adapter

@HiveType(typeId: 0)
class Album extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> imagePaths;

  Album({required this.name, List<String>? imagePaths})
      : imagePaths = imagePaths ?? [];

  List<File> get images => imagePaths.map((path) => File(path)).toList();
}

class MemoryGalleryScreen extends StatefulWidget {
  const MemoryGalleryScreen({super.key});

  @override
  State<MemoryGalleryScreen> createState() => _MemoryGalleryScreenState();
}

class _MemoryGalleryScreenState extends State<MemoryGalleryScreen> {
  late Box<Album> _albumBox;
  bool _isBoxReady = false;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _albumBox = await Hive.openBox<Album>('albums');
    setState(() {
      _isBoxReady = true;
    });
  }

  void _createAlbum() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Album'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter album name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                final newAlbum = Album(name: name);
                _albumBox.add(newAlbum);
                setState(() {

                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _openAlbum(Album album) async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AlbumViewScreen(album: album),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  void _renameAlbum(Album album) async {
    final controller = TextEditingController(text: album.name);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Album'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new album name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                album.name = name;
                await album.save();
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _deleteAlbum(Album album) async {
    await album.delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBoxReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final albums = _albumBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Memory Gallery')),
      body: albums.isEmpty
          ? const Center(child: Text('No Albums Yet'),)
          : GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(12),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: albums.map((album) {
              return GestureDetector(
                onTap: () => _openAlbum(album),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: album.images.isNotEmpty
                            ? Image.file(album.images.first, fit: BoxFit.cover)
                            : Container(color: Colors.grey.shade300),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              album.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _renameAlbum(album),
                                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                                ),
                                IconButton(
                                  onPressed: () => _deleteAlbum(album),
                                  icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _createAlbum,
        child: const Icon(Icons.add,
        color: Colors.white,),
      ),
    );
  }
}

class AlbumViewScreen extends StatefulWidget {
  final Album album;
  const AlbumViewScreen({super.key, required this.album});

  @override
  State<AlbumViewScreen> createState() => _AlbumViewScreenState();
}

class _AlbumViewScreenState extends State<AlbumViewScreen> {
  void _pickImage() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (result != null) {
      setState(() {
        widget.album.imagePaths.add(result.path);
      });
      await widget.album.save();
    }
  }

  void _viewImage(File file) async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullImageView(imageFile: file),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.album.name)),
      body: widget.album.images.isEmpty
          ? const Center(child: Text('No memories yet'))
          : GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(8),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: widget.album.images
            .map((img) => GestureDetector(
          onTap: () => _viewImage(img),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(img, fit: BoxFit.cover),
          ),
        ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _pickImage,
        child: const Icon(Icons.add_photo_alternate,
        color: Colors.white,),
      ),
    );
  }
}

class FullImageView extends StatelessWidget {
  final File imageFile;
  const FullImageView({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
