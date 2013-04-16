note
	description: "ISQL Command catalog."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_COMMANDS

create
	make

feature {NONE} -- Initialization

	make
			-- make commands catalog
		local
			l_command : ISQL_COMMAND
		do
			create {DS_LINKED_LIST[ISQL_COMMAND]}commands.make
			create {ISQL_CMD_BEGIN}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_COLUMNS}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_CONNECT}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_COMMIT}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_DISCONNECT}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_DRIVERS}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_EDIT}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_EXECUTE} execute_command
			commands.put_last (execute_command)
			create {ISQL_CMD_FOREIGN_KEYS}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_HELP} l_command
			commands.put_last (l_command)
			create {ISQL_CMD_HISTORY} l_command
			commands.put_last (l_command)
			create {ISQL_CMD_OUTPUT} l_command
			commands.put_last (l_command)
			create {ISQL_CMD_PRIMARY_KEYS}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_PROCEDURES}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_PROCEDURE_COLUMNS}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_QUIT}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_RECALL}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_ROLLBACK}l_command
			commands.put_last (l_command)
			create set_command
			commands.put_last (set_command)
			create {ISQL_CMD_SOURCES}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_TABLES}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_TYPES}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_USAGE} usage_command
			commands.put_last (usage_command)
			create {ISQL_CMD_SQL}sql_command
			commands.put_last (sql_command)
		end

feature -- Access

	commands : DS_LIST[ISQL_COMMAND]

	sql_command : ISQL_CMD_SQL

	execute_command : ISQL_CMD_EXECUTE

	set_command : ISQL_CMD_SET

	usage_command : ISQL_CMD_USAGE

	new_cursor : DS_LIST_CURSOR [ISQL_COMMAND]
		do
			Result := commands.new_cursor
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	do_session (context : ISQL_CONTEXT; file_name : STRING)
		local
			l_command_text : STRING
		do
			create l_command_text.make (40)
			l_command_text.append_string ("execute")
			if file_name /= Void then
				l_command_text.append_character (' ')
				l_command_text.append_string (file_name)
			end
			execute_command.execute (l_command_text, context)
		end

	execute (a_text : STRING; context : ISQL_CONTEXT)
		local
			command : ISQL_COMMAND
		do
			from
				commands.start
			until
				commands.off or else commands.item_for_iteration.matches (a_text)
			loop
				commands.forth
			end
			if not commands.off then
				command := commands.item_for_iteration
			else
				command := sql_command
			end
			if command.needs_session then
				if context.session = Void or else not context.session.is_connected then
					context.filter.begin_error
					context.filter.put_error ("Not Connected : unable to execute command.%NUse CONNECT command to do so.%N")
					context.filter.end_error
				else
					command.execute (a_text, context)
				end
			else
				command.execute (a_text, context)
			end
			if False then
				context.filter.begin_error
				context.filter.put_error ("Unknown command_stream : " + context.command_stream.text)
				context.filter.end_error
			end
		end

feature -- Obsolete

feature -- Inapplicable

end
