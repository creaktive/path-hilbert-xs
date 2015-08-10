#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <math.h>

/* rotate/flip a quadrant appropriately */
static void hilbert_rot(int n, int *x, int *y, int rx, int ry) {
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

static int hilbert_valid_n(int side) {
  double rv = pow(2, (int) ((log(side) / log(2)) + 0.5));
  return (int) rv;
}

/* convert (x,y) to d */
static int hilbert_xy2d(int side, int x, int y) {
    int n = hilbert_valid_n(side);
    int d = 0;
    int s;

    for (s = n / 2; s > 0; s /= 2) {
      int rx = (x & s) > 0;
      int ry = (y & s) > 0;
      d += s * s * ((3 * rx) ^ ry);
      hilbert_rot(s, &x, &y, rx, ry);
    }

    return d * side / n;
}

/* convert d to (x,y) */
static void hilbert_d2xy(int side, int d, int *x, int *y) {
    int n = hilbert_valid_n(side);
    int t = d;
    int s;

    *x = 0;
    *y = 0;

    for (s = 1; s < n; s *= 2) {
      int rx = 1 & (t / 2);
      int ry = 1 & (t ^ rx);
      hilbert_rot(s, x, y, rx, ry);
      *x += s * rx;
      *y += s * ry;
      t /= 4;
    }
    *x *= side / n;
    *y *= side / n;
}


MODULE = Path::Hilbert::XS		PACKAGE = Path::Hilbert::XS
PROTOTYPES: DISABLE

# convert (x,y) to d
int
xy2d(int side, int x, int y)

  CODE:
    RETVAL = hilbert_xy2d(side, x, y);

  OUTPUT: RETVAL


# convert d to (x,y)
void
d2xy(int side, int d)

  PREINIT:
    int x;
    int y;

  PPCODE:
    hilbert_d2xy(side, d, &x, &y);

    EXTEND(SP, 2);
    mPUSHi(x);
    mPUSHi(y);
    PUTBACK;
