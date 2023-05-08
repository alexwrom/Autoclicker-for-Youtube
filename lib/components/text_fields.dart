



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../resourses/colors_app.dart';


class EmailFieldLogin extends StatelessWidget {
   const EmailFieldLogin({Key? key, required this.controller,this.textHint='E-mail'}) : super(key: key);
  final TextEditingController controller;
  final String textHint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.start,
        controller: controller,
        style: TextStyle(color:  Colors.white),
        decoration: InputDecoration(
          filled: true,
            fillColor: colorBackground,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Icon(Icons.email_outlined,color: colorGrey),
            ),
            hintText: textHint,
            hintStyle: TextStyle(color: colorGrey,fontSize:16,fontWeight: FontWeight.w400),
            contentPadding:const EdgeInsets.only(left: 20,right: 20,top: 12,bottom: 12),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: colorBackground,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: colorRed,
                width: 1.0,
              ),
            )),
      ),
    );
  }
}

class PassFieldLogin extends StatefulWidget {
  const PassFieldLogin({Key? key, required this.controller,required this.textHint}) : super(key: key);
  final TextEditingController controller;
  final String textHint;

  @override
  State<PassFieldLogin> createState() => _PassFieldLoginState();
}

class _PassFieldLoginState extends State<PassFieldLogin> {
  bool _isVisiblePass=true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        maxLines: 1,
        obscureText: _isVisiblePass,
        keyboardType: TextInputType.visiblePassword,
        textAlign: TextAlign.start,
        controller: widget.controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            filled: true,
            fillColor: colorBackground,
            suffixIcon: GestureDetector(
              onTap: (){
                setState(() {
                  if(_isVisiblePass){
                    _isVisiblePass=false;
                  }else{
                    _isVisiblePass=true;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: _isVisiblePass?Icon(Icons.lock_outline,color: colorGrey):
                 Icon(Icons.lock_open,color: colorGrey),
              ),
            ),
            hintText: widget.textHint,
            hintStyle: TextStyle(color: colorGrey,fontSize:16,fontWeight: FontWeight.w400),
            contentPadding:const EdgeInsets.only(left: 20,right: 20,top: 12,bottom: 12),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: colorBackground,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: colorRed,
                width: 1.0,
              ),
            )),
      ),
    );
  }
}