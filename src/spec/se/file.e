indexing

description: "Attempt to make portable files";
keywords: "file", "portable"
status: "See notice at end of class";
date: "$Date$";
revision: "$Revision$"

deferred class FILE

inherit
    IO_MEDIUM

feature -- Initialization

	make (fn: STRING) is
			-- Create file object with `fn' as file name.
		require
			string_exists: fn /= Void
			string_not_empty: not fn.empty
		do
			name  := fn;
                        flags := Closed
			!! last_string.make (256)
		ensure
			file_named: name.is_equal (fn);
			file_closed: is_closed;
		end;

	make_open_read (fn: STRING) is
			-- Create file object with `fn' as file name
			-- and open file in read mode.
		require
			string_exists: fn /= Void;
			string_not_empty: not fn.empty
		do
			make (fn);
			open_read;
		ensure
			exists: exists
			open_read: is_open_read
		end;

	make_open_write (fn: STRING) is
			-- Create file object with `fn' as file name
			-- and open file for writing;
			-- create it if it does not exist.
		require
			string_exists: fn /= Void;
			string_not_empty: not fn.empty
		do
			make (fn);
			open_write;
		ensure
			exists: exists
			open_write: is_open_write
		end;

	make_open_append (fn: STRING) is
			-- Create file object with `fn' as file name
			-- and open file in append-only mode.
		require
			string_exists: fn /= Void;
			string_not_empty: not fn.empty
		do
			make (fn);
			open_append;
		ensure
			exists: exists
			open_append: is_open_append
		end;

	make_open_read_write (fn: STRING) is
			-- Create file object with `fn' as file name
			-- and open file for both reading and writing.
		require
			string_exists: fn /= Void;
			string_not_empty: not fn.empty
		do
			make (fn);
			open_read_write;
		ensure
			exists: exists
			open_read: is_open_read
			open_write: is_open_write
		end;
----------------------

    is_closed : BOOLEAN is

        do
            result := (flags = Closed)
        end
----------------------

    close is

        do
            ext_close (fdata)
            flags := Closed
        end
----------------------

    file_writable, extendible : BOOLEAN is

        do
            result := (exists and then is_open_write)
        end
----------------------

    file_readable, readable : BOOLEAN is

        do
            result := (exists and then is_open_read)
        end
----------------------

    name  : STRING

----------------------

    change_name (new_name : STRING) is
        -- NOTE: This won't work if `new_name' and 'name'
        -- are in different file systems.

        local
            fs : FILE_SYSTEM

        do
            create fs.make
            fs.change_name (name, new_name)
            name := new_name
        end
----------------------
feature { NONE }

    Error      : INTEGER is 0
    Read       : INTEGER is 1
    Write      : INTEGER is 2
    Read_write : INTEGER is 3
    Append     : INTEGER is 4
    Closed     : INTEGER is 5

    fdata         : POINTER
    flags         : INTEGER
    error_message : STRING
----------------------

    exists : BOOLEAN is

        do
            result := (fdata /= Default_pointer)
        end
----------------------

    is_open_read : BOOLEAN is

        do
            result := ((flags = Read) or else (flags = Read_write))
        end
----------------------

    is_open_write : BOOLEAN is

        do
            result := ((flags = Write)      or else
                       (flags = Read_write) or else
                       (flags = Append))
        end
----------------------

    is_open_append : BOOLEAN is

        do
            result := (flags = Append)
        end
----------------------

    open_read is

        local
            ah : ECLI_EXTERNAL_TOOLS
            p  : POINTER

        do
            create ah
            p := ah.string_to_pointer (name)
            fdata := ext_open_read (p)
            if fdata /= Default_pointer then
                flags := Read
            else
                error_message := ah.pointer_to_string (ext_error_message)
                flags         := Error
            end
        end
----------------------

    open_write is

        local
            ah : ECLI_EXTERNAL_TOOLS
            p  : POINTER

        do
            create ah
            p := ah.string_to_pointer (name)
            fdata := ext_open_write (p)
            if fdata /= Default_pointer then
                flags := Write
            else
                error_message := ah.pointer_to_string (ext_error_message)
                flags         := Error
            end
        end
----------------------

    open_append is

        local
            ah : ECLI_EXTERNAL_TOOLS
            p  : POINTER

        do
            create ah
            p := ah.string_to_pointer (name)
            fdata := ext_open_append (p)
            if fdata /= Default_pointer then
                flags := Append
            else
                error_message := ah.pointer_to_string (ext_error_message)
                flags         := Error
            end
        end
----------------------

    open_read_write is

        local
            ah : ECLI_EXTERNAL_TOOLS
            p  : POINTER

        do
            create ah
            p := ah.string_to_pointer (name)
            fdata := ext_open_read_write (p)
            if fdata /= Default_pointer then
                flags := Read_write
            else
                error_message := ah.pointer_to_string (ext_error_message)
                flags         := Error
            end
        end
----------------------

    ext_open_read (p : POINTER) : POINTER is

        external "C"
        alias "FILE_open_read"

        end
----------------------

    ext_open_write (p : POINTER) : POINTER is

        external "C"
        alias "FILE_open_write"

        end
----------------------

    ext_open_append (p : POINTER) : POINTER is

        external "C"
        alias "FILE_open_append"

        end
----------------------

    ext_open_read_write (p : POINTER) : POINTER is

        external "C"
        alias "FILE_open_read_write"

        end
----------------------

    ext_close (p : POINTER) is

        external "C"
        alias "FILE_close"

        end
----------------------

    ext_error_message : POINTER is

        external "C"
        alias "FILE_error_message"

        end

end -- class FILE

------------------------------------------------------------------------
--                                                                    --
--  MICO/E --- a free CORBA implementation                            --
--  Copyright (C) 1999 by Robert Switzer                              --
--                                                                    --
--  This library is free software; you can redistribute it and/or     --
--  modify it under the terms of the GNU Library General Public       --
--  License as published by the Free Software Foundation; either      --
--  version 2 of the License, or (at your option) any later version.  --
--                                                                    --
--  This library is distributed in the hope that it will be useful,   --
--  but WITHOUT ANY WARRANTY; without even the implied warranty of    --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
--  Library General Public License for more details.                  --
--                                                                    --
--  You should have received a copy of the GNU Library General Public --
--  License along with this library; if not, write to the Free        --
--  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.--
--                                                                    --
--  Send comments and/or bug reports to:                              --
--                 micoe@math.uni-goettingen.de                       --
--                                                                    --
------------------------------------------------------------------------





