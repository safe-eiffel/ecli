indexing

description: "Attempt to make IO portable";
keywords: "IO", "portable"
status: "See notice at end of class";
date: "$Date$";
revision: "$Revision$"

deferred class IO_MEDIUM
    
feature -- Output
    
    put_new_line, new_line is
        -- Write a new line character to medium
        require
            extendible: extendible
        deferred
        end;
    
    put_string, putstring (s: STRING) is
        -- Write `s' to medium.
        require
            extendible: extendible
            non_void: s /= Void
        deferred
        end;
    
    put_character, putchar (c: CHARACTER) is
        -- Write `c' to medium.
        require
            extendible: extendible
        deferred
        end;
    
    put_real, putreal (r: REAL) is
        -- Write `r' to medium.
        require
            extendible: extendible
        deferred
        end;
    
    put_integer, putint (i: INTEGER) is
        -- Write `i' to medium.
        require
            extendible: extendible
        deferred
        end;
    
    put_boolean, putbool (b: BOOLEAN) is
        -- Write `b' to medium.
        require
            extendible: extendible
        deferred
        end;
    
    put_double, putdouble (d: DOUBLE) is
        -- Write `d' to medium.
        require
            extendible: extendible
        deferred
        end;
----------------------
feature -- INPUT
    
    last_real      : REAL
    last_double    : DOUBLE
    last_character : CHARACTER
    last_integer   : INTEGER
    last_string    : STRING
    
    read_real, readreal is
        -- Read a new real.
        -- Make result available in `last_real'.
        require
            is_readable: readable
        deferred
        end;
    
    read_double, readdouble is
        -- Read a new double.
        -- Make result available in `last_double'.
        require
            is_readable: readable
        deferred
        end;
    
    read_character, readchar is
        -- Read a new character.
        -- Make result available in `last_character'.
        require
            is_readable: readable
        deferred
        end;
    
    read_integer, readint is
        -- Read a new integer.
        -- Make result available in `last_integer'.
        require
            is_readable: readable
        deferred
        end;
    
    read_line, readline is
        -- Read characters until a new line or
        -- end of medium.
        -- Make result available in `last_string'.
        require
            is_readable: readable
        deferred
        end;
    
----------------------
feature -- Status
    
    file_writable, extendible : BOOLEAN is
        
        deferred
        end
----------------------
    
    file_readable, readable : BOOLEAN is
        
        deferred
        end
----------------------

    end_of_file : BOOLEAN is

        deferred
        end
----------------------

    is_plain_text : BOOLEAN is

        do
            result := true -- until further notice
        end
    
end -- class IO_MEDIUM

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
