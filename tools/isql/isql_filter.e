note
	description: "Objects that filter output."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ISQL_FILTER

inherit
	ANY
		redefine
			default_create
		end

feature {} -- Initialization

	default_create
		do
			create {KL_NULL_TEXT_OUTPUT_STREAM}output_file.make ("/dev/null")
		end

feature -- Access

	output_file : KI_TEXT_OUTPUT_STREAM

	heading_begin : STRING deferred end
	heading_separator : STRING deferred end
	heading_end : STRING deferred end
	row_begin : STRING deferred end
	column_separator : STRING deferred end
	row_end : STRING deferred end
	error_begin : STRING deferred end
	error_separator : STRING deferred end
	error_end : STRING deferred end

feature -- Measurement

	heading_count : INTEGER
			-- current count of headings output

	column_count : INTEGER
			-- current count of columns output in a row

	row_count : INTEGER
			-- number of rows output

	error_count : INTEGER
			-- count of error messages while `is_in_error'

feature -- Status report

	is_writable : BOOLEAN
			-- can this filter be used to write something ?
		do
			Result := output_file /= Void
		end

feature -- Status setting

	is_in_heading : BOOLEAN
		do
			Result := status = status_heading
		end

	is_in_row : BOOLEAN
		do
			Result := status = status_row
		end

	is_in_error : BOOLEAN
		do
			Result := status = status_error
		end

	is_in_message : BOOLEAN
		do
			Result := status = status_message
		end

	is_free : BOOLEAN
			-- are we out of 'heading', or 'row' or 'error' ?
		do
			Result := status = status_free
		end

feature -- Element change

	set_output_file (a_file : like output_file)
			-- set `output_file' to `a_file'
		require
			a_file_exists: a_file /= Void and then a_file.is_open_write
		do
			output_file := a_file
		ensure
			output_file_set: output_file = a_file
		end

feature -- Basic operations

	begin_heading
			-- begin heading of result-set
		require
			writable: is_writable
			free: is_free
		do
			--| redefine in descendant classes
			heading_count := 0
			column_count := 0
			row_count := 0
			set_status (status_heading)
		ensure
			heading_count_zero: heading_count = 0
			column_count_zero: column_count = 0
			row_count_zero: row_count = 0
			in_heading: is_in_heading
		end

	end_heading
			-- end heading of result-set
		require
			writable: is_writable
			in_heading : is_in_heading
		do
			set_status (status_free)
		ensure
			free: is_free
		end

	put_heading (s : STRING)
			-- put `s' as heading_column
		require
			writable: is_writable
			in_heading: is_in_heading
		do
			heading_count := heading_count + 1
		ensure
			heading_count_incremented: heading_count = old heading_count + 1
		end

	begin_row
			-- begin result-set row
		require
			writable: is_writable
			free: is_free
		do
			column_count := 0
			set_status (status_row)
		ensure
			column_count_zero: column_count = 0
			in_row: is_in_row
		end

	put_column (s : STRING)
			-- put `s' as result column
		require
			writable: is_writable
		do
			column_count := column_count + 1
		ensure
			column_count_incremented: column_count = old column_count + 1
		end

	end_row
			-- end result-set row is
		require
			writable: is_writable
			in_row: is_in_row
		do
			row_count := row_count + 1
			set_status (status_free)
		ensure
			row_count_incremented: row_count = old row_count + 1
			free: is_free
		end

	begin_error
			-- begin error message
		require
			writable: is_writable
			free: is_free
		do
			set_status (status_error)
		ensure
			in_error: is_in_error
		end

	put_error (s : STRING)
			-- put `s' as an error
		require
			writable: is_writable
			in_error: is_in_error
		do
			error_count := error_count + 1
		ensure
			error_count_incremented: error_count = old error_count + 1
		end

	end_error
			-- end error message
		require
			writable: is_writable
			in_error: is_in_error
		do
			set_status (status_free)
			error_count := 0
		ensure
			free: is_free
			error_count_zero: error_count = 0
		end

	begin_message
			-- begin message
		require
			writable: is_writable
			free: is_free
		do
			set_status (status_message)
		ensure
			in_message: is_in_message
		end

	put_message (s : STRING)
			-- put message `s'
		require
			writable: is_writable
			in_error: is_in_message
		deferred
		end

	end_message
			-- en message
		require
			writable: is_writable
			in_error: is_in_message
		do
			set_status (status_free)
		ensure
			is_free: is_free
		end

feature {NONE} -- Implementation

	status : INTEGER

	status_message : INTEGER = 1
	status_heading : INTEGER = 2
	status_error : INTEGER = 4
	status_row : INTEGER = 3
	status_free : INTEGER = 0

	set_status (s : INTEGER)
		do
			status := s
		ensure
			status_set: status = s
		end

end -- class ISQL_FILTER
