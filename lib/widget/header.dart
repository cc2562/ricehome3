import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool isS = false;
  List<bool> slist= [true,false,false];
  @override
  Widget build(BuildContext context) {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        TextButton(onPressed: (){
          setState(() {
            setSelectFunc(0);
          });
        }, child:topHeaderText('主页', 0),),
        TextButton(onPressed: (){
          setState(() {
            setSelectFunc(1);
          });
        }, child:topHeaderText('关于', 1),),
        TextButton(onPressed: (){
          setState(() {
            setSelectFunc(2);
          });
        }, child:topHeaderText('链接', 2),),
      ],
    );
  }
  void setSelectFunc(int selectNumber){
    for(int i=0;i<3;i++){
      if(i == selectNumber){
        slist[i] = true;
      }else{
        slist[i] = false;
      }
    }
  }
  Widget topHeaderText(String showText,int number){
    return AnimatedDefaultTextStyle(
      child: Text('dhdd'),
      style: slist[number]?TextStyle(fontSize: 28.sp,fontWeight: FontWeight.bold,color: Colors.white):TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.grey.shade200),
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
    );
  }
}
