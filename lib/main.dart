import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:motion/motion.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ricehome3/widget/about.dart';
import 'package:ricehome3/widget/links.dart';
import 'package:ricehome3/widget/mainland.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  await Motion.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context,orientation,screenType){
      return MaterialApp(
        title: '米饭的主页',
        theme: ThemeData(
          fontFamily: 'healthy',
          fontFamilyFallback: [
            'Arial',
            "Noto Sans Symbols",
            '华文细黑',
            'Microsoft YaHei',
            '微软雅黑',
            'Roboto',
            'sans-serif'
          ],
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 1440, name: DESKTOP),
            const Breakpoint(start: 1441, end: double.infinity, name: '4K'),
          ],
        ),
        initialRoute: "/",
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isS = false;
  List<bool> slist= [true,false,false];
  List<Color> colorList =[Color(0xff687FE5),Color(0xffA2AADB),Color(0xffEBD6FB)];
  List<Color> colorListEnd = [Color(0xffA2AADB),Color(0xffEBD6FB),Color(0xff725CAD)];
  PageController pageController = PageController();
  int chooseColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: ResponsiveBreakpoints.of(context).largerThan(MOBILE)?EdgeInsetsGeometry.fromLTRB(100, 20, 100, 20):EdgeInsetsGeometry.all(0),
        child: AnimatedContainer(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            //color: colorList[chooseColor],
            gradient:  LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorList[chooseColor],
                  colorListEnd[chooseColor],
                ]),
            borderRadius: ResponsiveBreakpoints.of(context).largerThan(MOBILE)?BorderRadius.all(Radius.circular(20)):BorderRadius.all(Radius.circular(0)),
          ),
          duration: Duration(milliseconds: 300),
          child: Stack(
            children: [
              PageView(
                onPageChanged: (i){
                  print(i);
                  setState(() {
                    setSelectFunc(i);
                    chooseColor = i;
                  });
                },
                scrollDirection: Axis.vertical,
                controller: pageController,
                children: [
                  Mainland(),
                  About(),
                  Links(),
                ],
              ),
              HeaderWidget(),
              Container(
                margin: EdgeInsets.fromLTRB(40, 0, 20, 20),
                alignment: Alignment.bottomLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("立即前往：",style: TextStyle(fontSize: ResponsiveBreakpoints.of(context).largerThan(DESKTOP)?14.sp:18.sp,fontWeight: FontWeight.normal,color: Colors.white),),
                    TextButton.icon(
                      icon: Icon(Ionicons.logo_rss,size: 18.sp,color: Colors.white,),
                      onPressed: () {
                        launchUrl(Uri.parse('https://world.ccrice.com'));
                      },
                      label: Text("小世界",style: TextStyle(fontSize: 18.sp,color: Colors.white,),),
                    ),
                    TextButton.icon(
                      icon: Icon(Ionicons.cube,size: 18.sp,color: Colors.white,),
                      onPressed: () {
                        launchUrl(Uri.parse('https://box.ccrice.com'));
                      },
                      label: Text("小盒子",style: TextStyle(fontSize: 18.sp,color: Colors.white,),),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget HeaderWidget(){
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        TextButton(onPressed: (){
          setState(() {
            pageController.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
            setSelectFunc(0);
          });
        }, child:topHeaderText('主页', 0),),
        TextButton(onPressed: (){
          setState(() {
            pageController.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
            setSelectFunc(1);
          });
        }, child:topHeaderText('关于', 1),),
        TextButton(onPressed: (){
          pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
          setState(() {
            setSelectFunc(2);
          });
        }, child:topHeaderText('链接', 2),),
      ],
    );
  }
  bool setSelectFunc(int selectNumber){
    for(int i=0;i<3;i++){
      if(i == selectNumber){
        slist[i] = true;
      }else{
        slist[i] = false;
      }
    }
    return true;
  }
  Widget topHeaderText(String showText,int number){
    return AnimatedDefaultTextStyle(
      style: slist[number]?TextStyle(fontSize: 28.sp,fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'healthy'):TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.grey.shade200,fontFamily: 'healthy'),
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
      child: Text(showText),
    );
  }
}
