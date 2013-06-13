CLISQL 

	clisql is an interactive sql interpreter



Usage:

	clisql [-dsn <datasource> -user <username> -pwd <password> [-sql_file_name <sqlfilename>]] [-set <varname>=<varvalue>]*

	-dsn	datasource	Data Source Name to connect with
	-user	username	User name for establishing the connection
	-pwd	password	Password
	-sql_fil_name filename	File with a clisql script. A clisql script is just a sequence of CLISQL commands.
	-set	varname=value	Set 'varname' with 'value' for using in CLISQL commands.

	

Commands:


Enter any command followed by a semicolon.
This semicolon launches command execution.
Command names can be abbreviated; characters between [ ] are optional.

Available commands ('*' = needs a connected session) :
* be[gin transaction]           Begin a new transaction.
* col[umns] <table-name>        List all columns in <table-name>.
  con[nect] <dsn> <user> <pwd>  Connect to <dsn> datasource as <user> with pa
ord <pwd>.
* com[mit transaction]          Commit current transaction.
* dis[connect]                  Disconnect current session.
  dri[vers]                     List registered drivers.
  edit                          Edit query buffer with current editor.
* exec[ute] <filename>          Execute clisql command_stream from <filename>
* fk <table-name>               List all foreign columns in <table-name>.
  he[lp]                        Print the list of available commands.
  hist[ory]                     Print the commands history.
  out[put] <filename>|stdout    Direct output to <filename> | stdout.
* pk <table-name>               List all primary columns in <table-name>.
* pro[cedures]                  List all procedures in current catalog
* pcol[umns] <procedure-name>   List all columns in <procedure-name>.
  q[uit]                        Quit the application.
  re[call] <i>                  Recall the <i>th command in the history.
* rol[lback transaction]        Rollback current transaction.
  set [<variable_name>=<value>] Set/[show] variables.
  sou[rces]                     List all datasources defined on current syste
* tab[les]                      List all tables in current catalog.
* ty[pes]                       List all types supported by current connectio
  usage                         Print command usage.
* <any sql statement>           Execute any SQL statement or procedure call.

Variables:

CLISQL uses variables for its inner working.

Variables can be set for 2 purposes:
# Modify the behaviour of clisql commands. Namely: formatting results, external editor command
# Pass variable values for SQL statements with named parameters.

Setting a variable:

The following command associates the value "This is a string\nwith a newline" to variable foo

	set foo="This is a string\nwith a newline";

Recognized special characters are newline (\n) and tab (\n).
	
Predefined variables:

_heading_begin
	Begin results heading. Default: ""

_heading_end
	End results heading. Default: "\n"

_heading_separator
	Separator for heading items. Default: ","

_row_begin
	Begin for result row. Default: ""

_column_separator
	Separator between items in a row. Default: ","

_row_end
	End of a result row. Default: "\n"

_editor
	Application that is launched by the 'edit' command. Default: "notepad"

Formatting results:
It is possible to define scripts that set the results formatting variables so that output is in a specific format like XML, csv, ...

