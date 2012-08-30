note

	description:

			"Validity Errors."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class QA_VALIDITY_ERROR

inherit
	QA_ERROR

create

	make_already_exists,
	make_invalid_reference_column,
	make_parameter_not_described,
	make_parameter_count_mismatch,
	make_parent_class_empty,
	make_parameter_already_defined,
	make_parameter_unknown,
	make_rejected,
	make_parameter_set_parent_same_name,
	make_parameter_type_mismatch

feature {NONE} -- Initializaiton

	make_already_exists (who, what, type : STRING)
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

	make_rejected (module_name : STRING)
			-- Make `module_name' rejected.
		require
			module_name_not_void: module_name /= Void
		do
			default_template := reject_template
			create parameters.make (1, 1)
			parameters.put (module_name, 1)
		end

	make_invalid_reference_column (module, name, table, column : STRING)
			-- Make `name' in `module' has an invalid reference column as `table'.`column'.
		do
			default_template := invrefcol_template
			create parameters.make (1, 4)
			parameters.put (module, 1)
			parameters.put (name, 2)
			parameters.put (table, 3)
			parameters.put (column, 4)
		end

	make_parameter_not_described (module, name : STRING)
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

	make_parameter_count_mismatch (module : STRING)
			-- Make parameter count mismatch in `module'.
		require
			module_not_void: module /= Void
		do
			default_template := countmis_template
			create parameters.make (1, 1)
			parameters.put (module, 1)
		end

	make_parent_class_empty (parent : STRING)
			-- Make warning `parent' class is empty.
		require
			parent_not_void: parent /= Void
		do
			default_template := parclempty_template
			create parameters.make (1, 1)
			parameters.put (parent, 1)
		end

	make_parameter_already_defined (module, name, attribute_name : STRING)
			-- Make redundant description of `attribute_name' for `name' in `module'.
		require
			module_not_void: module /= Void
			name_not_void: name /= Void
			attribute_name_not_void: attribute_name /= Void
		do
			default_template := alrdyde_template
			create parameters.make (1, 3)
			parameters.put (module, 1)
			parameters.put (name, 2)
			parameters.put (attribute_name, 3)
		end

	make_parameter_set_parent_same_name (module, name, parent_name : STRING)
			-- Make parameter-set parent name `parent_name' same as parameter-set `name' in `module'.
		require
			module_not_void: module /= Void
			name_not_void: name /= Void
			parent_name_not_void: parent_name /= Void
		do
			default_template := parparsame_template
			create parameters.make (1, 3)
			parameters.put (module, 1)
			parameters.put (name, 2)
			parameters.put (parent_name, 3)
		end

	make_parameter_unknown (module, name : STRING)
			-- Report parameter `name' in `module' is unknown but defined.
		require
			module_not_void: module /= Void
			name_not_void: name /= Void
		do
			default_template := parunknown_template
			create parameters.make (1,2)
			parameters.put (module, 1)
			parameters.put (name, 2)
		end

	make_parameter_type_mismatch (access_name, name, declared_type, sample_type: STRING)
			-- Report parameter `name' in `access_name' has an already defined `attribute_name' attribute.
		require
			access_name_not_void: access_name /= void
			name_not_void: name /= Void
			declared_type_not_void: declared_type /= void
			sample_type_not_void: sample_type /= void
		do
			default_template := partypmis_template
			create parameters.make (1,4)
			parameters.put (access_name, 1)
			parameters.put (name, 2)
			parameters.put (declared_type, 3)
			parameters.put (sample_type, 4)

		end

feature {NONE} -- Implementation

	alex_template : STRING =       "[E-VAL-ALRDYEX] Module $1 : $3 `$2' already exists."
	invrefcol_template : STRING =  "[E-VAL-INRFCOL] Module $1 : SQL parameter `$2' has an invalid reference column [$3.$4].%N%TNOTE: Name comparison is case SENSITIVE.%N%TWhat to do: Check the names and the case in the reference column definition."
	misdesc_template : STRING =    "[E-VAL-MISDESC] Module $1 : missing description for SQL parameter `$2'."
	countmis_template : STRING =   "[E-VAL-CNTMISM] Module $1 : Mismatch between count of SQL parameters and of declared parameters."
	parclempty_template : STRING = "[W-VAL-CLEMPTY] Parent class `$1' is empty."
	alrdyde_template : STRING = 	"[E-VAL-ALRDYDF] Module $1 : Parameter $2 must not have a '$3' attribute, since it already has one from a template."
	parparsame_template : STRING = "[E-VAL-PARNSAM] Module $1 : Parameter-set $2 and parent name '$3' are the same : they must be different."
	parunknown_template : STRING = "[E-VAL-PARUNKN] Module $1 : Parameter $2 has been defined but does not appear in SQL."
	reject_template : STRING = 	"[W-VAL-MREJECT] Module $1 has been rejected because of errors in its XML definition."
	partypmis_template : STRING =  "[W-VAL-PARTYPM] Module $1 : Parameter $2 type '$3' mismatch with sample type '$4'. Todo: check parameter sample string; use ODBC escape syntax for date, time and timestamp."

end -- class QA_VALIDITY_ERROR
