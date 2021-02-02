import 'package:confetti/confetti.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';

class KycOnboardData {
  int level = 3;
  ConfettiController _confeticontroller = new ConfettiController(
    duration: new Duration(seconds: 2),
  );

  stepButtonAction(int step, BuildContext context) {
    if (step == 0) {
      print("you are at step 1");
    } else if (step == 1) {
      print("you are at step 2");
    } else if (step == 2) {
      print("you are at step 3");
    } else if (step == 3) {
      print("you are at step 4");
    } else if (step == 4) {
      print("you are at step 5");
    } else if (step == 5) {
      print("you are at step 6");
    } else if (step == 6) {
      print("you are at step 7");
    } else if (step == 7) {
      print("you are at step 8");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              width: 300,
              padding: EdgeInsets.all(40),
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Scratcher(
                        brushSize: 30,
                        threshold: 50,
                        image: Image.network(
                          "https://jooinn.com/images/green-background-pattern-1.png",
                          fit: BoxFit.cover,
                        ),
                        onChange: (value) => print("Scratch progress: $value%"),
                        onThreshold: () => print("Threshold reached, you won!"),
                        child: Container(
                          // height: 170,
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              "https://babblesports.com/wp-content/uploads/2020/06/Untitled-design-7-1200x675.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: ConfettiWidget(
                      blastDirectionality: BlastDirectionality.explosive,
                      confettiController: _confeticontroller,
                      particleDrag: 0.05,
                      emissionFrequency: 0.05,
                      numberOfParticles: 25,
                      gravity: 0.05,
                      shouldLoop: false,
                      colors: [
                        UiConstants.primaryColor,
                        Colors.grey,
                        Colors.yellow,
                        Colors.blue,
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }
}
