class STD_FILES

inherit
    FILE
        undefine
            make
        redefine
            close, is_closed, file_writable, extendible,
            file_readable, readable
        end

creation
    make, make_default

feature

    make (n : STRING) is

        do
            create default_output.make_open_write (n)
            create output.make_open_write ("stdout")
            create error_out.make_open_write ("stderr")
            create input.make_open_read ("stdin")
            default_input := input
        end
----------------------

    make_default is

        do
            create output.make_open_write ("stdout")
            create error_out.make_open_write ("stderr")
            create input.make_open_read ("stdin")
            default_output := output
            default_input  := input
        end
----------------------

    set_file_default (f : PLAIN_TEXT_FILE) is

        require
            nonvoid_arg : f /= void
            can_write   : f.file_writable

        do
            default_output := f
        end
----------------------

    set_output_default is

        do
            default_output := output
        end
----------------------

    set_error_default is

        do
            default_output := error_out
        end
----------------------

    put_new_line, new_line is

        do
            default_output.new_line
        end
----------------------

    put_string, putstring (s: STRING) is

        do
            default_output.put_string (s)
        end
----------------------

    put_character, putchar (c : CHARACTER) is

        do
            default_output.put_character (c)
        end
----------------------

    put_real, putreal (r: REAL) is

        do
            default_output.put_real (r)
        end
----------------------

    put_integer, putint (i: INTEGER) is

        do
            default_output.put_integer (i)
        end
----------------------

    put_boolean, putbool (b: BOOLEAN) is

        do
            default_output.put_boolean (b)
        end
----------------------

    put_double, putdouble (d: DOUBLE) is

        do
            default_output.put_double (d)
        end
----------------------

    read_real, readreal is

        do
            default_input.readreal
            last_real := default_input.last_real
        end
----------------------

    read_double, readdouble is

        do
            default_input.readdouble
            last_double := default_input.last_double
        end
----------------------

    read_character, readchar is

        do
            default_input.readchar
            last_character := default_input.last_character
        end
----------------------

    read_integer, readint is

        do
            default_input.readint
            last_integer := default_input.last_integer
        end
----------------------

    read_line, readline is

        do
            default_input.readline
            last_string := default_input.last_string
        end
----------------------

    end_of_file : BOOLEAN is

        do
            result := default_input.end_of_file
        end
----------------------

    is_closed : BOOLEAN is

        do
            result := (default_input.is_closed and then
                       default_output.is_closed)
        end
----------------------

    close is

        do
            default_input.close
            default_output.close
        end
----------------------

    file_writable, extendible : BOOLEAN is

        do
            result := (default_output.extendible)
        end
----------------------

    file_readable, readable : BOOLEAN is

        do
            result := (default_input.readable)
        end
----------------------
feature { NONE }

    output         : PLAIN_TEXT_FILE
    error_out      : PLAIN_TEXT_FILE
    input          : PLAIN_TEXT_FILE
    default_output : PLAIN_TEXT_FILE
    default_input  : PLAIN_TEXT_FILE

end -- class STD_FILES
