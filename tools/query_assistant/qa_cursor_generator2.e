indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QA_CURSOR_GENERATOR2

	-- Replace ANY below by the name of parent class if any (adding more parents
	-- if necessary); otherwise you can remove inheritance clause altogether.
inherit
	ANY
	
	QA_CURSOR_GENERATOR
		undefine
			put_closing,
			put_definition,
			put_heading,
			put_invisible_features,
			put_parameters,
			put_results,
			put_setup,
			put_start,	
			put_visible_features
		end

-- The following Creation_clause can be removed if you need no other
-- procedure than `default_create':

create
	execute
feature -- Initialization

	execute (a_cursor: QA_CURSOR; a_file: FILE) is
		do
			
		ensure
			class_name: class_name /= Void
		end
		
feature -- 

	create_class is
		do
			create cursor_class.make (class_name)
		end
		

feature -- Basic operations

	put_closing is
			-- put closing of class
		do
			
		end
		
	put_definition is
		do
			
		end

	put_heading is
			-- put indexing, class name, inheritance and creation
		do
			
		end

	put_invisible_features is
		do
			
		end

	put_parameters is
			-- put visible representation of parameters
		do
			
		end

	put_results is
			-- put visible representation of results
		do
			
		end

	put_setup is
		do
			
		end

	put_start is
			-- put start operation
		do
			
		end

	put_visible_features is
		do
			
		end

feature -- Inapplicable

	cursor_class : E_CLASS
	
feature {NONE} -- Implementation

invariant
	invariant_clause: -- Your invariant here

end -- class QA_CURSOR_GENERATOR2
