indexing

	description:
	
			"Validity Errors"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	QA_VALIDITY_ERROR

inherit
	QA_ERROR

--validity	e_already_exists - who, what, where | module, name, type {module, parameter_set, column, parameter}
--validity	e_sql_invalid_reference_column - module, name, table, column
--validity	e_sql_parameter_not_described - name, module
--validity	e_sql_parameters_count_mismatch - module
--validity	w_parent_class_empty - parent

creation
	
	make_already_exists,
	make_invalid_reference_column,
	make_parameter_not_described,
	make_parameter_count_mismatch,
	make_parent_class_empty
	
feature {NONE} -- Initializaiton

	make_already_exists (who, what, type : STRING) is
			-- Make `who' already has an existing `what' of type `type' 
		require
			who_not_void: who /= Void
			what_not_void: what /= Void
			type_not_void: type /= Void
		do
			default_template := alex_template
			create parameters.make (1, 3)
			parameters.put (who, 1)
			parameters.put (what, 2)
			parameters.put (type, 3)
		end
		
	make_invalid_reference_column (module, name, table, column : STRING) is
			-- Make `name' in `module' has an invalid reference column as `table'.`column'.
		do
			default_template := invrefcol_template
			create parameters.make (1, 4)
			parameters.put (module, 1)
			parameters.put (name, 2)
			parameters.put (table, 3)
			parameters.put (column, 4)
		end

	make_parameter_not_described (module, name : STRING) is
			-- Make missing description for parameter `name' in `module'.
		require
			module_not_void: module /= Void
			name_not_void: name /= Void
		do
			default_template := misdesc_template
			create parameters.make (1, 2)
			parameters.put (module, 1)
			parameters.put (name, 2)
		end

	make_parameter_count_mismatch (module : STRING) is
			-- Make parameter count mismatch in `module'.
		require
			module_not_void: module /= Void
		do
			default_template := countmis_template
			create parameters.make (1, 1)
			parameters.put (module, 1)
		end

	make_parent_class_empty (parent : STRING) is
			-- Make warning `parent' class is empty.
		require
			parent_not_void: parent /= Void
		do
			default_template := parclempty_template
			create parameters.make (1, 1)
			parameters.put (parent, 1)
		end

feature {NONE} -- Implementation

	alex_template : STRING is       "[E-VAL-ALRDYEX] Module $1 : $3 `$2' already exists."
	invrefcol_template : STRING is  "[E-VAL-INRFCOL] Module $1 : SQL parameter `$2' has an invalid reference column [$3.$4]."
	misdesc_template : STRING is    "[E-VAL-MISDESC] Module $1 : missing description for SQL parameter `$2'."
	countmis_template : STRING is   "[E-VAL-CNTMISM] Module $1 : Mismatch between count of SQL parameters and of declared parameters."
	parclempty_template : STRING is "[W-VAL-CLEMPTY] Parent class `$1' is empty."

--validity	e_already_exists - who, what, where | module, name, type {module, parameter_set, column, parameter}
--validity	e_sql_invalid_reference_column - module, name, table, column
--validity	e_sql_parameter_not_described - name, module
--validity	e_sql_parameters_count_mismatch - module
--validity	w_parent_class_empty - parent


end -- class QA_VALIDITY_ERROR
