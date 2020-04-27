import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(VideoTestApp());
}

class VideoTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PagedVideoWidget());
  }
}

class PagedVideoWidget extends StatefulWidget {
  const PagedVideoWidget({
    Key key,
  }) : super(key: key);

  @override
  _PagedVideoWidgetState createState() => _PagedVideoWidgetState();
}

class _PagedVideoWidgetState extends State<PagedVideoWidget> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<String> videos = ['assets/video3.mov', 'assets/video4.mov'];
  bool _visible = false;

  void _toggleVisible() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Videos"),
      ),
      body: Stack(
        children: <Widget>[
          InkWell(
            onTap: _toggleVisible,
            child: PageView.builder(
              itemBuilder: buildPage,
              controller: _controller,
            ),
          ),
          Visibility(
            visible: _visible,
            child: Positioned(
              bottom: 5,
              right: 5,
              child: IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: Colors.red,
                  ),
                  onPressed: () => null),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, int index) {
    return VideoWidget(key: ValueKey("video$index"), videoAsset: videos[index]);
  }
}

class VideoWidget extends StatefulWidget {
  final String videoAsset;
  VideoWidget({Key key, this.videoAsset}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset);
    _controller.initialize().then((value) {
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
