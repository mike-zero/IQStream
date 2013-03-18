#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

# include <inttypes.h>

#include "ppport.h"


MODULE = IQStream		PACKAGE = IQStream		

int
IQ_normalize_zero(unsigned char * buf, int size, int make_signed)
	CODE:
		unsigned char *p;
		for (p = buf; p - buf < size; p++) {
			if (*p & 0x80) {
				*p &= 0x7F;
			} else {
				if (make_signed) {
					*p |= 0x80;
				} else {
					*p ^= 0x7F;
				}
			}
		}
		RETVAL = p - buf;
	OUTPUT:
		RETVAL
		
int
Convert_IQ_to_amplitude(char * buf, int size)
	CODE:
		char *p;
		I32 res;
		for (p = buf; p - buf < size; p++) {
//			res = 
//			*p = ~ *p;
		}
		RETVAL = p - buf;
	OUTPUT:
		RETVAL