// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * ABDK Math 64.64 Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
 * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
 */

/**
 * Smart contract library of mathematical functions operating with signed
 * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
 * basically a simple fraction whose numerator is signed 128-bit integer and
 * denominator is 2^64.  As long as denominator is always the same, there is no
 * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
 * represented by int128 type holding only the numerator.
 */
library ABDKMath64x64 {
  /*
   * Minimum value signed 64.64-bit fixed point number may have. 
   */
  int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;

  /*
   * Maximum value signed 64.64-bit fixed point number may have. 
   */
  int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

  /**
   * Convert signed 256-bit integer number into signed 64.64-bit fixed point
   * number.  Revert on overflow.
   *
   * @param x signed 256-bit integer number
   * @return signed 64.64-bit fixed point number
   */
  function fromInt (int256 x) internal pure returns (int128) {
    unchecked {
      require (x >= -0x8000000000000000 && x <= 0x7FFFFFFFFFFFFFFF);
      return int128 (x << 64);
    }
  }

  /**
   * Convert signed 64.64 fixed point number into signed 64-bit integer number
   * rounding down.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64-bit integer number
   */
  function toInt (int128 x) internal pure returns (int64) {
    unchecked {
      return int64 (x >> 64);
    }
  }

  /**
   * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
   * number.  Revert on overflow.
   *
   * @param x unsigned 256-bit integer number
   * @return signed 64.64-bit fixed point number
   */
  function fromUInt (uint256 x) internal pure returns (int128) {
    unchecked {
      require (x <= 0x7FFFFFFFFFFFFFFF);
      return int128 (int256 (x << 64));
    }
  }

  /**
   * Convert signed 64.64 fixed point number into unsigned 64-bit integer
   * number rounding down.  Revert on underflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @return unsigned 64-bit integer number
   */
  function toUInt (int128 x) internal pure returns (uint64) {
    unchecked {
      require (x >= 0);
      return uint64 (uint128 (x >> 64));
    }
  }

  /**
   * Convert signed 128.128 fixed point number into signed 64.64-bit fixed point
   * number rounding down.  Revert on overflow.
   *
   * @param x signed 128.128-bin fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function from128x128 (int256 x) internal pure returns (int128) {
    unchecked {
      int256 result = x >> 64;
      require (result >= MIN_64x64 && result <= MAX_64x64);
      return int128 (result);
    }
  }

  /**
   * Convert signed 64.64 fixed point number into signed 128.128 fixed point
   * number.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 128.128 fixed point number
   */
  function to128x128 (int128 x) internal pure returns (int256) {
    unchecked {
      return int256 (x) << 64;
    }
  }

  /**
   * Calculate x + y.  Revert on overflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @param y signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function add (int128 x, int128 y) internal pure returns (int128) {
    unchecked {
      int256 result = int256(x) + y;
      require (result >= MIN_64x64 && result <= MAX_64x64);
      return int128 (result);
    }
  }

  /**
   * Calculate x - y.  Revert on overflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @param y signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function sub (int128 x, int128 y) internal pure returns (int128) {
    unchecked {
      int256 result = int256(x) - y;
      require (result >= MIN_64x64 && result <= MAX_64x64);
      return int128 (result);
    }
  }

  /**
   * Calculate x * y rounding down.  Revert on overflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @param y signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function mul (int128 x, int128 y) internal pure returns (int128) {
    unchecked {
      int256 result = int256(x) * y >> 64;
      require (result >= MIN_64x64 && result <= MAX_64x64);
      return int128 (result);
    }
  }

  /**
   * Calculate x * y rounding towards zero, where x is signed 64.64 fixed point
   * number and y is signed 256-bit integer number.  Revert on overflow.
   *
   * @param x signed 64.64 fixed point number
   * @param y signed 256-bit integer number
   * @return signed 256-bit integer number
   */
  function muli (int128 x, int256 y) internal pure returns (int256) {
    unchecked {
      if (x == MIN_64x64) {
        require (y >= -0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF &&
          y <= 0x1000000000000000000000000000000000000000000000000);
        return -y << 63;
      } else {
        bool negativeResult = false;
        if (x < 0) {
          x = -x;
          negativeResult = true;
        }
        if (y < 0) {
          y = -y; // We rely on overflow behavior here
          negativeResult = !negativeResult;
        }
        uint256 absoluteResult = mulu (x, uint256 (y));
        if (negativeResult) {
          require (absoluteResult <=
            0x8000000000000000000000000000000000000000000000000000000000000000);
          return -int256 (absoluteResult); // We rely on overflow behavior here
        } else {
          require (absoluteResult <=
            0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
          return int256 (absoluteResult);
        }
      }
    }
  }

  /**
   * Calculate x * y rounding down, where x is signed 64.64 fixed point number
   * and y is unsigned 256-bit integer number.  Revert on overflow.
   *
   * @param x signed 64.64 fixed point number
   * @param y unsigned 256-bit integer number
   * @return unsigned 256-bit integer number
   */
  function mulu (int128 x, uint256 y) internal pure returns (uint256) {
    unchecked {
      if (y == 0) return 0;

      require (x >= 0);

      uint256 lo = (uint256 (int256 (x)) * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) >> 64;
      uint256 hi = uint256 (int256 (x)) * (y >> 128);

      require (hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
      hi <<= 64;

      require (hi <=
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF - lo);
      return hi + lo;
    }
  }

  /**
   * Calculate x / y rounding towards zero.  Revert on overflow or when y is
   * zero.
   *
   * @param x signed 64.64-bit fixed point number
   * @param y signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function div (int128 x, int128 y) internal pure returns (int128) {
    unchecked {
      require (y != 0);
      int256 result = (int256 (x) << 64) / y;
      require (result >= MIN_64x64 && result <= MAX_64x64);
      return int128 (result);
    }
  }

  /**
   * Calculate x / y rounding towards zero, where x and y are signed 256-bit
   * integer numbers.  Revert on overflow or when y is zero.
   *
   * @param x signed 256-bit integer number
   * @param y signed 256-bit integer number
   * @return signed 64.64-bit fixed point number
   */
  function divi (int256 x, int256 y) internal pure returns (int128) {
    unchecked {
      require (y != 0);

      bool negativeResult = false;
      if (x < 0) {
        x = -x; // We rely on overflow behavior here
        negativeResult = true;
      }
      if (y < 0) {
        y = -y; // We rely on overflow behavior here
        negativeResult = !negativeResult;
      }
      uint128 absoluteResult = divuu (uint256 (x), uint256 (y));
      if (negativeResult) {
        require (absoluteResult <= 0x80000000000000000000000000000000);
        return -int128 (absoluteResult); // We rely on overflow behavior here
      } else {
        require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        return int128 (absoluteResult); // We rely on overflow behavior here
      }
    }
  }

  /**
   * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
   * integer numbers.  Revert on overflow or when y is zero.
   *
   * @param x unsigned 256-bit integer number
   * @param y unsigned 256-bit integer number
   * @return signed 64.64-bit fixed point number
   */
  function divu (uint256 x, uint256 y) internal pure returns (int128) {
    unchecked {
      require (y != 0);
      uint128 result = divuu (x, y);
      require (result <= uint128 (MAX_64x64));
      return int128 (result);
    }
  }

  /**
   * Calculate -x.  Revert on overflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function neg (int128 x) internal pure returns (int128) {
    unchecked {
      require (x != MIN_64x64);
      return -x;
    }
  }

  /**
   * Calculate |x|.  Revert on overflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function abs (int128 x) internal pure returns (int128) {
    unchecked {
      require (x != MIN_64x64);
      return x < 0 ? -x : x;
    }
  }

  /**
   * Calculate 1 / x rounding towards zero.  Revert on overflow or when x is
   * zero.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function inv (int128 x) internal pure returns (int128) {
    unchecked {
      require (x != 0);
      int256 result = int256 (0x100000000000000000000000000000000) / x;
      require (result >= MIN_64x64 && result <= MAX_64x64);
      return int128 (result);
    }
  }

  /**
   * Calculate arithmetics average of x and y, i.e. (x + y) / 2 rounding down.
   *
   * @param x signed 64.64-bit fixed point number
   * @param y signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function avg (int128 x, int128 y) internal pure returns (int128) {
    unchecked {
      return int128 ((int256 (x) + int256 (y)) >> 1);
    }
  }

  /**
   * Calculate geometric average of x and y, i.e. sqrt (x * y) rounding down.
   * Revert on overflow or in case x * y is negative.
   *
   * @param x signed 64.64-bit fixed point number
   * @param y signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function gavg (int128 x, int128 y) internal pure returns (int128) {
    unchecked {
      int256 m = int256 (x) * int256 (y);
      require (m >= 0);
      require (m <
          0x4000000000000000000000000000000000000000000000000000000000000000);
      return int128 (sqrtu (uint256 (m)));
    }
  }

  /**
   * Calculate x^y assuming 0^0 is 1, where x is signed 64.64 fixed point number
   * and y is unsigned 256-bit integer number.  Revert on overflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @param y uint256 value
   * @return signed 64.64-bit fixed point number
   */
  function pow (int128 x, uint256 y) internal pure returns (int128) {
    unchecked {
      bool negative = x < 0 && y & 1 == 1;

      uint256 absX = uint128 (x < 0 ? -x : x);
      uint256 absResult;
      absResult = 0x100000000000000000000000000000000;

      if (absX <= 0x10000000000000000) {
        absX <<= 63;
        while (y != 0) {
          if (y & 0x1 != 0) {
            absResult = absResult * absX >> 127;
          }
          absX = absX * absX >> 127;

          if (y & 0x2 != 0) {
            absResult = absResult * absX >> 127;
          }
          absX = absX * absX >> 127;

          if (y & 0x4 != 0) {
            absResult = absResult * absX >> 127;
          }
          absX = absX * absX >> 127;

          if (y & 0x8 != 0) {
            absResult = absResult * absX >> 127;
          }
          absX = absX * absX >> 127;

          y >>= 4;
        }

        absResult >>= 64;
      } else {
        uint256 absXShift = 63;
        if (absX < 0x1000000000000000000000000) { absX <<= 32; absXShift -= 32; }
        if (absX < 0x10000000000000000000000000000) { absX <<= 16; absXShift -= 16; }
        if (absX < 0x1000000000000000000000000000000) { absX <<= 8; absXShift -= 8; }
        if (absX < 0x10000000000000000000000000000000) { absX <<= 4; absXShift -= 4; }
        if (absX < 0x40000000000000000000000000000000) { absX <<= 2; absXShift -= 2; }
        if (absX < 0x80000000000000000000000000000000) { absX <<= 1; absXShift -= 1; }

        uint256 resultShift = 0;
        while (y != 0) {
          require (absXShift < 64);

          if (y & 0x1 != 0) {
            absResult = absResult * absX >> 127;
            resultShift += absXShift;
            if (absResult > 0x100000000000000000000000000000000) {
              absResult >>= 1;
              resultShift += 1;
            }
          }
          absX = absX * absX >> 127;
          absXShift <<= 1;
          if (absX >= 0x100000000000000000000000000000000) {
              absX >>= 1;
              absXShift += 1;
          }

          y >>= 1;
        }

        require (resultShift < 64);
        absResult >>= 64 - resultShift;
      }
      int256 result = negative ? -int256 (absResult) : int256 (absResult);
      require (result >= MIN_64x64 && result <= MAX_64x64);
      return int128 (result);
    }
  }

  /**
   * Calculate sqrt (x) rounding down.  Revert if x < 0.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function sqrt (int128 x) internal pure returns (int128) {
    unchecked {
      require (x >= 0);
      return int128 (sqrtu (uint256 (int256 (x)) << 64));
    }
  }

  /**
   * Calculate binary logarithm of x.  Revert if x <= 0.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function log_2 (int128 x) internal pure returns (int128) {
    unchecked {
      require (x > 0);

      int256 msb = 0;
      int256 xc = x;
      if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
      if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
      if (xc >= 0x10000) { xc >>= 16; msb += 16; }
      if (xc >= 0x100) { xc >>= 8; msb += 8; }
      if (xc >= 0x10) { xc >>= 4; msb += 4; }
      if (xc >= 0x4) { xc >>= 2; msb += 2; }
      if (xc >= 0x2) msb += 1;  // No need to shift xc anymore

      int256 result = msb - 64 << 64;
      uint256 ux = uint256 (int256 (x)) << uint256 (127 - msb);
      for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
        ux *= ux;
        uint256 b = ux >> 255;
        ux >>= 127 + b;
        result += bit * int256 (b);
      }

      return int128 (result);
    }
  }

  /**
   * Calculate natural logarithm of x.  Revert if x <= 0.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function ln (int128 x) internal pure returns (int128) {
    unchecked {
      require (x > 0);

      return int128 (int256 (
          uint256 (int256 (log_2 (x))) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF >> 128));
    }
  }

  /**
   * Calculate binary exponent of x.  Revert on overflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function exp_2 (int128 x) internal pure returns (int128) {
    unchecked {
      require (x < 0x400000000000000000); // Overflow

      if (x < -0x400000000000000000) return 0; // Underflow

      uint256 result = 0x80000000000000000000000000000000;

      if (x & 0x8000000000000000 > 0)
        result = result * 0x16A09E667F3BCC908B2FB1366EA957D3E >> 128;
      if (x & 0x4000000000000000 > 0)
        result = result * 0x1306FE0A31B7152DE8D5A46305C85EDEC >> 128;
      if (x & 0x2000000000000000 > 0)
        result = result * 0x1172B83C7D517ADCDF7C8C50EB14A791F >> 128;
      if (x & 0x1000000000000000 > 0)
        result = result * 0x10B5586CF9890F6298B92B71842A98363 >> 128;
      if (x & 0x800000000000000 > 0)
        result = result * 0x1059B0D31585743AE7C548EB68CA417FD >> 128;
      if (x & 0x400000000000000 > 0)
        result = result * 0x102C9A3E778060EE6F7CACA4F7A29BDE8 >> 128;
      if (x & 0x200000000000000 > 0)
        result = result * 0x10163DA9FB33356D84A66AE336DCDFA3F >> 128;
      if (x & 0x100000000000000 > 0)
        result = result * 0x100B1AFA5ABCBED6129AB13EC11DC9543 >> 128;
      if (x & 0x80000000000000 > 0)
        result = result * 0x10058C86DA1C09EA1FF19D294CF2F679B >> 128;
      if (x & 0x40000000000000 > 0)
        result = result * 0x1002C605E2E8CEC506D21BFC89A23A00F >> 128;
      if (x & 0x20000000000000 > 0)
        result = result * 0x100162F3904051FA128BCA9C55C31E5DF >> 128;
      if (x & 0x10000000000000 > 0)
        result = result * 0x1000B175EFFDC76BA38E31671CA939725 >> 128;
      if (x & 0x8000000000000 > 0)
        result = result * 0x100058BA01FB9F96D6CACD4B180917C3D >> 128;
      if (x & 0x4000000000000 > 0)
        result = result * 0x10002C5CC37DA9491D0985C348C68E7B3 >> 128;
      if (x & 0x2000000000000 > 0)
        result = result * 0x1000162E525EE054754457D5995292026 >> 128;
      if (x & 0x1000000000000 > 0)
        result = result * 0x10000B17255775C040618BF4A4ADE83FC >> 128;
      if (x & 0x800000000000 > 0)
        result = result * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB >> 128;
      if (x & 0x400000000000 > 0)
        result = result * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9 >> 128;
      if (x & 0x200000000000 > 0)
        result = result * 0x10000162E43F4F831060E02D839A9D16D >> 128;
      if (x & 0x100000000000 > 0)
        result = result * 0x100000B1721BCFC99D9F890EA06911763 >> 128;
      if (x & 0x80000000000 > 0)
        result = result * 0x10000058B90CF1E6D97F9CA14DBCC1628 >> 128;
      if (x & 0x40000000000 > 0)
        result = result * 0x1000002C5C863B73F016468F6BAC5CA2B >> 128;
      if (x & 0x20000000000 > 0)
        result = result * 0x100000162E430E5A18F6119E3C02282A5 >> 128;
      if (x & 0x10000000000 > 0)
        result = result * 0x1000000B1721835514B86E6D96EFD1BFE >> 128;
      if (x & 0x8000000000 > 0)
        result = result * 0x100000058B90C0B48C6BE5DF846C5B2EF >> 128;
      if (x & 0x4000000000 > 0)
        result = result * 0x10000002C5C8601CC6B9E94213C72737A >> 128;
      if (x & 0x2000000000 > 0)
        result = result * 0x1000000162E42FFF037DF38AA2B219F06 >> 128;
      if (x & 0x1000000000 > 0)
        result = result * 0x10000000B17217FBA9C739AA5819F44F9 >> 128;
      if (x & 0x800000000 > 0)
        result = result * 0x1000000058B90BFCDEE5ACD3C1CEDC823 >> 128;
      if (x & 0x400000000 > 0)
        result = result * 0x100000002C5C85FE31F35A6A30DA1BE50 >> 128;
      if (x & 0x200000000 > 0)
        result = result * 0x10000000162E42FF0999CE3541B9FFFCF >> 128;
      if (x & 0x100000000 > 0)
        result = result * 0x100000000B17217F80F4EF5AADDA45554 >> 128;
      if (x & 0x80000000 > 0)
        result = result * 0x10000000058B90BFBF8479BD5A81B51AD >> 128;
      if (x & 0x40000000 > 0)
        result = result * 0x1000000002C5C85FDF84BD62AE30A74CC >> 128;
      if (x & 0x20000000 > 0)
        result = result * 0x100000000162E42FEFB2FED257559BDAA >> 128;
      if (x & 0x10000000 > 0)
        result = result * 0x1000000000B17217F7D5A7716BBA4A9AE >> 128;
      if (x & 0x8000000 > 0)
        result = result * 0x100000000058B90BFBE9DDBAC5E109CCE >> 128;
      if (x & 0x4000000 > 0)
        result = result * 0x10000000002C5C85FDF4B15DE6F17EB0D >> 128;
      if (x & 0x2000000 > 0)
        result = result * 0x1000000000162E42FEFA494F1478FDE05 >> 128;
      if (x & 0x1000000 > 0)
        result = result * 0x10000000000B17217F7D20CF927C8E94C >> 128;
      if (x & 0x800000 > 0)
        result = result * 0x1000000000058B90BFBE8F71CB4E4B33D >> 128;
      if (x & 0x400000 > 0)
        result = result * 0x100000000002C5C85FDF477B662B26945 >> 128;
      if (x & 0x200000 > 0)
        result = result * 0x10000000000162E42FEFA3AE53369388C >> 128;
      if (x & 0x100000 > 0)
        result = result * 0x100000000000B17217F7D1D351A389D40 >> 128;
      if (x & 0x80000 > 0)
        result = result * 0x10000000000058B90BFBE8E8B2D3D4EDE >> 128;
      if (x & 0x40000 > 0)
        result = result * 0x1000000000002C5C85FDF4741BEA6E77E >> 128;
      if (x & 0x20000 > 0)
        result = result * 0x100000000000162E42FEFA39FE95583C2 >> 128;
      if (x & 0x10000 > 0)
        result = result * 0x1000000000000B17217F7D1CFB72B45E1 >> 128;
      if (x & 0x8000 > 0)
        result = result * 0x100000000000058B90BFBE8E7CC35C3F0 >> 128;
      if (x & 0x4000 > 0)
        result = result * 0x10000000000002C5C85FDF473E242EA38 >> 128;
      if (x & 0x2000 > 0)
        result = result * 0x1000000000000162E42FEFA39F02B772C >> 128;
      if (x & 0x1000 > 0)
        result = result * 0x10000000000000B17217F7D1CF7D83C1A >> 128;
      if (x & 0x800 > 0)
        result = result * 0x1000000000000058B90BFBE8E7BDCBE2E >> 128;
      if (x & 0x400 > 0)
        result = result * 0x100000000000002C5C85FDF473DEA871F >> 128;
      if (x & 0x200 > 0)
        result = result * 0x10000000000000162E42FEFA39EF44D91 >> 128;
      if (x & 0x100 > 0)
        result = result * 0x100000000000000B17217F7D1CF79E949 >> 128;
      if (x & 0x80 > 0)
        result = result * 0x10000000000000058B90BFBE8E7BCE544 >> 128;
      if (x & 0x40 > 0)
        result = result * 0x1000000000000002C5C85FDF473DE6ECA >> 128;
      if (x & 0x20 > 0)
        result = result * 0x100000000000000162E42FEFA39EF366F >> 128;
      if (x & 0x10 > 0)
        result = result * 0x1000000000000000B17217F7D1CF79AFA >> 128;
      if (x & 0x8 > 0)
        result = result * 0x100000000000000058B90BFBE8E7BCD6D >> 128;
      if (x & 0x4 > 0)
        result = result * 0x10000000000000002C5C85FDF473DE6B2 >> 128;
      if (x & 0x2 > 0)
        result = result * 0x1000000000000000162E42FEFA39EF358 >> 128;
      if (x & 0x1 > 0)
        result = result * 0x10000000000000000B17217F7D1CF79AB >> 128;

      result >>= uint256 (int256 (63 - (x >> 64)));
      require (result <= uint256 (int256 (MAX_64x64)));

      return int128 (int256 (result));
    }
  }

  /**
   * Calculate natural exponent of x.  Revert on overflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function exp (int128 x) internal pure returns (int128) {
    unchecked {
      require (x < 0x400000000000000000); // Overflow

      if (x < -0x400000000000000000) return 0; // Underflow

      return exp_2 (
          int128 (int256 (x) * 0x171547652B82FE1777D0FFDA0D23A7D12 >> 128));
    }
  }

  /**
   * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
   * integer numbers.  Revert on overflow or when y is zero.
   *
   * @param x unsigned 256-bit integer number
   * @param y unsigned 256-bit integer number
   * @return unsigned 64.64-bit fixed point number
   */
  function divuu (uint256 x, uint256 y) private pure returns (uint128) {
    unchecked {
      require (y != 0);

      uint256 result;

      if (x <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
        result = (x << 64) / y;
      else {
        uint256 msb = 192;
        uint256 xc = x >> 192;
        if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
        if (xc >= 0x10000) { xc >>= 16; msb += 16; }
        if (xc >= 0x100) { xc >>= 8; msb += 8; }
        if (xc >= 0x10) { xc >>= 4; msb += 4; }
        if (xc >= 0x4) { xc >>= 2; msb += 2; }
        if (xc >= 0x2) msb += 1;  // No need to shift xc anymore

        result = (x << 255 - msb) / ((y - 1 >> msb - 191) + 1);
        require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

        uint256 hi = result * (y >> 128);
        uint256 lo = result * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

        uint256 xh = x >> 192;
        uint256 xl = x << 64;

        if (xl < lo) xh -= 1;
        xl -= lo; // We rely on overflow behavior here
        lo = hi << 128;
        if (xl < lo) xh -= 1;
        xl -= lo; // We rely on overflow behavior here

        result += xh == hi >> 128 ? xl / y : 1;
      }

      require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
      return uint128 (result);
    }
  }

  /**
   * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
   * number.
   *
   * @param x unsigned 256-bit integer number
   * @return unsigned 128-bit integer number
   */
  function sqrtu (uint256 x) private pure returns (uint128) {
    unchecked {
      if (x == 0) return 0;
      else {
        uint256 xx = x;
        uint256 r = 1;
        if (xx >= 0x100000000000000000000000000000000) { xx >>= 128; r <<= 64; }
        if (xx >= 0x10000000000000000) { xx >>= 64; r <<= 32; }
        if (xx >= 0x100000000) { xx >>= 32; r <<= 16; }
        if (xx >= 0x10000) { xx >>= 16; r <<= 8; }
        if (xx >= 0x100) { xx >>= 8; r <<= 4; }
        if (xx >= 0x10) { xx >>= 4; r <<= 2; }
        if (xx >= 0x4) { r <<= 1; }
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1; // Seven iterations should be enough
        uint256 r1 = x / r;
        return uint128 (r < r1 ? r : r1);
      }
    }
  }
}

// Commonly used numbers as 64.64 fixed point
int128 constant _1 = 2 ** 64;
int128 constant _2 = 2 * 2 ** 64;
int128 constant _6 = 6 * 2 ** 64;
int128 constant _10 = 10 * 2 ** 64;
int128 constant _15 = 15 * 2 ** 64;

struct H {
  int16 X;
  int16 Y;
  int16 Z;
  int16 A;
  int16 AA;
  int16 AB;
  int16 B;
  int16 BA;
  int16 BB;
  int16 pX;
  int16 pA;
  int16 pB;
  int16 pAA;
  int16 pAB;
  int16 pBA;
  int16 pBB;
  int128 x;
  int128 y;
  int128 z;
  int128 u;
  int128 v;
  int128 w;
  int128 r;
}

struct H2 {
  int16 X;
  int16 Y;
  int16 A;
  int16 AA;
  int16 AB;
  int16 B;
  int16 BA;
  int16 BB;
  int16 pX;
  int16 pA;
  int16 pB;
  int128 x;
  int128 y;
  int128 u;
  int128 r;
}

/// @title Perlin noise library
/// @author alvarius
/// @notice Ported from perlin reference implementation (https://cs.nyu.edu/~perlin/noise/)
library PerlinV2 {

  function noise2d(int256 _x, int256 _y, int256 denom, uint8 precision) internal pure returns (int128) {
    H2 memory h = H2(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

    // Convert fraction into 64.64 fixed point number
    h.x = ABDKMath64x64.divi(_x, denom);
    h.y = ABDKMath64x64.divi(_y, denom);

    // Find unit cube that contains point
    h.X = int16(ABDKMath64x64.toInt(h.x)) & 0xff;
    h.Y = int16(ABDKMath64x64.toInt(h.y)) & 0xff;

    // Find relative x,y,z of point in cube
    h.x = ABDKMath64x64.sub(h.x, floor(h.x));
    h.y = ABDKMath64x64.sub(h.y, floor(h.y));

    // Compute fade curves for each x,y,z
    h.u = fade(h.x);

    // Hash coordinates of the 4 square corners
    h.pX = p2(h.X);
    h.A = i0(h.pX) + h.Y;
    h.pA = p2(h.A);
    h.AA = i0(h.pA);
    h.AB = i1(h.pA);
    h.B = i1(h.pX) + h.Y;
    h.pB = p2(h.B);
    h.BA = i0(h.pB);
    h.BB = i1(h.pB);

    // Add blended results from 4 corners of square
    h.r = lerp(
      fade(h.y),
      lerp(h.u, grad2d(int16(p(h.AA)), h.x, h.y), grad2d(int16(p(h.BA)), dec(h.x), h.y)),
      lerp(h.u, grad2d(int16(p(h.AB)), h.x, dec(h.y)), grad2d(int16(p(h.BB)), dec(h.x), dec(h.y)))
    );

    // Shift to range from 0 to 1
    return ABDKMath64x64.div(ABDKMath64x64.add(h.r, _1), _2) >> (64 - precision);
  }

  function noise(int256 _x, int256 _y, int256 _z, int256 denom, uint8 precision) internal pure returns (int128) {
    H memory h = H(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

    // Convert fraction into 64.64 fixed point number
    h.x = ABDKMath64x64.divi(_x, denom);
    h.y = ABDKMath64x64.divi(_y, denom);
    h.z = ABDKMath64x64.divi(_z, denom);

    // Find unit cube that contains point
    h.X = int16(ABDKMath64x64.toInt(h.x)) & 255;
    h.Y = int16(ABDKMath64x64.toInt(h.y)) & 255;
    h.Z = int16(ABDKMath64x64.toInt(h.z)) & 255;

    // Find relative x,y,z of point in cube
    h.x = ABDKMath64x64.sub(h.x, floor(h.x));
    h.y = ABDKMath64x64.sub(h.y, floor(h.y));
    h.z = ABDKMath64x64.sub(h.z, floor(h.z));

    // Compute fade curves for each x,y,z
    h.u = fade(h.x);
    h.v = fade(h.y);
    h.w = fade(h.z);

    // Hash coordinates of the 8 cube corners
    h.pX = p2(h.X);
    h.A = i0(h.pX) + h.Y;
    h.pA = p2(h.A);
    h.AA = i0(h.pA) + h.Z;
    h.AB = i1(h.pA) + h.Z;
    h.B = i1(h.pX) + h.Y;
    h.pB = p2(h.B);
    h.BA = i0(h.pB) + h.Z;
    h.BB = i1(h.pB) + h.Z;
    h.pAA = p2(h.AA);
    h.pAB = p2(h.AB);
    h.pBA = p2(h.BA);
    h.pBB = p2(h.BB);

    // Add blended results from 8 corners of cube
    h.r = lerp(
      h.w,
      lerp(
        h.v,
        lerp(h.u, grad(i0(h.pAA), h.x, h.y, h.z), grad(i0(h.pBA), dec(h.x), h.y, h.z)),
        lerp(h.u, grad(i0(h.pAB), h.x, dec(h.y), h.z), grad(i0(h.pBB), dec(h.x), dec(h.y), h.z))
      ),
      lerp(
        h.v,
        lerp(h.u, grad(i1(h.pAA), h.x, h.y, dec(h.z)), grad(i1(h.pBA), dec(h.x), h.y, dec(h.z))),
        lerp(h.u, grad(i1(h.pAB), h.x, dec(h.y), dec(h.z)), grad(i1(h.pBB), dec(h.x), dec(h.y), dec(h.z)))
      )
    );

    // Shift to range from 0 to 1
    return ABDKMath64x64.div(ABDKMath64x64.add(h.r, _1), _2) >> (64 - precision);
  }

  function dec(int128 x) internal pure returns (int128) {
    return ABDKMath64x64.sub(x, _1);
  }

  function floor(int128 x) internal pure returns (int128) {
    return ABDKMath64x64.fromInt(int256(ABDKMath64x64.toInt(x)));
  }

  /**
   * Computes t * t * t * (t * (t * 6 - 15) + 10)
   **/
  function fade(int128 t) internal pure returns (int128) {
    return ABDKMath64x64.mul(t, ABDKMath64x64.mul(t, ABDKMath64x64.mul(t, (ABDKMath64x64.add(ABDKMath64x64.mul(t, (ABDKMath64x64.sub(ABDKMath64x64.mul(t, _6), _15))), _10)))));
  }

  /**
   * Computes a + t * (b - a)
   **/
  function lerp(int128 t, int128 a, int128 b) internal pure returns (int128) {
    return ABDKMath64x64.add(a, ABDKMath64x64.mul(t, (ABDKMath64x64.sub(b, a))));
  }

  /**
   * Modified from original perlin paper based on http://riven8192.blogspot.com/2010/08/calculate-perlinnoise-twice-as-fast.html
   **/
  function grad(int16 _hash, int128 x, int128 y, int128 z) internal pure returns (int128) {
    // Convert lower 4 bits to hash code into 12 gradient directions
    int16 h = _hash & 0xF;

    if (h <= 0x7) {
      if (h <= 0x3) {
        if (h <= 0x1) {
          if (h == 0x0) return ABDKMath64x64.add(x, y);
          return ABDKMath64x64.sub(y, x);
        } else {
          if (h == 0x2) return ABDKMath64x64.sub(x, y);
          return ABDKMath64x64.sub(ABDKMath64x64.neg(x), y);
        }
      } else {
        if (h <= 0x5) {
          if (h == 0x4) return ABDKMath64x64.add(x, z);
          return ABDKMath64x64.sub(z, x);
        } else {
          if (h == 0x6) return ABDKMath64x64.sub(x, z);
          return ABDKMath64x64.sub(ABDKMath64x64.neg(x), z);
        }
      }
    } else {
      if (h <= 0xB) {
        if (h <= 0x9) {
          if (h == 0x8) return ABDKMath64x64.add(y, z);
          return ABDKMath64x64.sub(z, y);
        } else {
          if (h == 0xA) return ABDKMath64x64.sub(y, z);
          return ABDKMath64x64.sub(ABDKMath64x64.neg(y), z);
        }
      } else {
        if (h <= 0xD) {
          if (h == 0xC) return ABDKMath64x64.add(y, x);
          return ABDKMath64x64.add(ABDKMath64x64.neg(y), z);
        } else {
          if (h == 0xE) return ABDKMath64x64.sub(y, x);
          return ABDKMath64x64.sub(ABDKMath64x64.neg(y), z);
        }
      }
    }
  }

  /**
   * Modified from original perlin paper based on http://riven8192.blogspot.com/2010/08/calculate-perlinnoise-twice-as-fast.html
   **/
  function grad2d(int16 _hash, int128 x, int128 y) internal pure returns (int128) {
    // Convert lower 4 bits to hash code into 12 gradient directions
    int16 h = _hash & 0xF;
    if (h <= 0x7) {
      if (h <= 0x3) {
        if (h <= 0x1) {
          if (h == 0x0) return ABDKMath64x64.add(x, y);
          return ABDKMath64x64.sub(y, x);
        } else {
          if (h == 0x2) return ABDKMath64x64.sub(x, y);
          return ABDKMath64x64.sub(ABDKMath64x64.neg(x), y);
        }
      } else {
        if (h <= 0x5) {
          if (h == 0x4) return x;
          return ABDKMath64x64.neg(x);
        } else {
          if (h == 0x6) return x;
          return ABDKMath64x64.neg(x);
        }
      }
    } else {
      if (h <= 0xB) {
        if (h <= 0x9) {
          if (h == 0x8) return y;
          return ABDKMath64x64.neg(y);
        } else {
          if (h == 0xA) return y;
          return ABDKMath64x64.neg(y);
        }
      } else {
        if (h <= 0xD) {
          if (h == 0xC) return ABDKMath64x64.add(y, x);
          return ABDKMath64x64.neg(y);
        } else {
          if (h == 0xE) return ABDKMath64x64.sub(y, x);
          return ABDKMath64x64.neg(y);
        }
      }
    }
  }

  /**
   * Returns the value at the given index from the ptable
   */
  function p(int64 i) internal pure returns (int64) {
    return int64(ptable(int256(i)) >> 8);
  }

  /**
   * Returns an encoded tuple of the value at the given index and the subsequent value from the ptable.
   * Value of the requested index is at i0(result), subsequent value is at i1(result)
   */
  function p2(int16 i) internal pure returns (int16) {
    return int16(ptable(int256(i)));
  }

  /**
   * Helper function to access value at index 0 from the encoded tuple returned by p2
   */
  function i0(int16 tuple) internal pure returns (int16) {
    return tuple >> 8;
  }

  /**
   * Helper function to access value at index 1 from the encoded tuple returned by p2
   */
  function i1(int16 tuple) internal pure returns (int16) {
    return tuple & 0xff;
  }

  /**
   * From https://github.com/0x10f/solidity-perlin-noise/blob/master/contracts/PerlinNoise.sol
   *
   * @notice Gets a subsequent values in the permutation table at an index. The values are encoded
   *         into a single 16 bit integer with the  value at the specified index being the most
   *         significant 8 bits and the subsequent value being the least significant 8 bits.
   *
   * @param i the index in the permutation table.
   *
   * @dev The values from the table are mapped out into a binary tree for faster lookups.
   *      Looking up any value in the table in this implementation is is O(8), in
   *      the implementation of sequential if statements it is O(255).
   *
   * @dev The body of this function is autogenerated. Check out the 'gen-ptable' script.
   * (https://github.com/0x10f/solidity-perlin-noise/blob/master/scripts/gen-ptable.js)
   */
  function ptable(int256 i) internal pure returns (int256) {
    i &= 0xff;

    if (i <= 127) {
      if (i <= 63) {
        if (i <= 31) {
          if (i <= 15) {
            if (i <= 7) {
              if (i <= 3) {
                if (i <= 1) {
                  if (i == 0) {
                    return 38816;
                  } else {
                    return 41097;
                  }
                } else {
                  if (i == 2) {
                    return 35163;
                  } else {
                    return 23386;
                  }
                }
              } else {
                if (i <= 5) {
                  if (i == 4) {
                    return 23055;
                  } else {
                    return 3971;
                  }
                } else {
                  if (i == 6) {
                    return 33549;
                  } else {
                    return 3529;
                  }
                }
              }
            } else {
              if (i <= 11) {
                if (i <= 9) {
                  if (i == 8) {
                    return 51551;
                  } else {
                    return 24416;
                  }
                } else {
                  if (i == 10) {
                    return 24629;
                  } else {
                    return 13762;
                  }
                }
              } else {
                if (i <= 13) {
                  if (i == 12) {
                    return 49897;
                  } else {
                    return 59655;
                  }
                } else {
                  if (i == 14) {
                    return 2017;
                  } else {
                    return 57740;
                  }
                }
              }
            }
          } else {
            if (i <= 23) {
              if (i <= 19) {
                if (i <= 17) {
                  if (i == 16) {
                    return 35876;
                  } else {
                    return 9319;
                  }
                } else {
                  if (i == 18) {
                    return 26398;
                  } else {
                    return 7749;
                  }
                }
              } else {
                if (i <= 21) {
                  if (i == 20) {
                    return 17806;
                  } else {
                    return 36360;
                  }
                } else {
                  if (i == 22) {
                    return 2147;
                  } else {
                    return 25381;
                  }
                }
              }
            } else {
              if (i <= 27) {
                if (i <= 25) {
                  if (i == 24) {
                    return 9712;
                  } else {
                    return 61461;
                  }
                } else {
                  if (i == 26) {
                    return 5386;
                  } else {
                    return 2583;
                  }
                }
              } else {
                if (i <= 29) {
                  if (i == 28) {
                    return 6078;
                  } else {
                    return 48646;
                  }
                } else {
                  if (i == 30) {
                    return 1684;
                  } else {
                    return 38135;
                  }
                }
              }
            }
          }
        } else {
          if (i <= 47) {
            if (i <= 39) {
              if (i <= 35) {
                if (i <= 33) {
                  if (i == 32) {
                    return 63352;
                  } else {
                    return 30954;
                  }
                } else {
                  if (i == 34) {
                    return 59979;
                  } else {
                    return 19200;
                  }
                }
              } else {
                if (i <= 37) {
                  if (i == 36) {
                    return 26;
                  } else {
                    return 6853;
                  }
                } else {
                  if (i == 38) {
                    return 50494;
                  } else {
                    return 15966;
                  }
                }
              }
            } else {
              if (i <= 43) {
                if (i <= 41) {
                  if (i == 40) {
                    return 24316;
                  } else {
                    return 64731;
                  }
                } else {
                  if (i == 42) {
                    return 56267;
                  } else {
                    return 52085;
                  }
                }
              } else {
                if (i <= 45) {
                  if (i == 44) {
                    return 29987;
                  } else {
                    return 8971;
                  }
                } else {
                  if (i == 46) {
                    return 2848;
                  } else {
                    return 8249;
                  }
                }
              }
            }
          } else {
            if (i <= 55) {
              if (i <= 51) {
                if (i <= 49) {
                  if (i == 48) {
                    return 14769;
                  } else {
                    return 45345;
                  }
                } else {
                  if (i == 50) {
                    return 8536;
                  } else {
                    return 22765;
                  }
                }
              } else {
                if (i <= 53) {
                  if (i == 52) {
                    return 60821;
                  } else {
                    return 38200;
                  }
                } else {
                  if (i == 54) {
                    return 14423;
                  } else {
                    return 22446;
                  }
                }
              }
            } else {
              if (i <= 59) {
                if (i <= 57) {
                  if (i == 56) {
                    return 44564;
                  } else {
                    return 5245;
                  }
                } else {
                  if (i == 58) {
                    return 32136;
                  } else {
                    return 34987;
                  }
                }
              } else {
                if (i <= 61) {
                  if (i == 60) {
                    return 43944;
                  } else {
                    return 43076;
                  }
                } else {
                  if (i == 62) {
                    return 17583;
                  } else {
                    return 44874;
                  }
                }
              }
            }
          }
        }
      } else {
        if (i <= 95) {
          if (i <= 79) {
            if (i <= 71) {
              if (i <= 67) {
                if (i <= 65) {
                  if (i == 64) {
                    return 19109;
                  } else {
                    return 42311;
                  }
                } else {
                  if (i == 66) {
                    return 18310;
                  } else {
                    return 34443;
                  }
                }
              } else {
                if (i <= 69) {
                  if (i == 68) {
                    return 35632;
                  } else {
                    return 12315;
                  }
                } else {
                  if (i == 70) {
                    return 7078;
                  } else {
                    return 42573;
                  }
                }
              }
            } else {
              if (i <= 75) {
                if (i <= 73) {
                  if (i == 72) {
                    return 19858;
                  } else {
                    return 37534;
                  }
                } else {
                  if (i == 74) {
                    return 40679;
                  } else {
                    return 59219;
                  }
                }
              } else {
                if (i <= 77) {
                  if (i == 76) {
                    return 21359;
                  } else {
                    return 28645;
                  }
                } else {
                  if (i == 78) {
                    return 58746;
                  } else {
                    return 31292;
                  }
                }
              }
            }
          } else {
            if (i <= 87) {
              if (i <= 83) {
                if (i <= 81) {
                  if (i == 80) {
                    return 15571;
                  } else {
                    return 54149;
                  }
                } else {
                  if (i == 82) {
                    return 34278;
                  } else {
                    return 59100;
                  }
                }
              } else {
                if (i <= 85) {
                  if (i == 84) {
                    return 56425;
                  } else {
                    return 26972;
                  }
                } else {
                  if (i == 86) {
                    return 23593;
                  } else {
                    return 10551;
                  }
                }
              }
            } else {
              if (i <= 91) {
                if (i <= 89) {
                  if (i == 88) {
                    return 14126;
                  } else {
                    return 12021;
                  }
                } else {
                  if (i == 90) {
                    return 62760;
                  } else {
                    return 10484;
                  }
                }
              } else {
                if (i <= 93) {
                  if (i == 92) {
                    return 62566;
                  } else {
                    return 26255;
                  }
                } else {
                  if (i == 94) {
                    return 36662;
                  } else {
                    return 13889;
                  }
                }
              }
            }
          }
        } else {
          if (i <= 111) {
            if (i <= 103) {
              if (i <= 99) {
                if (i <= 97) {
                  if (i == 96) {
                    return 16665;
                  } else {
                    return 6463;
                  }
                } else {
                  if (i == 98) {
                    return 16289;
                  } else {
                    return 41217;
                  }
                }
              } else {
                if (i <= 101) {
                  if (i == 100) {
                    return 472;
                  } else {
                    return 55376;
                  }
                } else {
                  if (i == 102) {
                    return 20553;
                  } else {
                    return 18897;
                  }
                }
              }
            } else {
              if (i <= 107) {
                if (i <= 105) {
                  if (i == 104) {
                    return 53580;
                  } else {
                    return 19588;
                  }
                } else {
                  if (i == 106) {
                    return 33979;
                  } else {
                    return 48080;
                  }
                }
              } else {
                if (i <= 109) {
                  if (i == 108) {
                    return 53337;
                  } else {
                    return 22802;
                  }
                } else {
                  if (i == 110) {
                    return 4777;
                  } else {
                    return 43464;
                  }
                }
              }
            }
          } else {
            if (i <= 119) {
              if (i <= 115) {
                if (i <= 113) {
                  if (i == 112) {
                    return 51396;
                  } else {
                    return 50311;
                  }
                } else {
                  if (i == 114) {
                    return 34690;
                  } else {
                    return 33396;
                  }
                }
              } else {
                if (i <= 117) {
                  if (i == 116) {
                    return 29884;
                  } else {
                    return 48287;
                  }
                } else {
                  if (i == 118) {
                    return 40790;
                  } else {
                    return 22180;
                  }
                }
              }
            } else {
              if (i <= 123) {
                if (i <= 121) {
                  if (i == 120) {
                    return 42084;
                  } else {
                    return 25709;
                  }
                } else {
                  if (i == 122) {
                    return 28102;
                  } else {
                    return 50861;
                  }
                }
              } else {
                if (i <= 125) {
                  if (i == 124) {
                    return 44474;
                  } else {
                    return 47619;
                  }
                } else {
                  if (i == 126) {
                    return 832;
                  } else {
                    return 16436;
                  }
                }
              }
            }
          }
        }
      }
    } else {
      if (i <= 191) {
        if (i <= 159) {
          if (i <= 143) {
            if (i <= 135) {
              if (i <= 131) {
                if (i <= 129) {
                  if (i == 128) {
                    return 13529;
                  } else {
                    return 55778;
                  }
                } else {
                  if (i == 130) {
                    return 58106;
                  } else {
                    return 64124;
                  }
                }
              } else {
                if (i <= 133) {
                  if (i == 132) {
                    return 31867;
                  } else {
                    return 31493;
                  }
                } else {
                  if (i == 134) {
                    return 1482;
                  } else {
                    return 51750;
                  }
                }
              }
            } else {
              if (i <= 139) {
                if (i <= 137) {
                  if (i == 136) {
                    return 9875;
                  } else {
                    return 37750;
                  }
                } else {
                  if (i == 138) {
                    return 30334;
                  } else {
                    return 32511;
                  }
                }
              } else {
                if (i <= 141) {
                  if (i == 140) {
                    return 65362;
                  } else {
                    return 21077;
                  }
                } else {
                  if (i == 142) {
                    return 21972;
                  } else {
                    return 54479;
                  }
                }
              }
            }
          } else {
            if (i <= 151) {
              if (i <= 147) {
                if (i <= 145) {
                  if (i == 144) {
                    return 53198;
                  } else {
                    return 52795;
                  }
                } else {
                  if (i == 146) {
                    return 15331;
                  } else {
                    return 58159;
                  }
                }
              } else {
                if (i <= 149) {
                  if (i == 148) {
                    return 12048;
                  } else {
                    return 4154;
                  }
                } else {
                  if (i == 150) {
                    return 14865;
                  } else {
                    return 4534;
                  }
                }
              }
            } else {
              if (i <= 155) {
                if (i <= 153) {
                  if (i == 152) {
                    return 46781;
                  } else {
                    return 48412;
                  }
                } else {
                  if (i == 154) {
                    return 7210;
                  } else {
                    return 10975;
                  }
                }
              } else {
                if (i <= 157) {
                  if (i == 156) {
                    return 57271;
                  } else {
                    return 47018;
                  }
                } else {
                  if (i == 158) {
                    return 43733;
                  } else {
                    return 54647;
                  }
                }
              }
            }
          }
        } else {
          if (i <= 175) {
            if (i <= 167) {
              if (i <= 163) {
                if (i <= 161) {
                  if (i == 160) {
                    return 30712;
                  } else {
                    return 63640;
                  }
                } else {
                  if (i == 162) {
                    return 38914;
                  } else {
                    return 556;
                  }
                }
              } else {
                if (i <= 165) {
                  if (i == 164) {
                    return 11418;
                  } else {
                    return 39587;
                  }
                } else {
                  if (i == 166) {
                    return 41798;
                  } else {
                    return 18141;
                  }
                }
              }
            } else {
              if (i <= 171) {
                if (i <= 169) {
                  if (i == 168) {
                    return 56729;
                  } else {
                    return 39269;
                  }
                } else {
                  if (i == 170) {
                    return 26011;
                  } else {
                    return 39847;
                  }
                }
              } else {
                if (i <= 173) {
                  if (i == 172) {
                    return 42795;
                  } else {
                    return 11180;
                  }
                } else {
                  if (i == 174) {
                    return 44041;
                  } else {
                    return 2433;
                  }
                }
              }
            }
          } else {
            if (i <= 183) {
              if (i <= 179) {
                if (i <= 177) {
                  if (i == 176) {
                    return 33046;
                  } else {
                    return 5671;
                  }
                } else {
                  if (i == 178) {
                    return 10237;
                  } else {
                    return 64787;
                  }
                }
              } else {
                if (i <= 181) {
                  if (i == 180) {
                    return 4962;
                  } else {
                    return 25196;
                  }
                } else {
                  if (i == 182) {
                    return 27758;
                  } else {
                    return 28239;
                  }
                }
              }
            } else {
              if (i <= 187) {
                if (i <= 185) {
                  if (i == 184) {
                    return 20337;
                  } else {
                    return 29152;
                  }
                } else {
                  if (i == 186) {
                    return 57576;
                  } else {
                    return 59570;
                  }
                }
              } else {
                if (i <= 189) {
                  if (i == 188) {
                    return 45753;
                  } else {
                    return 47472;
                  }
                } else {
                  if (i == 190) {
                    return 28776;
                  } else {
                    return 26842;
                  }
                }
              }
            }
          }
        }
      } else {
        if (i <= 223) {
          if (i <= 207) {
            if (i <= 199) {
              if (i <= 195) {
                if (i <= 193) {
                  if (i == 192) {
                    return 56054;
                  } else {
                    return 63073;
                  }
                } else {
                  if (i == 194) {
                    return 25060;
                  } else {
                    return 58619;
                  }
                }
              } else {
                if (i <= 197) {
                  if (i == 196) {
                    return 64290;
                  } else {
                    return 8946;
                  }
                } else {
                  if (i == 198) {
                    return 62145;
                  } else {
                    return 49646;
                  }
                }
              }
            } else {
              if (i <= 203) {
                if (i <= 201) {
                  if (i == 200) {
                    return 61138;
                  } else {
                    return 53904;
                  }
                } else {
                  if (i == 202) {
                    return 36876;
                  } else {
                    return 3263;
                  }
                }
              } else {
                if (i <= 205) {
                  if (i == 204) {
                    return 49075;
                  } else {
                    return 45986;
                  }
                } else {
                  if (i == 206) {
                    return 41713;
                  } else {
                    return 61777;
                  }
                }
              }
            }
          } else {
            if (i <= 215) {
              if (i <= 211) {
                if (i <= 209) {
                  if (i == 208) {
                    return 20787;
                  } else {
                    return 13201;
                  }
                } else {
                  if (i == 210) {
                    return 37355;
                  } else {
                    return 60409;
                  }
                }
              } else {
                if (i <= 213) {
                  if (i == 212) {
                    return 63758;
                  } else {
                    return 3823;
                  }
                } else {
                  if (i == 214) {
                    return 61291;
                  } else {
                    return 27441;
                  }
                }
              }
            } else {
              if (i <= 219) {
                if (i <= 217) {
                  if (i == 216) {
                    return 12736;
                  } else {
                    return 49366;
                  }
                } else {
                  if (i == 218) {
                    return 54815;
                  } else {
                    return 8117;
                  }
                }
              } else {
                if (i <= 221) {
                  if (i == 220) {
                    return 46535;
                  } else {
                    return 51050;
                  }
                } else {
                  if (i == 222) {
                    return 27293;
                  } else {
                    return 40376;
                  }
                }
              }
            }
          }
        } else {
          if (i <= 239) {
            if (i <= 231) {
              if (i <= 227) {
                if (i <= 225) {
                  if (i == 224) {
                    return 47188;
                  } else {
                    return 21708;
                  }
                } else {
                  if (i == 226) {
                    return 52400;
                  } else {
                    return 45171;
                  }
                }
              } else {
                if (i <= 229) {
                  if (i == 228) {
                    return 29561;
                  } else {
                    return 31026;
                  }
                } else {
                  if (i == 230) {
                    return 12845;
                  } else {
                    return 11647;
                  }
                }
              }
            } else {
              if (i <= 235) {
                if (i <= 233) {
                  if (i == 232) {
                    return 32516;
                  } else {
                    return 1174;
                  }
                } else {
                  if (i == 234) {
                    return 38654;
                  } else {
                    return 65162;
                  }
                }
              } else {
                if (i <= 237) {
                  if (i == 236) {
                    return 35564;
                  } else {
                    return 60621;
                  }
                } else {
                  if (i == 238) {
                    return 52573;
                  } else {
                    return 24030;
                  }
                }
              }
            }
          } else {
            if (i <= 247) {
              if (i <= 243) {
                if (i <= 241) {
                  if (i == 240) {
                    return 56946;
                  } else {
                    return 29251;
                  }
                } else {
                  if (i == 242) {
                    return 17181;
                  } else {
                    return 7448;
                  }
                }
              } else {
                if (i <= 245) {
                  if (i == 244) {
                    return 6216;
                  } else {
                    return 18675;
                  }
                } else {
                  if (i == 246) {
                    return 62349;
                  } else {
                    return 36224;
                  }
                }
              }
            } else {
              if (i <= 251) {
                if (i <= 249) {
                  if (i == 248) {
                    return 32963;
                  } else {
                    return 49998;
                  }
                } else {
                  if (i == 250) {
                    return 20034;
                  } else {
                    return 17111;
                  }
                }
              } else {
                if (i <= 253) {
                  if (i == 252) {
                    return 55101;
                  } else {
                    return 15772;
                  }
                } else {
                  if (i == 254) {
                    return 40116;
                  } else {
                    return 46231;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
