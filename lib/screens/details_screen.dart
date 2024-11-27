import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailsScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final String publish;

  const DetailsScreen({
    super.key, 
    required this.videoId,
    required this.title,
    required this.description,
    required this.publish,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _controller = YoutubePlayerController();

  @override
  void initState() {
    super.initState();
    _controller.loadVideoById(videoId: widget.videoId);
    print("masuk ke details");
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Published at: ${widget.publish}',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
