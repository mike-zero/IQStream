#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

typedef struct
{
	int		state;
	U16		amp_cache[0x10000];
	int		scale_bits;
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
//	double offs = 0.5;
	/* TODO: compensate the lost half-bits here inside pow (in case it will be counted usefull) */
	return (U16) sqrt((i * i + q * q) << (scale_bits*2));
//	return (U16) sqrt(((i+0.5) * (i+0.5) + (q+0.5) * (q+0.5)) * (1 << scale_bits*2));
//	return (U16) sqrt(((i+offs) * (i+offs) + (q+offs) * (q+offs)) * (1 << scale_bits*2));
}

MODULE = IQStream		PACKAGE = IQStream
PROTOTYPES: DISABLE

IQSTREAM *
make(SV *obj, int scale_bits)
CODE:
	RETVAL = (IQSTREAM*)malloc(sizeof(IQSTREAM));
	memset(RETVAL, 0, sizeof(IQSTREAM));
	RETVAL->obj = newSVsv(obj);
	RETVAL->scale_bits = scale_bits;
OUTPUT:
	RETVAL

MODULE = IQStream		PACKAGE = IQSTREAMPtr 	PREFIX = strm_

void
strm_DESTROY(stm)
	IQSTREAM	*stm;
CODE:
	sv_setsv(stm->obj, 0);
	//if (stm->amp_cache) free(stm->amp_cache);
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
			res = (U16 *) p;
			*res = calc_amplitude(IQ_normalize_zero(p, 0), IQ_normalize_zero(p+1, 0), scale_bits);
		}
		RETVAL = p - buf;
	OUTPUT:
		RETVAL

int
strm_fill_amplitude_cache(IQSTREAM *stm)
	CODE:
		U8 i;
		U8 q;
		U32 a;
		RETVAL = 1;
		for (a = 0; a <= 0xFFFF; a++) {
			i = a & 0xFF;
			q = (a>>8) & 0xFF;
			stm->amp_cache[a] = calc_amplitude(IQ_normalize_zero(&i, 0), IQ_normalize_zero(&q, 0), stm->scale_bits);
		}
	OUTPUT:
		RETVAL

int
strm_Convert_IQ_to_amplitude_buf_cached(IQSTREAM *stm, unsigned char * buf, int size)
	CODE:
		unsigned char * p;
		U16 * res;
		for (p = buf; p - buf < size; p += 2) {
			res = (U16 *) p;
			*res = stm->amp_cache[*res];
		}
		RETVAL = p - buf;
	OUTPUT:
		RETVAL
