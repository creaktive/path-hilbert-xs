#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <math.h>

#define MAX_BITS 32

static IV Pow2[MAX_BITS] = {
  0x00000001, 0x00000002, 0x00000004, 0x00000008,
  0x00000010, 0x00000020, 0x00000040, 0x00000080,
  0x00000100, 0x00000200, 0x00000400, 0x00000800,
  0x00001000, 0x00002000, 0x00004000, 0x00008000,
  0x00010000, 0x00020000, 0x00040000, 0x00080000,
  0x00100000, 0x00200000, 0x00400000, 0x00800000,
  0x01000000, 0x02000000, 0x04000000, 0x08000000,
  0x10000000, 0x20000000, 0x40000000, 0x80000000,
};

/* rotate/flip a quadrant appropriately */
static void hilbert_rot(IV n, IV *x, IV *y, IV rx, IV ry) {
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

static IV hilbert_valid_n(IV side) {
  IV e;
  for (e = 0; e < MAX_BITS; ++e) {
    if (side <= Pow2[e]) {
      break;
    }
  }
  if (e >= MAX_BITS) {
    /* This is BAAAAAAD */
    return 0;
  }

  return Pow2[e];
}

/* convert (x,y) to d */
static IV hilbert_xy2d(IV side, IV x, IV y) {
    IV n = hilbert_valid_n(side);
    IV d = 0;
    IV s;

    for (s = n / 2; s > 0; s /= 2) {
      IV rx = (x & s) > 0;
      IV ry = (y & s) > 0;
      d += s * s * ((3 * rx) ^ ry);
      hilbert_rot(s, &x, &y, rx, ry);
    }

    return d * side / n;
}

/* convert d to (x,y) */
static void hilbert_d2xy(IV side, IV d, IV *x, IV *y) {
    IV n = hilbert_valid_n(side);
    IV t = d;
    IV s;

    *x = 0;
    *y = 0;

    for (s = 1; s < n; s *= 2) {
      IV rx = 1 & (t / 2);
      IV ry = 1 & (t ^ rx);
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
IV
xy2d(IV side, IV x, IV y)

  CODE:
    RETVAL = hilbert_xy2d(side, x, y);

  OUTPUT: RETVAL


# convert d to (x,y)
void
d2xy(IV side, IV d)

  PREINIT:
    IV x;
    IV y;

  PPCODE:
    hilbert_d2xy(side, d, &x, &y);

    EXTEND(SP, 2);
    mPUSHi(x);
    mPUSHi(y);
