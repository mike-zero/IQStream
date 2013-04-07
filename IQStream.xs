#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#define	STATE_WAIT	0
#define	STATE_LOW	1
#define	STATE_HIGH	2
#define	STATE_FRONT	3

typedef struct
{
	U16		last;
	U16		min;
	U16		max;
	U16		counter;
	U32		sum;
/*
	U16		last = 0;
	U16		min = 0;
	U16		max = 0;
	U16		counter = 0;
	U32		sum = 0;
*/
} level;

typedef struct
{
	int		state;
	U32		ticks;
	level	*low;
	level	*high;
	U16		amp_cache[0x10000];
	int		scale_bits;
	SV		*obj;
} IQSTREAM;

char _IMPULSE[] = "Impulse";

int call_proc(SV *obj, char *proc_name, char *orig_text, int orig_len, char *tag, int tag_len)
{
	int count;
	int res = 0;
	dSP;
	char *txt = (char*)malloc(orig_len + 1);
	memcpy(txt, orig_text, orig_len);
	txt[orig_len] = 0;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(newSVsv(obj));
	XPUSHs(sv_2mortal(newSVpvn(txt, orig_len)));
	XPUSHs(sv_2mortal(newSVpvn(tag, tag_len)));
	PUTBACK;
	count = perl_call_method(proc_name, G_SCALAR);
	SPAGAIN;
	if (count == 1)
          res = POPi;
	PUTBACK;
	FREETMPS;
	LEAVE;
	free(txt);
	return res;
}

void
process_value(level *ll, U16 val)
{
	ll->last = val;
	ll->sum += val;
	if (val < ll->min || ll->counter == 0) ll->min = val;
	if (val > ll->max) ll->max = val;
	ll->counter++;
}

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
	double offs = 0.5;
//	return (U16) sqrt((i * i + q * q) << (scale_bits*2));	// faster, but little (half a bit) less accurate
	return (U16) round(sqrt(((i+offs) * (i+offs) + (q+offs) * (q+offs)) * (1 << scale_bits*2)));
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
	RETVAL->state = STATE_WAIT;
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

int
strm_level_detect(IQSTREAM *stm, unsigned char * buf, int size, U16 threshold, int reset_ticks)
	CODE:
		unsigned char* p;
		int new_state;
		for (p = buf; p - buf < size; p += 2) {
			switch (stm->state) {
				case STATE_LOW:
					stm->ticks++;
				case STATE_WAIT:
					if (*(U16*)p >= threshold) {
					}
					if (stm->ticks >= reset_ticks) {
						stm->state = STATE_WAIT;
						stm->ticks = 0;
					}
					break;
				case STATE_HIGH:
					break;
				case STATE_FRONT:
					break;
			}






			if (new_state == stm->state) {
				if (stm->ticks >= reset_ticks)
				continue;
			}

			if (new_state != stm->state) {
				printf("%d %6d ", stm->state, stm->ticks);
				if (new_state == STATE_HIGH) {
					printf("\n");
					// RETVAL = call_proc(stm->obj, _IMPULSE, p, strlen(p), tag, strlen(tag));
					// RETVAL = call_proc(stm->obj, _IMPULSE, "asdf", strlen("asdf"), "qwertyu", strlen("qwertyu"));
				}
				stm->state = new_state;
				stm->ticks = 0;
			}
		}
		RETVAL = 0;
	OUTPUT:
		RETVAL
