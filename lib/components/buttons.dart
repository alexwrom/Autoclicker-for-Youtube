






import 'package:flutter/material.dart';

import '../resourses/colors_app.dart';



class SubmitButton extends StatelessWidget {

  final VoidCallback? onTap;
  final String? textButton;
  final double? width;



   const SubmitButton({Key? key,
    this.onTap,
    this.textButton='OK',
     this.width=double.infinity
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorBackground),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                )
            )
        ),
        onPressed: onTap,
        child: Text(
          textButton!,
          style: TextStyle(
            color: colorGrey,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
