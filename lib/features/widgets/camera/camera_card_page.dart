import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({super.key, required this.camera});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Size size = Size(0, 0);
  bool isWindowShown = false;
  bool isFlashOn = false;
  double s = 1.3;
  double width = 0;
  double height = 0;

  @override
  void initState() {
    super.initState();
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Transform.scale(
                  scale: 0,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CameraPreview(_controller),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

          /* camera overlay */
          Align(
            alignment: FractionalOffset.topRight,
            child: SizedBox(
              height: 50,
              width: 50,
              child: IconButton(
                icon: IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.grey,
                  onPressed: () {
                    setState(() {
                      isWindowShown = isWindowShown ? false : true;
                    });
                  },
                ),
                onPressed: null,
              ),
            ),
          ),
          isWindowShown
              ? Container(
                  margin: EdgeInsets.fromLTRB(10.0, 60.0, 10.0, 0.0),
                  height: 40,
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.flash_on,
                          color: isFlashOn ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isFlashOn = true;
                            // _controller.enableFlash(true);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.flash_off,
                          color: isFlashOn ? Colors.grey : Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            isFlashOn = false;
                            // _controller.enableFlash(false);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.zoom_in, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            s = 2.0;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.zoom_out, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            s = 1.3;
                          });
                        },
                      ),
                    ],
                  ),
                )
              : Container(),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Container()),
              // capture progress
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            await _controller.takePicture();
            print(path);
            Fluttertoast.showToast(
              msg: "saved to $path",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              // timeInSecForIos: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path, s: s,),
              ),
            );*/
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

// A Widget that displays the picture taken by the user
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final double s;
  final OverlayFormat format;
  final String title;
  final String? description;
  final String? descriptionPicture;
  final void Function()? onPressed;
  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.s,
    required this.format,
    this.description,
    this.descriptionPicture,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: s > 1.5
          ? _getTransformedPreview(context)
          : _getUntransformedPreview(context),
    );
  }

  Widget _getUntransformedPreview(BuildContext context) {
    return Stack(
      children: [
        Image.file(File(imagePath), fit: BoxFit.cover),
        OverlayShape(format),
        Positioned(
          top: 30,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 5),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              if (description != null)
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              if (descriptionPicture != null)
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    descriptionPicture!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Reprendre"),
              ),

              SizedBox(height: 10),
              TextButton(
                onPressed: onPressed,
                child: Text("Utiliser cette photo"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getTransformedPreview(BuildContext context) {
    return Transform.scale(
      scale: s - 0.4,
      child: Center(
        child: Image.file(
          File(imagePath),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

typedef XFileCallback = void Function(XFile file);

class CameraPage extends StatefulWidget {
  final XFileCallback? onCapture;
  final OverlayFormat? format;
  final bool? isSelfie;

  final String title;
  final String? description;
  final String? descriptionPicture;
  final BuildContext context;

  const CameraPage({
    super.key,
    this.onCapture,
    this.format,
    this.isSelfie = false,
    this.description,
    this.descriptionPicture,
    required this.title,
    required this.context,
  });

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool loadTakePic = false;

  late final List<CameraDescription> _cameras;

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    // Initialize the camera with the first camera in the list
    final selfieCamera = _cameras
        .where((element) => element.lensDirection == CameraLensDirection.front)
        .toList()[0];

    await onNewCameraSelected(
      widget.isSelfie! ? selfieCamera : _cameras.first,
      widget.context,
    );
  }

  Future<void> onNewCameraSelected(
    CameraDescription description,
    BuildContext context,
  ) async {
    final previousCameraController = _controller;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        _controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      print("initilizing _camera");
      await _controller!.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing _camera: $e ${e.code} ${e.description}');
      if (await Permission.camera.isDenied) {
        showDialog(
          // title: 'Permission caméra non accordée',
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Vous devez autoriser l'accès à votre caméra avant de continuer",
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'retour',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          // color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        openAppSettings();
                      },
                      child: const Text(
                        'paramètre',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      }
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = _controller!.value.isInitialized;
        print(
          '----------camera is initialised : $_isCameraInitialized------------',
        );
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    print(state);

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      // onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initCamera();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String filePath = "";
  @override
  Widget build(BuildContext context) {
    if (_isCameraInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [CameraPreview(_controller!)],
              ),
            ),
            if (widget.format != null) OverlayShape(widget.format!),
            Positioned(
              top: 30,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 5),
                      Text(
                        widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  if (widget.description != null)
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        widget.description!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  if (widget.descriptionPicture != null)
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        widget.descriptionPicture!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: IconButton(
                onPressed: () async {
                  //  Get.back();
                  setState(() {
                    loadTakePic = true;
                  });
                  // cameraController?.setFlashMode(FlashMode.off);
                  if (Platform.isAndroid) {
                    HapticFeedback.vibrate();
                  } else {
                    HapticFeedback.heavyImpact();
                  }

                  final file = await _controller?.takePicture();

                  if (file != null) {
                    setState(() {
                      filePath = file.path;
                    });
                    inspect(file);
                    if (widget.onCapture != null) widget.onCapture!(file);
                  }
                  setState(() {
                    loadTakePic = false;
                  });
                },
                icon: const Icon(
                  Icons.camera_rounded,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

enum OverlayFormat {
  ///Most banking cards and ID cards
  cardID1,

  ///French and other ID cards. Visas.
  cardID2,

  ///United States government ID cards
  cardID3,

  ///SIM cards
  simID000,

  ///circle cards
  circle,

  //// oval
  oval,
}

enum OverlayOrientation { landscape, portrait }

abstract class OverlayModel {
  double? ratio;

  double? cornerRadius;

  OverlayOrientation? orientation;
}

class CardOverlay implements OverlayModel {
  CardOverlay({
    this.ratio = 1.5,
    this.cornerRadius = 0.66,
    this.orientation = OverlayOrientation.landscape,
  });

  @override
  double? ratio;
  @override
  double? cornerRadius;
  @override
  OverlayOrientation? orientation;

  static byFormat(OverlayFormat format) {
    switch (format) {
      case (OverlayFormat.cardID1):
        return CardOverlay(ratio: 1.62, cornerRadius: 0.064);
      case (OverlayFormat.cardID2):
        return CardOverlay(ratio: 1.48, cornerRadius: 0.067);
      case (OverlayFormat.cardID3):
        return CardOverlay(ratio: 1.48, cornerRadius: 0.057);
      case (OverlayFormat.simID000):
        return CardOverlay(ratio: 1.7, cornerRadius: 0.073);
      case (OverlayFormat.circle):
        return CardOverlay(ratio: 1, cornerRadius: 180);
      case (OverlayFormat.oval):
        return CardOverlay(ratio: 0.7, cornerRadius: 0);
    }
  }
}

class OverlayShape extends StatelessWidget {
  final OverlayFormat format;
  const OverlayShape(this.format, {super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var size = media.size;
    double width = media.orientation == Orientation.portrait
        ? size.shortestSide * .9
        : size.longestSide * .5;
    final model = CardOverlay.byFormat(format);

    double ratio = model.ratio as double;
    double height = width / ratio;
    double radius = model.cornerRadius == null
        ? 0
        : model.cornerRadius! * height;
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black45,

            BlendMode.srcOut,
          ), // This one will create the magic
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ), // This one will handle background + difference out
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: format == OverlayFormat.circle
                        ? BoxShape.circle
                        : BoxShape.rectangle,
                    borderRadius: format == OverlayFormat.oval
                        ? BorderRadius.all(Radius.elliptical(width, height))
                        : format == OverlayFormat.circle
                        ? null
                        : BorderRadius.circular(radius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
