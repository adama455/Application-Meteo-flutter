import 'package:appmeteo/models/constants.dart';
import 'package:appmeteo/view/weather_page.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: myConstants.primaryColor.withOpacity(.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/clear.png'),
              const SizedBox(height: 30),
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeatherPage()));
                  },
                  child: Container(
                    height: 50,
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: myConstants.primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Text('Get Started',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
