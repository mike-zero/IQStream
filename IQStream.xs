#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


typedef struct
{
	int		state;
	SV		*obj;
} IQSTREAM;

U8
IQ_normalize_zero(unsigned char * p, int make_signed)
{
	if (*p & 0x80) {
		return *p & 0x7F;
	} else {
		if (make_signed) {
			return *p | 0x80;
		} else {
			return *p ^ 0x7F;
		}
	}
}

/* scale_bits can be set to 0..8 to get better precision */
U16
calc_amplitude(U8 i, U8 q, int scale_bits)
{
	return (U16) sqrt((i * i + q * q) << (scale_bits*2));
}

MODULE = IQStream		PACKAGE = IQStream
PROTOTYPES: DISABLE

IQSTREAM *
make(obj)
	SV		*obj;
CODE:
	RETVAL = (IQSTREAM*)malloc(sizeof(IQSTREAM));
	memset(RETVAL, 0, sizeof(IQSTREAM));
	RETVAL->obj = newSVsv(obj);
OUTPUT:
	RETVAL

MODULE = IQStream		PACKAGE = IQSTREAMPtr 	PREFIX = strm_

void
strm_DESTROY(stm)
	IQSTREAM	*stm;
CODE:
	sv_setsv(stm->obj, 0);
//	if (stm->buf) free(stm->buf);
	free(stm);

int
strm_IQ_normalize_zero_buf(IQSTREAM	*stm, unsigned char * buf, int size, int make_signed)
	CODE:
		unsigned char *p;
		for (p = buf; p - buf < size; p++) {
			*p = IQ_normalize_zero(p, make_signed);
		}
		RETVAL = p - buf;
	OUTPUT:
		RETVAL

int
strm_Convert_IQ_to_amplitude_buf(IQSTREAM *stm, unsigned char * buf, int size, int scale_bits)
	CODE:
		unsigned char *p;
		U16 * res;
		for (p = buf; p - buf < size; p += 2) {
			res = p;
			*res = calc_amplitude(IQ_normalize_zero(p, 0), IQ_normalize_zero(p+1, 0), scale_bits);
		}
		RETVAL = p - buf;
	OUTPUT:
		RETVAL
