indexing
	description: "Objects that ..."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_CURSOR

inherit
	ECLI_STATEMENT
		rename
			sql as definition,
			set_sql as define
		redefine
			add_new_parameter,
			value_anchor
		end

creation
	make

feature -- Initialization

feature -- Access

	parameter_name_by_position (index : INTEGER) : STRING is
		require
			index: index > 0 and index < parameter_count
		do
			Result := impl_parameter_name_by_position.item (index)
		end

feature -- Measurement

feature -- Status report

	name : STRING

feature -- Status setting

	set_name (a_name : STRING) is
		require
			name: a_name /= Void
		do	
			name := a_name
		ensure
			name = a_name
		end

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

	create_compatible_cursor is
		local
			i, count : INTEGER
			d : ECLI_COLUMN_DESCRIPTION
		do
			from 
				i := 1
				count := result_column_count
				create cursor.make (1, count)
			until 
				i > count
			loop
				d := cursor_description.item (i)
				value_factory.create_instance (d.db_type_code, d.column_precision , d.decimal_digits)
				if value_factory.last_result /= Void then
					cursor.put (value_factory.last_result, i)
				else
				end			
				i := i + 1
			end			
		end

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

	value_factory : QA_VALUE_FACTORY is
		once
			create Result.make
		end

	value_anchor : QA_VALUE is
		do
		end

feature {NONE} -- Implementation


	impl_parameter_name_by_position : ARRAY[STRING]
	
	add_new_parameter (a_name : STRING; a_position : INTEGER) is
		do
			Precursor (a_name, a_position)
			if impl_parameter_name_by_position = Void then
				create impl_parameter_name_by_position.make (1, parameter_count)
			end
		end

invariant
	invariant_clause: -- Your invariant here

end -- class QA_CURSOR
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
