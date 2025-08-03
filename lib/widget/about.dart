import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:motion/motion.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../generated/assets.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Motion.elevated(
          shadow: false,
          glare: false,
          elevation: 30,
          child:Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image(image: AssetImage(Assets.assetsAboutimage),fit: BoxFit.cover,),
              )
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.fromLTRB(40, 0, 20, 200),
          alignment: Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextAnimator('你好呀,我是CC米饭', atRestEffect: WidgetRestingEffects.none(),style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white),),
              TextAnimator('欢迎远道而来的客人降落在这个世界', atRestEffect: WidgetRestingEffects.none(),style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.normal,color: Colors.white),),
              SizedBox(height: 1.h,),
              Container(
                padding: EdgeInsetsGeometry.all(1.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextButton.icon(
                  icon: Icon(Icons.add,size: 16.sp,color: Colors.black,weight: 100,),
                  onPressed: () {
                    showDialog<int>(
                      context: context,
                      builder: (BuildContext context) {
                        var child =moreAboutMe();
                        return Dialog(child: child);
                      },
                    );
                  },
                  label: Text("了解更多",style: TextStyle(fontSize: 16.sp,color: Colors.black,fontWeight: FontWeight.normal),),
                )
              )
            ],
          ),
        ),
      ],
    );
  }
  Future<String> loadAboutMeDoc() async {
    final String aboutMeDoc = await rootBundle.loadString(Assets.assetsAboutme);
    return aboutMeDoc;
  }
  Widget moreAboutMe(){
       return Container(
      padding: EdgeInsetsGeometry.all(20),
      width: double.infinity-10.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('关于CC米饭',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.black),),
              IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Ionicons.close,size: 20.sp,color: Colors.black,),)
            ],
          ),
          EnhancedFutureBuilder(future: loadAboutMeDoc(), rememberFutureResult: true, whenDone: (data){
            return Container(
                height: 81.h,
                padding: ResponsiveBreakpoints.of(context).smallerOrEqualTo(DESKTOP)?EdgeInsetsGeometry.all(0):EdgeInsetsGeometry.fromLTRB(15.w, 0, 15.w, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: ListView(
                  //physics: NeverScrollableScrollPhysics(),
                  children: [
                    MarkdownBlock(data: data)
                  ],
                )
            );
          }, whenNotDone: CircularProgressIndicator())
        ],
      ),
    );
  }
}
