import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:better_player_enhanced/better_player.dart';
import 'package:pod_player/pod_player.dart';

void main() {
  runApp(const VideoPlayerComparisonApp());
}

class VideoPlayerComparisonApp extends StatelessWidget {
  const VideoPlayerComparisonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Comparison',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player Comparison'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a video player to test:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoPlayerScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Standard Video Player'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoPlayerEnhancedScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.fullscreen),
              label: const Text('Standard Video Player (Fullscreen + Pinch to Zoom)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isMacOS ? null : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BetterPlayerScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_filled),
              label: const Text('Better Player Enhanced'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PodPlayerScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.smart_display),
              label: const Text('Pod Player (YouTube-like)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            if (isMacOS) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Better Player Enhanced is not supported on macOS. Use the Standard Video Player instead.',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Features:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Play/Pause controls'),
                    Text('• Seek functionality'),
                    Text('• Volume control'),
                    Text('• Playback speed'),
                    Text('• Fullscreen mode'),
                    Text('• Progress indicator'),
                    Text('• Video quality (1080p test video)'),
                    Text('• Cross-platform compatibility'),
                    Text('• Auto-play functionality'),
                    Text('• Double-tap to seek (Pod Player)'),
                    Text('• YouTube-like controls (Pod Player)'),
                    Text('• Native gesture controls (Better Player Enhanced)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;

  // Using a high-quality 1080p test video
  final String videoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
    setState(() {
          _isInitialized = true;
        });
        // Auto-play the video after initialization
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Standard Video Player'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isInitialized
          ? SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  const SizedBox(height: 20),
                  VideoPlayerControls(
                    controller: _controller,
                    volume: _volume,
                    playbackSpeed: _playbackSpeed,
                    onVolumeChanged: (value) {
                      setState(() {
                        _volume = value;
                        _controller.setVolume(value);
                      });
                    },
                    onPlaybackSpeedChanged: (speed) {
                      setState(() {
                        _playbackSpeed = speed;
                        _controller.setPlaybackSpeed(speed);
                      });
                    },
                    onPlayPausePressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  VideoPlayerInfo(
                    controller: _controller,
                    volume: _volume,
                    playbackSpeed: _playbackSpeed,
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class VideoPlayerControls extends StatelessWidget {
  final VideoPlayerController controller;
  final double volume;
  final double playbackSpeed;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<double> onPlaybackSpeedChanged;
  final VoidCallback onPlayPausePressed;

  const VideoPlayerControls({
    super.key,
    required this.controller,
    required this.volume,
    required this.playbackSpeed,
    required this.onVolumeChanged,
    required this.onPlaybackSpeedChanged,
    required this.onPlayPausePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Play/Pause and basic controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: onPlayPausePressed,
                icon: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 32,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.seekTo(Duration.zero);
                },
                icon: const Icon(Icons.replay, size: 32),
              ),
              IconButton(
                onPressed: () {
                  final position = controller.value.position;
                  final newPosition = position - const Duration(seconds: 10);
                  controller.seekTo(newPosition);
                },
                icon: const Icon(Icons.replay_10, size: 32),
              ),
              IconButton(
                onPressed: () {
                  final position = controller.value.position;
                  final newPosition = position + const Duration(seconds: 10);
                  controller.seekTo(newPosition);
                },
                icon: const Icon(Icons.forward_10, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress bar
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          
          const SizedBox(height: 16),
          
          // Volume control
          Row(
            children: [
              const Icon(Icons.volume_down),
              Expanded(
                child: Slider(
                  value: volume,
                  onChanged: onVolumeChanged,
                ),
              ),
              const Icon(Icons.volume_up),
            ],
          ),
          
          // Playback speed control
          Row(
            children: [
              const Text('Speed: '),
              DropdownButton<double>(
                value: playbackSpeed,
                items: [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                    .map((speed) => DropdownMenuItem(
                          value: speed,
                          child: Text('${speed}x'),
                        ))
                    .toList(),
                onChanged: (speed) {
                  if (speed != null) {
                    onPlaybackSpeedChanged(speed);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VideoPlayerInfo extends StatelessWidget {
  final VideoPlayerController controller;
  final double volume;
  final double playbackSpeed;

  const VideoPlayerInfo({
    super.key,
    required this.controller,
    required this.volume,
    required this.playbackSpeed,
  });

  @override
  Widget build(BuildContext context) {
    final duration = controller.value.duration;
    final position = controller.value.position;
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Video Information:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Duration: ${_formatDuration(duration)}'),
            Text('Position: ${_formatDuration(position)}'),
            Text('Aspect Ratio: ${controller.value.aspectRatio.toStringAsFixed(2)}'),
            Text('Volume: ${(volume * 100).toInt()}%'),
            Text('Playback Speed: ${playbackSpeed}x'),
            Text('Auto-play: Enabled'),
            Text('Is Playing: ${controller.value.isPlaying}'),
            Text('Is Buffering: ${controller.value.isBuffering}'),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}

class VideoPlayerEnhancedScreen extends StatefulWidget {
  const VideoPlayerEnhancedScreen({super.key});

  @override
  State<VideoPlayerEnhancedScreen> createState() => _VideoPlayerEnhancedScreenState();
}

class _VideoPlayerEnhancedScreenState extends State<VideoPlayerEnhancedScreen> {
  late VideoPlayerController _controller;
  late TransformationController _transformationController;
  bool _isInitialized = false;
  bool _isFullscreen = false;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;

  // Using a high-quality 1080p test video
  final String videoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        // Auto-play the video after initialization
        _controller.play();
      });
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _controller.dispose();
    _transformationController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    
    // Reset zoom when toggling fullscreen
    _resetZoom();
    
    if (_isFullscreen) {
      // Enter fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      // Allow both orientations in fullscreen
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Exit fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullscreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _isInitialized
                  ? GestureDetector(
                      onDoubleTap: _resetZoom,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        boundaryMargin: const EdgeInsets.all(double.infinity),
                        minScale: 0.5,
                        maxScale: 4,
                        panEnabled: true,
                        scaleEnabled: true,
                        constrained: false,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 30),
                onPressed: _toggleFullscreen,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: MinimalVideoControls(
                controller: _controller,
                onPlayPausePressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player (Fullscreen + Pinch to Zoom)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isInitialized
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: _toggleFullscreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  EnhancedVideoPlayerControls(
                    controller: _controller,
                    volume: _volume,
                    playbackSpeed: _playbackSpeed,
                    onVolumeChanged: (value) {
                      setState(() {
                        _volume = value;
                        _controller.setVolume(value);
                      });
                    },
                    onPlaybackSpeedChanged: (speed) {
                      setState(() {
                        _playbackSpeed = speed;
                        _controller.setPlaybackSpeed(speed);
                      });
                    },
                    onPlayPausePressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  EnhancedVideoPlayerInfo(
                    controller: _controller,
                    volume: _volume,
                    playbackSpeed: _playbackSpeed,
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class MinimalVideoControls extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onPlayPausePressed;

  const MinimalVideoControls({
    super.key,
    required this.controller,
    required this.onPlayPausePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPlayPausePressed,
            icon: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                backgroundColor: Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedVideoPlayerControls extends StatelessWidget {
  final VideoPlayerController controller;
  final double volume;
  final double playbackSpeed;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<double> onPlaybackSpeedChanged;
  final VoidCallback onPlayPausePressed;

  const EnhancedVideoPlayerControls({
    super.key,
    required this.controller,
    required this.volume,
    required this.playbackSpeed,
    required this.onVolumeChanged,
    required this.onPlaybackSpeedChanged,
    required this.onPlayPausePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Fullscreen and Zoom instructions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.touch_app, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap button for fullscreen • Pinch to zoom in fullscreen only',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Play/Pause and basic controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: onPlayPausePressed,
                icon: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 32,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.seekTo(Duration.zero);
                },
                icon: const Icon(Icons.replay, size: 32),
              ),
              IconButton(
                onPressed: () {
                  final position = controller.value.position;
                  final newPosition = position - const Duration(seconds: 10);
                  controller.seekTo(newPosition);
                },
                icon: const Icon(Icons.replay_10, size: 32),
              ),
              IconButton(
                onPressed: () {
                  final position = controller.value.position;
                  final newPosition = position + const Duration(seconds: 10);
                  controller.seekTo(newPosition);
                },
                icon: const Icon(Icons.forward_10, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress bar
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          
          const SizedBox(height: 16),
          
          // Volume control
          Row(
            children: [
              const Icon(Icons.volume_down),
              Expanded(
                child: Slider(
                  value: volume,
                  onChanged: onVolumeChanged,
                ),
              ),
              const Icon(Icons.volume_up),
            ],
          ),
          
          // Playback speed control
          Row(
            children: [
              const Text('Speed: '),
              DropdownButton<double>(
                value: playbackSpeed,
                items: [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                    .map((speed) => DropdownMenuItem(
                          value: speed,
                          child: Text('${speed}x'),
                        ))
                    .toList(),
                onChanged: (speed) {
                  if (speed != null) {
                    onPlaybackSpeedChanged(speed);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EnhancedVideoPlayerInfo extends StatelessWidget {
  final VideoPlayerController controller;
  final double volume;
  final double playbackSpeed;

  const EnhancedVideoPlayerInfo({
    super.key,
    required this.controller,
    required this.volume,
    required this.playbackSpeed,
  });

  @override
  Widget build(BuildContext context) {
    final duration = controller.value.duration;
    final position = controller.value.position;
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enhanced Features:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('🎯 Fullscreen Mode:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('  • Tap fullscreen button to enter/exit'),
            const Text('  • Supports portrait and landscape'),
            const Text('  • Maintains aspect ratio'),
            const Text('  • Immersive system UI mode'),
            const SizedBox(height: 8),
            const Text('🔍 Pinch to Zoom:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('  • Available in fullscreen mode only'),
            const Text('  • Pinch to zoom up to 4x'),
            const Text('  • Drag to pan when zoomed'),
            const Text('  • Double-tap to reset zoom'),
            const Text('  • Full screen space for zooming'),
            const SizedBox(height: 12),
            const Text(
              'Video Information:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Duration: ${_formatDuration(duration)}'),
            Text('Position: ${_formatDuration(position)}'),
            Text('Aspect Ratio: ${controller.value.aspectRatio.toStringAsFixed(2)}'),
            Text('Volume: ${(volume * 100).toInt()}%'),
            Text('Playback Speed: ${playbackSpeed}x'),
            Text('Auto-play: Enabled'),
            Text('Is Playing: ${controller.value.isPlaying}'),
            Text('Is Buffering: ${controller.value.isBuffering}'),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}

class BetterPlayerScreen extends StatefulWidget {
  const BetterPlayerScreen({super.key});

  @override
  State<BetterPlayerScreen> createState() => _BetterPlayerScreenState();
}

class _BetterPlayerScreenState extends State<BetterPlayerScreen> {
  late BetterPlayerController _betterPlayerController;
  
  // Using a high-quality 1080p test video
  final String videoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    _initializeBetterPlayer();
  }

  void _initializeBetterPlayer() {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
      notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: "Big Buck Bunny",
        author: "Test Video",
      ),
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
        // Enable native gesture controls
        fit: BoxFit.contain,
        handleLifecycle: true,
        // Enable all gesture controls natively
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePlayPause: true,
          enableMute: true,
          enableFullscreen: true, // Re-enable native fullscreen
          enablePip: true,
          enableSkips: true,
          enableProgressBar: true,
          enableProgressText: true,
          enableAudioTracks: true,
          enableSubtitles: true,
          enableQualities: true,
          enablePlaybackSpeed: true,
          // Visual customization
          showControlsOnInitialize: false,
          controlBarColor: Colors.black26,
          iconsColor: Colors.white,
          progressBarPlayedColor: Colors.red,
          progressBarHandleColor: Colors.red,
          textColor: Colors.white,
          enableRetry: true,
        ),
        // Enable interaction area for native gestures
        placeholder: Center(
          child: CircularProgressIndicator(),
        ),
        showPlaceholderUntilPlay: true,
        expandToFill: false,
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Better Player Enhanced'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _betterPlayerController),
            ),
            const SizedBox(height: 20),
            BetterPlayerControls(controller: _betterPlayerController),
            const SizedBox(height: 20),
            const BetterPlayerInfo(),
          ],
        ),
      ),
    );
  }
}

class BetterPlayerControls extends StatelessWidget {
  final BetterPlayerController controller;

  const BetterPlayerControls({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Better Player Controls:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.touch_app, color: Colors.blue.shade700, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Double tap to play/pause • Native fullscreen available • Built-in gesture controls',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => controller.play(),
                child: const Text('Play'),
              ),
              ElevatedButton(
                onPressed: () => controller.pause(),
                child: const Text('Pause'),
              ),
              ElevatedButton(
                onPressed: () => controller.seekTo(Duration.zero),
                child: const Text('Restart'),
              ),
              ElevatedButton(
                onPressed: () => controller.enablePictureInPicture(controller.betterPlayerGlobalKey!),
                child: const Text('PiP'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.setVolume(0.5);
                },
                child: const Text('50% Volume'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.setSpeed(2.0);
                },
                child: const Text('2x Speed'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BetterPlayerInfo extends StatelessWidget {
  const BetterPlayerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Better Player Enhanced Features:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('✅ Advanced controls with built-in UI'),
            const Text('✅ Picture-in-Picture support'),
            const Text('✅ Subtitle support'),
            const Text('✅ Multiple quality options'),
            const Text('✅ Audio track selection'),
            const Text('✅ Notification controls'),
            const Text('✅ Playlist support'),
            const Text('✅ Cache management'),
            const Text('✅ DRM support'),
            const Text('✅ HLS and DASH support'),
            const Text('✅ Fixed hashValues compatibility issue'),
            const Text('✅ Auto-play functionality', 
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const Text('🎯 Native gesture controls and interactions', 
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const Text('🎯 Native Better Player fullscreen', 
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const Text('🎯 Double-tap to play/pause', 
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'This is the enhanced version that works with Flutter 3.8+!',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class PodPlayerScreen extends StatefulWidget {
  const PodPlayerScreen({super.key});

  @override
  State<PodPlayerScreen> createState() => _PodPlayerScreenState();
}

class _PodPlayerScreenState extends State<PodPlayerScreen> {
  late PodPlayerController _podPlayerController;
  
  // Using a high-quality 1080p test video
  final String videoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    _initializePodPlayer();
  }

  void _initializePodPlayer() {
    _podPlayerController = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(videoUrl),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: true,
        isLooping: false,
        videoQualityPriority: [1080, 720, 480, 360],
        wakelockEnabled: true,
      ),
    )..initialise();
  }

  @override
  void dispose() {
    _podPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pod Player (YouTube-like)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PodVideoPlayer(
              controller: _podPlayerController,
              videoThumbnail: const DecorationImage(
                image: NetworkImage(
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const PodPlayerControls(),
            const SizedBox(height: 20),
            const PodPlayerInfo(),
          ],
        ),
      ),
    );
  }
}

class PodPlayerControls extends StatelessWidget {
  const PodPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Pod Player Controls:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.touch_app, color: Colors.red.shade700, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Double-tap to seek forward/backward • Tap to show/hide controls • YouTube-like interface',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pod Player provides built-in controls. Use the video player interface above for all controls.',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PodPlayerInfo extends StatelessWidget {
  const PodPlayerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pod Player Features:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('✅ YouTube-like video controls'),
            const Text('✅ Double-tap to seek forward/backward'),
            const Text('✅ Auto-hide overlay controls'),
            const Text('✅ Auto-play functionality'),
            const Text('✅ Custom playback speed control'),
            const Text('✅ Quality selection (1080p, 720p, 480p, 360p)'),
            const Text('✅ Fullscreen support'),
            const Text('✅ Custom progress bar'),
            const Text('✅ Keyboard shortcuts (web)'),
            const Text('✅ Mute/unmute controls'),
            const Text('✅ Video thumbnail support'),
            const Text('✅ Wakelock enabled'),
            const Text('✅ Custom overlay and labels'),
            const Text('✅ Built on official video_player'),
            const Text('🎯 YouTube and Vimeo support', 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const Text('🎯 Professional video player interface', 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const Text('🎯 Advanced gesture controls', 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Perfect for apps requiring YouTube-like video experience!',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
