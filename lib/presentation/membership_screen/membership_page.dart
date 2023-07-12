




  import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_banners/super_banners.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_cubit.dart';
import 'package:youtube_clicker/presentation/membership_screen/bloc/membership_bloc.dart';
import 'package:youtube_clicker/presentation/membership_screen/bloc/membership_event.dart';
import 'package:youtube_clicker/presentation/membership_screen/bloc/membership_state.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';
import 'package:youtube_clicker/resourses/images.dart';

import '../../components/dialoger.dart';

class MembershipPage extends StatefulWidget{
   MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  int _currentLimit=0;


 late MemberShipBloc _memberShipBloc;
 double? sizeText;


 @override
  void initState() {
    super.initState();
    _memberShipBloc=MemberShipBloc(cubitUserData: context.read<UserDataCubit>());
    _memberShipBloc.add(GetProductEvent());


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: BlocProvider(
        create: (_)=>_memberShipBloc,
        child: BlocConsumer<MemberShipBloc,MemberShipState>(
          listener: (_,stateLis){
            if(stateLis.memebStatus.isError){
              Dialoger.showError(stateLis.error, context);
            }

            if(stateLis.memebStatus.isPurchased){
              Dialoger.showBuyDialog(context, 'Subscribed successfully!'.tr(),
                '$_currentLimit', false, () {
                      Navigator.pop(context);
                  });
          }
          },
          builder: (context,state) {
            if(state.memebStatus.isError||state.memebStatus.isEmpty){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                     state.memebStatus.isError?'An unknown error has occurred':'Product list is empty'.tr(),
                         style:const TextStyle(
                           color: Colors.grey,
                           fontSize: 16
                         ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(colorRed)
                        ),
                        onPressed: (){
                         Navigator.pop(context);
                        },
                        child: Text('Back'.tr()))
                  ],
                ),
              );
            }

            if(state.memebStatus.isLoading){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
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
                        Text('Purchasing translation packages'.tr(),
                          style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.w400,
                              fontSize: 32
                          ),)
                      ],
                    ),
                  ),
                    ...List.generate(state.listDetails.length, (index) {
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: state.listDetails[index].isSale?35:25,right: 20,top:state.listDetails[index].isSale?60:40,bottom: 10),
                            margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            height: state.listDetails[index].isSale?205:190,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: colorPrimary,
                              image: DecorationImage(image: AssetImage(bgCart),fit: BoxFit.fill)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(item,width: 20,height: 20,color: Colors.amber),
                                      const SizedBox(width: 10),
                                       Text(state.listDetails[index].titleLimitTranslation,
                                        style:const TextStyle(
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
                                        child: AutoSizeText('${state.listDetails[index].limitTranslation}',style: TextStyle(
                                            color: colorPrimary,
                                            fontWeight: FontWeight.w800,

                                        ),),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.asset(item,width: 20,height: 20,color: Colors.amber),
                                    const SizedBox(width: 10),
                                    AutoSizeText('${state.listDetails[index].titlePrice} ',
                                      style:const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22
                                      ),
                                        maxLines: 1,),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: AutoSizeText('${_getPrice(state.listDetails[index].rawPrice)}${state.listDetails[index].currencySymbol}',
                                      style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24),
                                          maxLines: 1
                                  ),
                                    )
                                ],
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(onPressed: (){
                                    _currentLimit=state.listDetails[index].limitTranslation;
                                    context.read<MemberShipBloc>().add(BuySubscriptionEvent(productPurchaseModel:state.listDetails[index]));
                                  },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(colorBackground),
                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                      ))
                                    ),
                                      child:  Text('Buy'.tr(),
                                          style:  const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),),
                                )
                              ],
                            ),
                          ),

                      Visibility(
                        visible:state.listDetails[index].isSale,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,top: 10),
                          child:  CornerBanner(
                            elevation: 10,
                          bannerPosition: CornerBannerPosition.topLeft,
                          bannerColor: colorRed,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Sale'.tr(),
                        style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                              Text(' ${state.listDetails[index].priceSale}%',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ],
                          )),
                          ),
                      ),
                      ],
                      );
                    })
                ],
              ),
            );
          }
        ),
      ),
    );
  }

   String _getPrice(double rawPrice){
    int p1=rawPrice.toInt();
    String price='';
    if(rawPrice>p1){
      price=rawPrice.toString();
    }else{
      price=rawPrice.toInt().toString();
    }

    return price;
   }
}