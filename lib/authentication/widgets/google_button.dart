import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sign in with google button.
class GoogleButton extends StatelessWidget {
  /// Default constructor.
  const GoogleButton({
    required this.onPressed,
    super.key,
  });

  /// Callback.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 6,
            ),
            SvgPicture.asset(
              'assets/svg/btn_google_light_normal_ios.svg',
              height: 40,
            ),
            Text(
              'Sign in with Google',
              style: GoogleFonts.roboto(
                color: Colors.black.withOpacity(0.54),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Opacity(
              opacity: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  SvgPicture.asset(
                    'assets/svg/btn_google_light_normal_ios.svg',
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
