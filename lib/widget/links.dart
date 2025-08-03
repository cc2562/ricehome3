import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ricehome3/generated/assets.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Links extends StatefulWidget {
  const Links({super.key});

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.fromLTRB(40, 0, 20, 110),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: chooseAxisCount(),childAspectRatio: ResponsiveBreakpoints.of(context).isMobile?3:2.5,crossAxisSpacing: 1.w),
            children: [
              //小世界
              Bounceable(
                onTap: () {
                  launchUrl(Uri.parse('https://world.ccrice.com'));
                },
                child: Container(
                  margin: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0),
                  padding: EdgeInsetsGeometry.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        offset: const Offset(0, 14),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Visibility(
                        visible: false,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(Assets.assetsTopimage),
                            width: 10.w,
                            height: 10.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: ClipOval(
                          child: Icon(
                            Ionicons.logo_rss,
                            size: chooseIconSize(),
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "米饭的小世界",
                            style: TextStyle(
                              fontSize: chooseTextSize(),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "是米饭的个人博客",
                            style: TextStyle(
                              fontSize: chooseTextSize(),
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //小仓库
              Bounceable(
                onTap: () {
                  launchUrl(Uri.parse('https://box.ccrice.com'));
                },
                child: Container(
                  padding: EdgeInsetsGeometry.all(2.w),
                  margin: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        offset: const Offset(0, 14),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Visibility(
                        visible: false,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(Assets.assetsTopimage),
                            width: 10.w,
                            height: 10.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: ClipOval(
                          child: Icon(
                            Ionicons.cube,
                            size: chooseIconSize(),
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "米饭的仓库",
                            style: TextStyle(
                              fontSize: chooseTextSize(),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "记录一些创意",
                            style: TextStyle(
                              fontSize: chooseTextSize(),
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Bounceable(
                onTap: () {
                  launchUrl(Uri.parse('https://github.com/cc2562'));
                },
                child: Container(
                  padding: EdgeInsetsGeometry.all(2.w),
                  margin: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        offset: const Offset(0, 14),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Visibility(
                        visible: false,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(Assets.assetsTopimage),
                            width: 10.w,
                            height: 10.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: ClipOval(
                          child: Icon(
                            Ionicons.logo_github,
                            size: chooseIconSize(),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "GitHub",
                            style: TextStyle(
                              fontSize: chooseTextSize(),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "关注CC米饭",
                            style: TextStyle(
                              fontSize: chooseTextSize(),
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  int chooseAxisCount(){
    if(ResponsiveBreakpoints.of(context).isMobile){
      return 1;
    }else if(ResponsiveBreakpoints.of(context).isDesktop){
      return 2;
    }else{
      return 4;
    }
  }

  double chooseTextSize(){
    if(ResponsiveBreakpoints.of(context).smallerOrEqualTo(DESKTOP)){
      return 16.sp;
    }else{
      return 13.sp;
    }
  }
  double chooseIconSize(){
    if(ResponsiveBreakpoints.of(context).smallerOrEqualTo(DESKTOP)){
      return 8.w;
    }else{
      return 4.w;
    }
  }
}
