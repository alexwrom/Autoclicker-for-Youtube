






import 'package:flutter/material.dart';

import '../resourses/colors_app.dart';



class SubmitButton extends StatelessWidget {

  final VoidCallback? onTap;
  final String? textButton;
  final double? width;
  final Color colorsFill;



   const SubmitButton({Key? key,
    this.onTap,
    this.textButton='OK',
     this.width=double.infinity,
     this.colorsFill=const Color.fromRGBO(27, 29, 41, 1)
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorsFill),
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
