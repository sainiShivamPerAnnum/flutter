enum LoadState { loading, success, failure }

enum Direction { up, down, left, right }

class VerticalDragInfo {
  bool cancel = false;

  Direction? direction;

  void update(double primaryDelta) {
    Direction tmpDirection;

    tmpDirection = primaryDelta > 0 ? Direction.down : Direction.up;

    if (direction != null && tmpDirection != direction) {
      cancel = true;
    }

    direction = tmpDirection;
  }
}
