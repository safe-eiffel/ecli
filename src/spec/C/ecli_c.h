#include <ecli_c_spec.h>

struct ecli_c_value {
	long	length; /* buffer_length */
	long	length_indicator;
	char	value[1]; /* beginning of buffer*/
};

struct ecli_c_array_value {
	long	length; /* length of a single element */
	long 	count;  /* count of elements */
	char	buffer[1]; /* beginning of buffer*/
	/* buffer is organized like this
		long length_indicator [count]
		char values [count][length]
	*/
};
