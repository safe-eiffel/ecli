note
	description: "Test for objects garbage collection.";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	TEST_GC

create

	make

feature -- Initialization

	make
			-- test_gc			
		do
			-- session opening
			if args.argument_count < 3 then
				io.put_string ("Usage: test_gc <data_source> <user_name> <password>%N")
			else
				create session.make_default
				session.set_login_strategy (create {ECLI_SIMPLE_LOGIN}.make (
					attached_string (args.argument (1)),
					attached_string (args.argument (2)),
					attached_string (args.argument (3)))
				)
				session.connect
				if session.has_information_message then
					io.put_string (session.cli_state)
					io.put_string (session.diagnostic_message)
				end
				if session.is_connected then
					io.put_string ("+ Connected %N")
				end
				-- definition of statement on session, which is not disposable
				if attached session as l_session then
					create statement.make (l_session)
					test_gc
				end
			end;
		end

	test_gc
		do
			do_case_a
		end

--	other_test is
--		local
--			stmt0, stmt11, stmt21, stmt22 : ECLI_STATEMENT
--			m : MEMORY
--			sess1, sess2 : ECLI_SESSION
--		do
--			create m
--			--| create 2 new sessions
--			create sess1.make (attached_string (args.argument (1)), "sess1", attached_string (args.argument (3)))
--			sess1.connect
--			create sess2.make (attached_string (args.argument (1)), "sess2", attached_string (args.argument (3)))
--			sess2.connect
--			--| create statement on 'session'
--			create stmt0.make (session)
--			--| create statement on 'sess1'
--			create stmt11.make (sess1)
--			--| create statement on 'sess2'
--			create stmt21.make (sess2)
--			--| create statement on 'sess2' and let it be "attached"
--			create stmt22.make (sess2)

--			--| let stmt 1..3 be "disposable"
--			stmt11.close
--			stmt21.close
--			stmt22.close
--			--| detach reference to sess1
--			sess1.close
----			sess1 := Void -- unattached
----			--| unattach references so that GC can work
----			stmt0 := Void -- still attached
----			stmt11 := Void -- unattached
----			stmt21 := Void -- unattached
----			stmt22 := Void -- unattached
--			--| collect available data
--			--| collectable at this point : sess1, stmt11, stmt21, stmt22
--			print ("manual collect")
--			m.full_collect
--			--| collectable after this point : sess2
--		end

	-- test cases :
	--	case		SESSION		STATEMENTS	BOOST
	--	A		open		open		N	--> precondition fired
	--	B		open		open		Y	--> exception raised
	--	C		open		closed		-	--> exception raised
	--	D		closed		open		N	--> precondition fired SESSION.close
	--	E		closed		closed		-	--> nothing


	a_ok, b_ok, c_ok, d_ok, e_ok : BOOLEAN
	a_tried, b_tried, c_tried, d_tried, e_tried : BOOLEAN

	do_case_a
		do
			if not a_tried then
				a_tried := True
				create session.make_default
				session.set_login_strategy (create {ECLI_SIMPLE_LOGIN}.make (
					attached_string (args.argument (1)),
					attached_string (args.argument (2)),
					attached_string (args.argument (3))
					)
				)

				if attached session as l_session then
					session.connect
					create statement.make (l_session)
				end
				-- loose references
				session := Void
				statement := Void
				memory.full_collect
			end
		rescue
			a_tried := True
			retry
		end

	attached_string (s : detachable STRING) : STRING
		do
			check attached s as l_s then
				Result := l_s
			end
		end

		do
		end

	do_case_c
		do
		end

	do_case_d
		do
		end

	do_case_e
		do
		end


	args : ARGUMENTS once create Result end 

	session : detachable ECLI_SESSION
	statement : detachable ECLI_STATEMENT

	memory : MEMORY once create Result end

end -- class TEST_GC
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
