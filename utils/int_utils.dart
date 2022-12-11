/// Return the greatest common divisor of two integers.
int gcd(int a, int b) {
  int localA = a;
  int localB = b;
  while (localB != 0) {
    final temp = localB;
    localB = localA % localB;
    localA = temp;
  }
  return localA;
}

/// Return the lowest common multiple of two integers.
int lcm(int a, int b) {
  return (a * b) ~/ gcd(a, b);
}
