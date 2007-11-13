indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUISQL_FILTER

inherit
	ISQL_FILTER
		redefine
			put_column,
			put_error,
			put_heading,
			put_message,
			begin_heading, end_heading,
			end_row,
			begin_row
		end

create

	make

feature {NONE} -- Initialization

	make (a_sql_data : like sql_data; a_message : EV_TEXT; an_error : EV_TEXTABLE) is
		do
			sql_data := a_sql_data
			message := a_message
			error := an_error
			create current_headings.make
			create current_data.make
		end

feature -- Access

	heading_end: STRING_8
	error_begin: STRING_8
	column_separator: STRING_8
	heading_begin: STRING_8
	error_separator: STRING_8
	row_end: STRING_8
	heading_separator: STRING_8
	error_end: STRING_8
	row_begin: STRING_8

	sql_data : EV_GRID

	message : EV_TEXT
	error : EV_TEXTABLE

	current_data : DS_LINKED_LIST[STRING]
	current_headings : DS_LINKED_LIST[STRING]

feature -- Basic operations

	put_heading (s: STRING_8) is
		local
			h : EV_HEADER_ITEM
		do
			precursor (s)
			current_headings.put_last (s)
		end

	put_error (s: STRING_8) is
		do
			precursor (s)
			message.append_text (s)
			error.set_text (s)
		end

	put_message (s: STRING_8) is
		do
			message.append_text (s)
		end

	put_column (s: STRING_8) is
		local
		do
			precursor (s)
			current_data.put_last (s)
			column_index := column_index + 1
		end

	begin_heading is
		do
			current_headings.wipe_out
			precursor
		end

	end_heading is
		local
			i : INTEGER
			h : EV_HEADER
			to_remove : INTEGER
		do
			row_index := 1; column_index := 1
			precursor
--			h := sql_data.header
--			if h.count > 0 then
--				h.wipe_out
--			end
			sql_data.lock_update
			if sql_data.column_count < current_headings.count then
				sql_data.set_column_count_to (current_headings.count)
			else
				from

				until
					sql_data.column_count = current_headings.count
				loop
					sql_data.remove_column (sql_data.column_count)
				end
			end
			from
				current_headings.start
				i := 1
			until
				current_headings.after
			loop
--					h.extend (create {EV_HEADER_ITEM}.make_with_text (current_headings.item_for_iteration))
				sql_data.column (i).set_title (current_headings.item_for_iteration)
				sql_data.column (i).set_width (current_headings.item_for_iteration.capacity * 10)
				current_headings.forth
				i := i + 1
			end
			if sql_data.row_count > 0 then
				sql_data.remove_rows (1, sql_data.row_count)
			end
			sql_data.unlock_update
		end

	end_row is
		local
			i : INTEGER
			grid_item : GUISQL_GRID_LABEL_ITEM
		do
			row_index := row_index + 1
			sql_data.lock_update
			sql_data.set_row_count_to (sql_data.row_count + 1)
			from
				current_data.start
				i := 1
			until
				current_data.after
			loop
				create grid_item.make_with_text (current_data.item_for_iteration)
				sql_data.row (sql_data.row_count).set_item (i, grid_item)
				current_data.forth
				i := i + 1
			end
			if row_index \\ 2 = 1 then
				sql_data.row (sql_data.row_count).set_background_color (light_blue)
			else
				sql_data.row (sql_data.row_count).set_background_color (white)
			end
			sql_data.unlock_update
			column_index := 1
			Precursor {ISQL_FILTER}
		end

	begin_row is
		do
			precursor
			current_data.wipe_out
		end

feature -- constants

	light_blue : EV_COLOR is
		once
			create Result.make_with_8_bit_rgb (230, 230, 255)
		end

	white : EV_COLOR is
		once
			create Result.make_with_8_bit_rgb (255, 255, 255)
		end


feature -- Inapplicable

feature {NONE} -- Implementation

	column_index : INTEGER

	row_index : INTEGER

invariant

	current_headings_not_void: current_headings /= Void
	current_data_not_void: current_data /= Void

end
