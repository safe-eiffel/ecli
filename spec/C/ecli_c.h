#include <ecli_c_spec.h>

struct ecli_c_value {
	long	length; /* buffer_length */
	long	length_indicator;
	char	value[1]; /* beginning of buffer*/
};
