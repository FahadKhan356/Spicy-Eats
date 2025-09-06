import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoardingScreenWidget extends StatelessWidget {
  const BoardingScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.orange),
      actions: [
        TextButton(onPressed: (){},child: Text('Skip',style: TextStyle(color: Colors.orange),),)
      ],
      
      ),
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          height: 300,
          width: double.maxFinite,
          decoration: BoxDecoration(
            boxShadow: [
           
            ],
            image: DecorationImage(image: AssetImage('lib/assets/images/onboarding3.png',),fit: BoxFit.contain)),

        ),
        Text('Healthy & Tasty',style: GoogleFonts.rubik(fontSize: 25,fontWeight: FontWeight.w500),) ,
SizedBox(height: 20,),
            Text('Eat today and live another \n another memorable dayrrr',style: GoogleFonts.rubik(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.grey[300]),) ,
SizedBox(height: 20,),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index)=>Container(margin: EdgeInsets.all(8), height:index==0? 10:8,width:index==0? 10:8,
  decoration: BoxDecoration(color:index==0?  Colors.orange:Colors.grey[300] ,shape: BoxShape.circle),
  )),),

Spacer(),
Padding(
  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
  child: SizedBox(
    height: 65,
    width: double.maxFinite,
    child: ElevatedButton(onPressed:(){}, child: Text('Next',style: GoogleFonts.rubik(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),)),
)

      ],)
    );
  }
}