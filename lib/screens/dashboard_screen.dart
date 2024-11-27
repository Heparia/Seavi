import 'package:flutter/material.dart';
import 'package:seavi/screens/details_screen.dart';
import 'package:seavi/screens/profile_screen.dart';
import 'package:seavi/services/network.dart';

class DashboardScreen extends StatefulWidget {
  final String name;
  final String kategori;
  final bool isRestrict;
  final String kategoriName;

  const DashboardScreen({
    Key? key,
    required this.name,
    required this.kategori,
    required this.isRestrict,
    required this.kategoriName,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late bool isRestrict;
  late String nextPageToken;
  late List<Map<String, dynamic>> videos;
  final TextEditingController _searchController = TextEditingController(); 
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    isRestrict = widget.isRestrict;
    nextPageToken = '';
    videos = [];
    searchQuery = '';
    _getInitialVideos();
  }

  void _getInitialVideos() {
    getVideos(''); 
  }

  Future<List<Map<String, dynamic>>> getVideos(String query) async {
    String url;
    if (query.isEmpty) {
      url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&videoCategoryId=${widget.kategori}&maxResults=50&regionCode=ID';
    } else {
      url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&q=$query&maxResults=50&pageToken=$nextPageToken';
    }

    if(!isRestrict) {
      url += '&safeSearch=strict';
    }

    NetworkHelper networkHelper = NetworkHelper(url: url);

    try {
      var data = await networkHelper.getData();
      if (nextPageToken == '') videos.clear();

      for (var item in data['items']) {
        var details = item['snippet'];
        videos.add({
          'id': item['id'],
          'details': details,
        });
      }
      nextPageToken = data['nextPageToken'] ?? '';
    } catch (error) {
      setState(() {
        // Show some error message or state change
      });
    }
    return videos;
  }

  void _submitSearch(String query) {
    setState(() {
      nextPageToken = ''; 
      searchQuery = query;
      videos.clear(); 
    });
    getVideos(query);
  }

  Expanded renderVideos(List<Map<String, dynamic>> videos) {
    return Expanded(
      child: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final snippet = video['details'];
          final title = snippet['title'];
          final description = snippet['description']?.isNotEmpty == true 
            ? snippet['description'] 
            : 'No description available';
          DateTime parsedDate = DateTime.parse(snippet['publishedAt']);
          final String publish = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
          final videoId;
          if(searchQuery.isEmpty) {
            videoId = video['id'];
          } else {
            videoId = video['id']['videoId'];
            print("ini adalah video id search: ${video['videoId']}");
          }
          

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(publish),
                  Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      videoId: videoId,
                      title: title,
                      description: description,
                      publish: publish,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Search...',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
              ),
              onSubmitted: (value) {
                _submitSearch(value); 
              },
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>( 
            future: getVideos(searchQuery.isEmpty ? '' : searchQuery), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return renderVideos(snapshot.data!);
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                name: widget.name,
                interest: widget.kategoriName, 
                restrict: widget.isRestrict,
              ),
            ),
          );
        },
        child: const Icon(Icons.account_circle), 
      ),
    );
  }
}
