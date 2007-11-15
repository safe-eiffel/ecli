indexing

	description:
	
			"Database Errors."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	QA_DATABASE_ERROR

inherit
	QA_ERROR

create
	
	make_connection_failed,
	make_query_failed,
	make_prepare_failed,
	make_warning_prepared
	
feature {NONE} -- Initialization

	make_connection_failed (data_source_name : STRING) is
			-- Make for `data_source_name'.
		require
			data_source_name_not_void: data_source_name /= Void
		do
			default_template := confail_template
			create parameters.make (1,1)
			parameters.put (data_source_name, 1)
		end
		
	make_query_failed (query, diagnostic, module_name : STRING) is
			-- Exectution of `query' failed with `diagnostic' for `module_name'.
		require
			query_not_void: query /= Void
			diagnostic_not_void: diagnostic /= Void
			module_name_not_void: module_name /= Void
		do
			default_template := quefail_template
			create parameters.make (1,3)
			parameters.put (query, 1)
			parameters.put (diagnostic, 2)
			parameters.put (module_name, 3)
		end

	make_prepare_failed (query, diagnostic, module_name : STRING) is
			-- Preparation of `query' failed with `diagnostic' for `module_name'.
		require
			query_not_void: query /= Void
			diagnostic_not_void: diagnostic /= Void
			module_name_not_void: module_name /= Void
		do
			default_template := prefail_template
			create parameters.make (1,3)
			parameters.put (query, 1)
			parameters.put (diagnostic, 2)
			parameters.put (module_name, 3)
		end
		
	make_warning_prepared (module_name : STRING) is
			-- Query of `module_name' has been prepared.
		require
			module_name_not_void: module_name /= Void
		do
			default_template := prepwarn_template
			create parameters.make (1,1)
			parameters.put (module_name,1)
		end
		
		
feature {NONE} -- Implementation

	confail_template : STRING is  "[E-DBS-CONFAIL] Connection failed. DSN=$1."
	quefail_template : STRING is  "[E-DBS-QEXFAIL] Query execution failed for module '$3'.%N%TDiagnostic: $2%N%TQuery: $1"
	prefail_template : STRING is  "[E-DBS-QPRFAIL] Query preparation failed for module '$3'.%N%TDiagnostic: $2%N%TQuery: $1"
	prepwarn_template : STRING is "[W-DBS-QPRONLY] Query has been prepared for module '$1'. Some syntax errors could still remain.%N%TTODO: provide parameter samples so that query can be tried on datasource."

end -- class QA_DATABASE_ERROR
