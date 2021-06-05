import 'package:flutter/material.dart';

class LoadingImage extends StatefulWidget {
  @override
  _LoadingImageState createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _animation,
        child: Image.asset('assets/images/tasqment-logo.png'),
      ),
    );
  }
}
