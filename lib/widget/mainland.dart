import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:motion/motion.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ricehome3/generated/assets.dart';
import 'package:sizer/sizer.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class Mainland extends StatefulWidget {
  const Mainland({super.key});

  @override
  State<Mainland> createState() => _MainlandState();
}

class _MainlandState extends State<Mainland> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Motion.elevated(
          shadow: false,
          glare: false,
          elevation: 30,
          child:Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image(image: AssetImage(Assets.assetsTopimage),fit: BoxFit.cover,),
              )
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.fromLTRB(40, 0, 20, 15.h),
          alignment: Alignment.bottomLeft,
          child: setSize(),
        ),

      ],
    );
  }
  Widget setSize(){
    if(ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextAnimator('你好呀', atRestEffect: WidgetRestingEffects.none(),style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.bold,color: Colors.white),),
          TextAnimator('我是', atRestEffect: WidgetRestingEffects.none(),style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.bold,color: Colors.white),),
          TextAnimator('CC米饭', atRestEffect: WidgetRestingEffects.wave(),style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.bold,color: Colors.white),),
          TextAnimator('世界在此构建', atRestEffect: WidgetRestingEffects.none(),style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.normal,color: Colors.white),),
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextAnimator('你好呀 ', atRestEffect: WidgetRestingEffects.none(),style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.bold,color: Colors.white),),
          TextAnimator('我是 ', atRestEffect: WidgetRestingEffects.none(),style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.bold,color: Colors.white),),
          TextAnimator('CC米饭 ', atRestEffect: WidgetRestingEffects.wave(),style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.bold,color: Colors.white),),
          TextAnimator('世界在此构建 ', atRestEffect: WidgetRestingEffects.none(),style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.normal,color: Colors.white),),
        ],
      );
    }
  }
  @override
  bool get wantKeepAlive => true;
}
