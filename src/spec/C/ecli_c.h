#ifndef ECLI_C_H
#define ECLI_C_H
#include <ecli_c_spec.h>

struct ecli_c_value {
	SQLLEN	length; /* buffer_length */
	SQLLEN	length_indicator; /* length of data in the buffer */
	char	value[1]; /* beginning of buffer*/
};

struct ecli_c_array_value {
	SQLLEN	length; /* length of a single element buffer*/
	long 	count;  /* count of elements */
	char	buffer[1]; /* beginning of buffer*/
	/* buffer is organized like this
		SQLLEN length_indicator [count] -- array of actual element length
		char values [count][length]   -- array of element buffer
	*/
};
#endif
