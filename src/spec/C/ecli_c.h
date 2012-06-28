#ifndef ECLI_C_H
#define ECLI_C_H
#include <ecli_c_spec.h>

struct ecli_c_value {
	SQLLEN	length; /* buffer_length */
	SQLLEN	length_indicator;
	char	value[1]; /* beginning of buffer*/
};

struct ecli_c_array_value {
	SQLLEN	length; /* length of a single element */
	long 	count;  /* count of elements */
	char	buffer[1]; /* beginning of buffer*/
	/* buffer is organized like this
		SQLLEN length_indicator [count]
		char values [count][length]
	*/
};
#endif
