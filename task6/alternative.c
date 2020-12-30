static double __attribute__ ((noinline)) check_flt(double a, double b, double c, double d, double e,
                        double f, double g, double h)
{
  int rax;
  a = a + b;
  c = c - d;
  e = e * 8;
  f = f * 4;
  g = g / 2;
  h = h / 4;
  
  rax = e;
  rax = rax + f;
  rax = rax - g;
  rax = rax + h;
  
  rax = rax * a;
  rax = rax * c;
  
  rax = a / 3;
	return rax;
}

static int32_t __attribute__ ((noinline)) check_int(int32_t a, int32_t b, int32_t c, int32_t d, int32_t e,
                         int32_t f, int32_t g, int32_t h)
{
  a = a + b;
  c = c - d;
  e = e * 8;
  f = f * 4;
  g = g / 2;
  h = h / 4;
  
  e = e + f;
  e = e - g;
  e = e + h;
  
  a = a * c;
  a = a * e;
  
  a = a / 3;
	return a;
}

static int32_t __attribute__ ((noinline)) check_int_shift(int32_t a, int32_t b, int32_t c, int32_t d,
                               int32_t e, int32_t f, int32_t g, int32_t h)
{
  a = a + b;
  c = c - d;
  e = e << 3;
  f = f << 2;
  g = g >> 1;
  h = h >> 2;
  
  e = e + f;
  e = e - g;
  e = e + h;
  
  a = a * c;
  a = a * e;
  
  a = a / 3;
	return a;
	return (((a + b) * (c - d)) *
	        ((e << 3) + (f << 2) - (g >> 1) + (h >> 2))) /
	       3;
}
