// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

void main() async {
  // Ensure bindings are initialized otherwise we can't user rootBundle.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'experience',
      home: PageWithButton(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PageWithButton extends StatelessWidget {
  const PageWithButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButton(
              label: Text(
                "Push me",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => print("test"),
            ),
            SizedBox(height: 150),
            AnimatedGradientButton(
              label: Text(
                "Push me",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.purple[800]!,
                  Colors.purple[400]!,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
              ),
              onPushGradient: LinearGradient(
                colors: [
                  Colors.purple[400]!,
                  Colors.purple[800]!,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
              ),
              onPressed: () => print("test"),
            )
          ],
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final Text? label;
  final Icon? icon;
  final Function() onPressed;

  const GradientButton({
    Key? key,
    this.label,
    this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        gradient: LinearGradient(
          colors: [
            Colors.purple[600]!,
            Colors.purple[400]!,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFA74834).withOpacity(.2),
              offset: const Offset(0, 3),
              spreadRadius: 2,
              blurRadius: 4)
        ],
      ),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: onPressed,
        child: label,
      ),
    );
  }
}

class AnimatedGradientButton extends StatefulWidget {
  final Text? label;
  final Gradient gradient;
  final Gradient onPushGradient;
  final Icon? icon;
  final Function() onPressed;

  AnimatedGradientButton({
    Key? key,
    this.label,
    this.icon,
    required this.gradient,
    required this.onPushGradient,
    required this.onPressed,
  })  : assert(gradient.colors.length == onPushGradient.colors.length),
        super(key: key);

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurveTween(curve: Curves.decelerate).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            gradient: LinearGradient(
              colors: widget.gradient.colors
                  .asMap()
                  .map(
                    (key, value) => MapEntry(
                  key,
                  Color.lerp(
                    value,
                    widget.onPushGradient.colors[key],
                    animation.value,
                  )!,
                ),
              )
                  .values
                  .toList(),
              begin: Alignment.bottomCenter,
              end: Alignment.topRight,
            ),
          ),
          child: child,
        );
      },
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          await controller.forward();
          await controller.animateBack(0);
          widget.onPressed();
        },
        splashColor: Colors.transparent,
        child: widget.label,
      ),
    );
  }
}