 import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Welcome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(241, 242, 243, 1)),
        useMaterial3: true,
      ),
      home: const PictureFrameScreen(),
    );
  }
}

class PictureFrameScreen extends StatefulWidget {
  const PictureFrameScreen({super.key});

  @override
  _PictureFrameScreenState createState() => _PictureFrameScreenState();
}

class _PictureFrameScreenState extends State<PictureFrameScreen> {
  final String apiKey =
      "KPNjZBL1iK5zExENyAa1eN3PlQA9jTPk8ilyii2RDzTvmeG2nso5Q0gD";
  final String apiUrl =
      "https://api.pexels.com/v1/search?query=paintings&per_page=6";

  List<String> imageUrls = [];
  int currentIndex = 0;
  bool isPaused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      final response =
          await http.get(Uri.parse(apiUrl), headers: {"Authorization": apiKey});

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> photos = data['photos'] ?? [];

        if (photos.isEmpty) {
          print("No images returned from API.");
          setState(() {
            imageUrls = [];
          });
          return;
        }

        final List<String> fetchedImages =
            photos.map<String>((photo) => photo['src']['large']).toList();

        if (mounted) {
          setState(() {
            imageUrls = fetchedImages;
            currentIndex = 0; // Reset index to show the first image
          });
        }

        if (imageUrls.isNotEmpty) {
          startImageRotation();
        }
      } else {
        print("Failed to fetch images: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching images: $error");
    }
  }

  void startImageRotation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!isPaused && imageUrls.isNotEmpty) {
        setState(() {
          currentIndex = (currentIndex + 1) % imageUrls.length;
        });
      }
    });
  }

  void togglePauseResume() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void nextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % imageUrls.length;
    });
  }

  void previousImage() {
    setState(() {
      currentIndex = (currentIndex - 1 + imageUrls.length) % imageUrls.length;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
          textAlign: TextAlign.center, // Centers the title text
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 232, 236, 238),
        centerTitle: true, // Centers the title in the AppBar
        toolbarHeight: 80, // Optional: Adjust height if needed
        automaticallyImplyLeading: false, // Optional: Hide back button
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image display with animation
            imageUrls.isNotEmpty
                ? AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: Container(
                      key: ValueKey<int>(currentIndex),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown, width: 10),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: imageUrls[currentIndex],
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          width: 350,
                          height: 500,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      "No images available",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 109, 89, 89)),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Pause/Resume Button
          FloatingActionButton(
            onPressed: togglePauseResume,
            backgroundColor: Colors.blueGrey.shade700,
            child: Icon(
              isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Next Image Button
          FloatingActionButton(
            onPressed: nextImage,
            backgroundColor: Colors.blueGrey.shade700,
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Previous Image Button
          FloatingActionButton(
            onPressed: previousImage,
            backgroundColor: Colors.blueGrey.shade700,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}