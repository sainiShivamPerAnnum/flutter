import 'package:flutter/material.dart';

class Game {
  final String name;
  final String title;
  final String description;
  final Color color;
  final List<Hotel> hotels;

  Game({
    this.title,
    this.name,
    this.description,
    this.color,
    this.hotels,
  });
}

class Hotel {
  final String name;
  double rate;
  final int reviews;
  final int price;

  Hotel(this.name, {this.reviews, this.price}) : rate = 5.0;
}

class DemoData {
  List<Game> _cities = [
    Game(
      name: 'Tambola',
      title: 'New Tambola',
      description: 'Test',
      color: Color(0xffdee5cf),
    ),
    Game(
      name: 'Tambola',
      title: 'Tambola',
      description: 'Play Tambola and win exciting prizes',
      color: Color(0xffdee5cf),
    ),
    Game(
      name: 'GamePoll',
      title: 'Next Game',
      description: 'Vote for the next game you want on fello',
      color: Color(0xffdaf3f7),
    ),
  ];

  List<Game> getCities() => _cities;
  List<Hotel> getHotels(Game Game) => Game.hotels;
}
