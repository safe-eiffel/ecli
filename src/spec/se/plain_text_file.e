indexing

description: "Attempt to make files portable";
keywords: "text", "file", "portable"
status: "See notice at end of class";
date: "$Date$";
revision: "$Revision$"

class PLAIN_TEXT_FILE
    
inherit
    FILE

creation
    make, make_open_read, make_open_write,
    make_open_append, make_open_read_write
    
feature -- Output
    
    put_integer, putint (i: INTEGER) is
        -- Write ASCII value of `i' at current position.

        do
            ext_putint (fdata, i)
        end
----------------------

    put_character, putchar (c : CHARACTER) is

        local
            ah   : ECLI_EXTERNAL_TOOLS
            lstr : STRING
            ext  : POINTER

        do
            create ah
            lstr := clone ("")
            lstr.extend (c)
            ext := ah.string_to_pointer (lstr)
            ext_putstr (fdata, ext)
        end    
----------------------
    
    put_boolean, putbool (b: BOOLEAN) is
        -- Write ASCII value of `b' at current position.

        local
            ah           : ECLI_EXTERNAL_TOOLS
            ext_bool_str : POINTER

        do
            if b then
                create ah
                ext_bool_str := ah.string_to_pointer (true_string)
                ext_putstr (fdata, ext_bool_str)

            else
                create ah
                ext_bool_str := ah.string_to_pointer (false_string)
                ext_putstr (fdata, ext_bool_str)
            end
        end
----------------------
    
    put_real, putreal (r: REAL) is
        -- Write ASCII value of `r' at current position.

        do
            ext_putreal (fdata, r)
        end
----------------------
    
    put_double, putdouble (d: DOUBLE) is
        -- Write ASCII value `d' at current position.

        do
            ext_putdouble (fdata, d)
        end
----------------------    

    put_string, putstring (s : STRING) is

        local
            ah  : ECLI_EXTERNAL_TOOLS
            ext : POINTER

        do
            create ah
            ext := ah.string_to_pointer (s)
            ext_putstr (fdata, ext)
        end
----------------------

    put_new_line, new_line is

        do
            ext_newline (fdata)
        end
----------------------
feature -- Input
    
    read_integer, readint is
        -- Read the ASCII representation of a new integer
        -- from file. Make result available in `last_integer'.

        local
            res : BOOLEAN

        do
            res := ext_readint (fdata, $last_integer)
        end
----------------------
    
    read_real, readreal is
        -- Read the ASCII representation of a new real
        -- from file. Make result available in `last_real'.

        local
            res : BOOLEAN

        do
            res := ext_readreal (fdata, $last_real)
        end
----------------------
    
    read_double, readdouble is
        -- Read the ASCII representation of a new double
        -- from file. Make result available in `last_double'.

        local
            res : BOOLEAN

        do
            res := ext_readdouble (fdata, $last_double)
        end
----------------------

    read_line, readline is
        -- Read a string into `last_string'.
        -- Read to first new line, but do not
        -- include new line in result.

        local
            p  : POINTER
            ah : ECLI_EXTERNAL_TOOLS

        do
            last_string := clone ("")
            p           := ext_readline (fdata)
            if p /= Default_pointer then
                create ah
                last_string := ah.pointer_to_string (p)
            end
        end
----------------------

    read_character, readchar is
        -- Read a character. Make result available in 'last_character'

        local
            res : BOOLEAN

        do
            res := ext_readchar (fdata, $last_character)
        end
----------------------

    end_of_file : BOOLEAN is

        do
            result := ext_eof (fdata)
        end
----------------------
feature { NONE }
    
    true_string  : STRING is "true"
    false_string : STRING is "false"    
----------------------
    
    ext_putint (fp : POINTER; i : INTEGER) is
        
        external "C"
        alias "FILE_putint"
            
        end
----------------------
    
    ext_putstr (fp, sp : POINTER) is
        
        external "C"
        alias "FILE_putstr"
            
        end
----------------------
    
    ext_putreal (fp : POINTER; r : REAL) is
        
        external "C"
        alias "FILE_putreal"
            
        end
----------------------

    ext_putdouble (fp : POINTER; d : DOUBLE) is

        external "C"
        alias "FILE_putdouble"

        end
----------------------

    ext_newline (fp : POINTER) is

        external "C"
        alias    "FILE_newline"

        end
----------------------

    ext_readint (fp, ip : POINTER) : BOOLEAN is

        external"C"
        alias "FILE_readint"

        end
----------------------

    ext_readreal (fp, rp : POINTER) : BOOLEAN is

        external "C"
        alias "FILE_readreal"

        end
----------------------

    ext_readdouble (fp, dp : POINTER) : BOOLEAN is

        external "C"
        alias "FILE_readdouble"

        end
----------------------

    ext_readline (fp : POINTER) : POINTER is

        external "C"
        alias "FILE_readline"

        end
----------------------

    ext_readchar (fp, cp : POINTER) : BOOLEAN is

        external "C"
        alias "FILE_readchar"

        end
----------------------

    ext_eof (fp : POINTER) : BOOLEAN is

        external "C"
        alias "FILE_eof"

        end
    
end -- class PLAIN_TEXT_FILE

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
