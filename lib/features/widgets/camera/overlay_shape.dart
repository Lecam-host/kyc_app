import 'package:flutter/material.dart';

class OverlayShape extends StatelessWidget {
  final OverlayFormat format;
  const OverlayShape(this.format, {Key? key}) : super(key: key);

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
    double radius =
        model.cornerRadius == null ? 0 : model.cornerRadius! * height;
    return Stack(children: [
      ColorFiltered(
        colorFilter: const ColorFilter.mode(
            Colors.black45, BlendMode.srcOut), // This one will create the magic
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode
                      .dstOut), // This one will handle background + difference out
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
                  borderRadius: format == OverlayFormat.circle
                      ? null
                      : BorderRadius.circular(radius),
                ),
              ),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: AnimatedBorderPainter(
            format: format,
            child: SizedBox(
              width: width + 25,
              height: height + 25,
            )),
      ),
    ]);
  }
}

class AnimatedBorderPainter extends StatefulWidget {
  final Widget child;
  final OverlayFormat format;

  const AnimatedBorderPainter(
      {super.key, required this.child, required this.format});
  @override
  State<AnimatedBorderPainter> createState() => _AnimatedBorderPainterState();
}

class _AnimatedBorderPainterState extends State<AnimatedBorderPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Durée de l'animation
    );

    _animation = Tween<double>(
      begin: 0.5,
      end: 2.0,
    ).animate(_controller);

    _controller.forward();

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: widget.format == OverlayFormat.circle
              ? CircularBorderPainter(_animation.value)
              : BorderPainter(_animation.value),
          child: widget.child,
        );
      },
    );
  }
}

class BorderPainter extends CustomPainter {
  final double progress;

  BorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const width = 4.0;
    const radius = 20.0;
    const tRadius = 3 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    const clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width *
            progress, // Épaisseur de la bordure en fonction de la progression
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircularBorderPainter extends CustomPainter {
  final double progress;

  CircularBorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const width = 4.0;
    final radius =
        size.shortestSide / 2 - width; // Calcul du rayon pour un cercle centré
    final center = Offset(size.width / 2, size.height / 2);

    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * progress,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

///ISO Card formats
///https://www.iso.org/standard/70483.html
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
  circle
}

enum OverlayOrientation { landscape, portrait }

abstract class OverlayModel {
  ///ratio between maximum allowable lengths of shortest and longest sides
  double? ratio;

  ///ratio between maximum allowable radius and maximum allowable length of shortest side
  double? cornerRadius;

  ///natural orientation for overlay
  OverlayOrientation? orientation;
}

class CardOverlay implements OverlayModel {
  CardOverlay(
      {this.ratio = 1.5,
      this.cornerRadius = 0.66,
      this.orientation = OverlayOrientation.landscape});

  @override
  double? ratio;
  @override
  double? cornerRadius;
  @override
  OverlayOrientation? orientation;

  static byFormat(OverlayFormat format) {
    switch (format) {
      case (OverlayFormat.cardID1):
        return CardOverlay(ratio: 1.59, cornerRadius: 0.064);
      case (OverlayFormat.cardID2):
        return CardOverlay(ratio: 1.42, cornerRadius: 0.067);
      case (OverlayFormat.cardID3):
        return CardOverlay(ratio: 1.42, cornerRadius: 0.057);
      case (OverlayFormat.simID000):
        return CardOverlay(ratio: 1.66, cornerRadius: 0.073);
      case (OverlayFormat.circle):
        return CardOverlay(ratio: 1, cornerRadius: 180);
    }
  }
}
