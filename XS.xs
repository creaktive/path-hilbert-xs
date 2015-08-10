#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <math.h>

/* rotate/flip a quadrant appropriately */
static void rot(int n, int *x, int *y, int rx, int ry) {
  if (ry) {
    return;
  }

  if (rx) {
    *x = n - 1 - *x;
    *y = n - 1 - *y;
  }

  /* swap x and y, reusing ry shamelessly */
  ry  = *x;
  *x = *y;
  *y = ry;
}

static int valid_n(int side) {
  double rv = pow(2, (int) ((log(side) / log(2)) + 0.5));
  return (int) rv;
}

MODULE = Path::Hilbert::XS		PACKAGE = Path::Hilbert::XS
PROTOTYPES: DISABLE

# convert (x,y) to d
int
xy2d(int side, int x, int y)

  PREINIT:
    int n;
    int d;
    int s;

  CODE:
    n = valid_n(side);
    d = 0;

    for (s = n / 2; s > 0; s /= 2) {
      int rx = (x & s) > 0;
      int ry = (y & s) > 0;
      d += s * s * ((3 * rx) ^ ry);
      rot(s, &x, &y, rx, ry);
    }

    RETVAL = d * side / n;

  OUTPUT: RETVAL


# convert d to (x,y)
void
d2xy(int side, int d)

  PREINIT:
    int n;
    int t;
    int s;
    int x;
    int y;

  PPCODE:
    n = valid_n(side);
    t = d;
    x = y = 0;
    for (s = 1; s < n; s *= 2) {
      int rx = 1 & (t / 2);
      int ry = 1 & (t ^ rx);
      rot(s, &x, &y, rx, ry);
      x += s * rx;
      y += s * ry;
      t /= 4;
    }
    x *= side / n;
    y *= side / n;

    EXTEND(SP, 2);
    mPUSHi(x);
    mPUSHi(y);
    PUTBACK;
