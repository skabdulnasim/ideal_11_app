import 'package:flutter/material.dart';

class BottomFloatingActionBar extends StatelessWidget {
  // final VoidCallback onContestsPressed;
  final VoidCallback onCreateTeamPressed;

  const BottomFloatingActionBar({
    Key? key,
    // required this.onContestsPressed,
    required this.onCreateTeamPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 100,
      right: 100,
      child: Container(
        height: 40,
        // width: 180,
        decoration: BoxDecoration(
          color: Color(0xFF111C3D),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Row(
          children: [
            // Expanded(
            //   child: InkWell(
            //     onTap: onContestsPressed,
            //     borderRadius: BorderRadius.circular(30),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.sports_esports, color: Colors.white),
            //         SizedBox(width: 8),
            //         Text(
            //           "CONTESTS",
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 1,
            //   color: Colors.white24,
            //   margin: EdgeInsets.symmetric(vertical: 12),
            // ),
            Expanded(
              child: InkWell(
                onTap: onCreateTeamPressed,
                borderRadius: BorderRadius.circular(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "CREATE TEAM",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
