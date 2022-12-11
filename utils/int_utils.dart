/// Return the lowest common multiple of two integers.
int lcm(int a, int b) => (a * b) ~/ a.gcd(b);
