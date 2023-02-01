




  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:super_banners/super_banners.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';
import 'package:youtube_clicker/resourses/images.dart';

class MembershipPage extends StatelessWidget{
   MembershipPage({super.key});

 final List<int> _limit=[60,200,600];
 final List<String> _cost=['\$0.5', '\$0,45','\$0,4' ];
 final List<String> _costSub=['15\$','45\$','120\$'];
 final List<String> _sales=['','10%','20%'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
               Align(
                 alignment: Alignment.centerRight,
                 child: GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                   },
                   child: Container(
                     margin:const EdgeInsets.only(right: 20,top: 60),
                     width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorPrimary
                    ),
                     child:const Icon(Icons.close_rounded,color: Colors.white),
              ),
                 ),
               ),
            Padding(
              padding: const EdgeInsets.only(top: 10,left: 40,bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(almas,width: 30,height: 40,color: Colors.amber),
                  const SizedBox(width: 20),
                 const Text('Monthly premium \nsubscription',
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w400,
                        fontSize: 32
                    ),)
                ],
              ),
            ),
              ...List.generate(3, (index) {
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30,right: 30,top:_sales[index].isNotEmpty?60:40,bottom: 10),
                      margin:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      height: _sales[index].isNotEmpty?235:220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: colorPrimary,
                        image: DecorationImage(image: AssetImage(bgCart),fit: BoxFit.fill)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(item,width: 20,height: 20,color: Colors.amber,),
                                const SizedBox(width: 10),
                                const Text('The cost of translating one video is only',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16
                                  ),),
                                const SizedBox(width: 10,),
                                Text(_cost[index],style:const TextStyle(
                                  color: Colors.amber,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20
                                ),)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(item,width: 20,height: 20,color: Colors.amber),
                                const SizedBox(width: 10),
                                const Text('Limit translations per month ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16
                                  ),),
                                const SizedBox(width: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.amber
                                  ),
                                  padding:const EdgeInsets.only(left: 5,right: 5),
                                  child: Text('${_limit[index]}',style: TextStyle(
                                      color: colorPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20
                                  ),),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(item,width: 20,height: 20,color: Colors.amber),
                              const SizedBox(width: 10),
                              const Text('Subscription cost per month ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22
                                ),),
                              const SizedBox(width: 5),
                              Text(
                              _costSub[index],
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24),
                            )
                          ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(onPressed: (){},
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(colorBackground),
                                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ))
                              ),
                                child: const Text('Subscribe',
                                    style:  TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20)),),
                          )
                        ],
                      ),
                    ),

                Visibility(
                  visible:_sales[index].isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,top: 10),
                    child:  CornerBanner(
                      elevation: 10,
                    bannerPosition: CornerBannerPosition.topLeft,
                    bannerColor: colorRed,
                    child: Text('Sale ${_sales[index]}',
                  style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16))),
                    ),
                ),
                ],
                );
              })
          ],
        ),
      ),
    );
  }




}