import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CusinesList extends StatelessWidget {
  const CusinesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cusines.length,
        itemBuilder: ((context, index) => Column(
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        cusineImages[index],
                        fit: BoxFit.cover,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(cusines[index])
              ],
            )),
      ),
    );
  }
}

var cusines = [
  'Italian',
  'Asian',
  'Breakfast',
  'Pizza',
  'Chinese',
  'Red Meat',
  'Vegetarian',
  'Barbeque',
  'Burger',
  'Sweet'
];

List<String> cusineImages = [
  'https://static.vecteezy.com/system/resources/thumbnails/025/250/387/small_2x/delicious-italian-food-clipart-cartoon-spaghetti-illustration-generative-ai-png.png',
  'https://luluwild.co.uk/wp-content/uploads/2023/07/pan-asian-vs-chinese-cousine-1024x771.jpeg',
  'https://www.calgarycoop.com/wp-content/uploads/2023/08/Wk-36-Classic-Breakfast-1.jpg',
  'https://www.moulinex-me.com/medias/?context=bWFzdGVyfHJvb3R8MTQzNTExfGltYWdlL2pwZWd8YUdObEwyaG1aQzh4TlRrMk9EWXlOVGM0TmpreE1DNXFjR2N8MmYwYzQ4YTg0MTgzNmVjYTZkMWZkZWZmMDdlMWFlMjRhOGIxMTQ2MTZkNDk4ZDU3ZjlkNDk2MzMzNDA5OWY3OA',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcJyyJ3TE3DSaC-XK5t0-cmUuyoDW3TwPOOQ&s',
  'https://static.vecteezy.com/system/resources/thumbnails/025/250/387/small_2x/delicious-italian-food-clipart-cartoon-spaghetti-illustration-generative-ai-png.png',
  'https://luluwild.co.uk/wp-content/uploads/2023/07/pan-asian-vs-chinese-cousine-1024x771.jpeg',
  'https://www.calgarycoop.com/wp-content/uploads/2023/08/Wk-36-Classic-Breakfast-1.jpg',
  'https://www.moulinex-me.com/medias/?context=bWFzdGVyfHJvb3R8MTQzNTExfGltYWdlL2pwZWd8YUdObEwyaG1aQzh4TlRrMk9EWXlOVGM0TmpreE1DNXFjR2N8MmYwYzQ4YTg0MTgzNmVjYTZkMWZkZWZmMDdlMWFlMjRhOGIxMTQ2MTZkNDk4ZDU3ZjlkNDk2MzMzNDA5OWY3OA',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcJyyJ3TE3DSaC-XK5t0-cmUuyoDW3TwPOOQ&s',
];
