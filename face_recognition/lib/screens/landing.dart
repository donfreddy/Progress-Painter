import 'package:face_recognition/screens/register.dart';
import 'package:face_recognition/widgets/circle.dart';
import 'package:flutter/material.dart';

import 'camera.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width,
      /* decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ), */
     color: Color(0xFF1A9E8E), 
      //color: Colors.white,
      child: Stack(
        //alignment: AlignmentDirectional.centerEnd,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 Container(
                alignment: Alignment.topRight,
                child: CustomPaint(
                  painter: CircleTop(),
                ),
              ),
             
                Expanded(child: Container(child: Image.asset("assets/img/logo.png", width: 300,),)),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      color: Color(0xFFF38016),
                      onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => Camera(),
                            ),
                          );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      color: Color(0xFFF38016),
                      onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(

                  height: 100.0,
                ),
                 Container(
                alignment: Alignment.bottomLeft,
                child: CustomPaint(
                  painter: CircleBottom(),
                ),
              ),
                
              ],
            ),
            
          ),
          
        ],
      ),
    );
  }
}
