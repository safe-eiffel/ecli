indexing

	description:
	
			"Simple Login Strategies that use a datasource name, a user name and a password."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_SIMPLE_LOGIN

inherit

	ECLI_LOGIN_STRATEGY

create
	
	make
	
feature {NONE} -- Initialization

	make (a_datasource_name, a_user_name, a_password : STRING) is
			-- Make for logging in `a_datasource_name' by `a_user_name' using `a_password'.
		require
			a_datasource_name_not_void: a_datasource_name /= Void
			a_user_name_not_void: a_user_name /= Void
			a_password_not_void: a_password /= Void
		do
			set_datasource_name (a_datasource_name)
			set_user_name (a_user_name)
			set_password (a_password)
		ensure
			datasource_name_set: equal (datasource_name, a_datasource_name)
			user_name_set: equal (user_name, a_user_name)
			password_set: equal (password, a_password)
		end
		
feature -- Access

	datasource_name : STRING is
		do
			Result := impl_datasource_name.as_string
		end
		
	user_name : STRING is
		do
			Result := impl_user_name.as_string
		end
		
	password : STRING is
		do
			Result := impl_password.as_string
		end

feature -- Element change

	set_user_name(a_user_name: STRING) is
			-- Set `user' to `a_user'
		require
			a_user_ok: a_user_name/= Void
		do
			create impl_user_name.make_from_string (a_user_name)
		ensure
			user_name_set: user_name.is_equal (a_user_name)
		end

	set_datasource_name (a_datasource_name : STRING) is
			-- Set `datasource_name' to `a_datasource_name'
		require
			a_datasource_name_not_void: a_datasource_name /= Void
		do
			create impl_datasource_name.make_from_string (a_datasource_name)
		ensure
			datasource_name_set: datasource_name.is_equal (a_datasource_name)
		end

	set_password (a_password : STRING) is
			-- Set password to 'a_password
		require
			a_password_ok: a_password /= Void
		do
			create impl_password.make_from_string (a_password)
		ensure
			password_set: password.is_equal (a_password)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature {ECLI_SESSION} -- Basic operations

	Connect (the_session : ECLI_SESSION) is
			-- do login `the_session'
		do
			the_session.set_status ("ecli_c_connect", ecli_c_connect (the_session.handle,
					impl_datasource_name.handle,
					impl_user_name.handle,
					impl_password.handle))
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	impl_datasource_name : XS_C_STRING

	impl_user_name: XS_C_STRING

	impl_password : XS_C_STRING

invariant

	datasource_name_not_void: datasource_name /= Void
	user_name_not_void: user_name /= Void
	password_not_void: password /= Void
	
end -- class ECLI_SIMPLE_LOGIN
