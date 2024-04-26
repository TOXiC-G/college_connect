import 'package:flutter/material.dart';

class SlopingAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0); // Start from top left corner
    path.lineTo(size.width, 0); // Move to the top right with a slight slope
    path.quadraticBezierTo(
        size.width, 0, size.width, size.height * 0.2); // Bezier curve
    path.lineTo(size.width,
        size.height * 0.8); // Move to bottom right with a slight slope
    path.quadraticBezierTo(
        size.width, size.height, size.width * 0.8, size.height); // Bezier curve
    path.lineTo(size.width * 0.2,
        size.height); // Move to bottom left with a slight slope
    path.quadraticBezierTo(
        0, size.height, 0, size.height * 0.8); // Bezier curve
    path.lineTo(0, size.height * 0.2); // Move to top left with a slight slope
    // path.quadraticBezierTo(0, 0, size.width * 0.2, 0); // Bezier curve
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final Color backgroundColor;
  final Color backButtonColor; // New parameter for back button color
  final TextStyle textStyle;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.automaticallyImplyLeading = false,
    this.backgroundColor = Colors.indigo,
    this.backButtonColor = Colors.white, // Default back button color
    this.textStyle = const TextStyle(
      fontFamily: 'Jost',
      color: Colors.white,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SlopingAppBarClipper(),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: backgroundColor,
        title: Text(
          title,
          style: textStyle,
        ),
        leading: automaticallyImplyLeading
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                color: backButtonColor, // Use the specified back button color
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
