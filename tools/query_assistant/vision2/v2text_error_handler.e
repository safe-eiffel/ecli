indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	V2TEXT_ERROR_HANDLER

inherit

	QA_ERROR_HANDLER
		redefine
			report_error_message,
			report_warning_message,
			report_info_message
		end

create
	make

feature {NONE} -- Initialization

	make (a_text : EV_RICH_TEXT) is
		require
			a_text_not_void: a_text /= Void
		do
			text := a_text
			make_standard
		end

feature -- Access

	text : EV_RICH_TEXT

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

	report_error_message (an_error : STRING) is
		do
			append_text (an_error, error_format)
			append_text ("%N", error_format)
		end

	report_info_message (an_error : STRING) is
		do
			if is_verbose then
				append_text (an_error, info_format)
				append_text ("%N", info_format)
	--			precursor (an_error)
			end
		end

	report_warning_message (an_error : STRING) is
		do
			append_text (an_error, warning_format)
			append_text ("%N",warning_format)
--			precursor (an_error)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	append_text (a_string : STRING; a_format : EV_CHARACTER_FORMAT) is
		require
			a_string_not_void: a_string /= Void
		local
			s: STRING
			istart, iend : INTEGER
			f : EV_CHARACTER_FORMAT
		do
			s := a_string.twin
			s.prune_all('%R')
			istart := text.text_length.max (1)
			text.append_text (s)
			iend := text.text_length + 1
			f := a_format
			if a_string.count > 3 then
				if a_format = error_format and not a_string.substring (1,3).is_equal ("[E-") then
					f := info_format
				end
			end
			text.format_region (istart, iend, f)
			text.scroll_to_end
		end

	info_format : EV_CHARACTER_FORMAT is
		once
			create Result.make_with_font_and_color (message_font, info_color, color_white)
		ensure
			result_not_void: Result /= Void
		end


	warning_format : EV_CHARACTER_FORMAT
		once
			create Result.make_with_font_and_color (message_font, warning_color, color_white)
		ensure
			result_not_void: Result /= Void
		end

	error_format : EV_CHARACTER_FORMAT is
		once
			create Result.make_with_font_and_color (message_font, error_color, color_white)
		ensure
			result_not_void: Result /= Void
		end

	error_color : EV_COLOR is
		once
			create Result.make_with_8_bit_rgb (255,0,0)
		ensure
			result_not_void: Result /= Void
		end

	warning_color : EV_COLOR is
		once
			create Result.make_with_8_bit_rgb (255, 127, 0)
		ensure
			result_not_void: Result /= Void
		end

	info_color : EV_COLOR is
		once
			create Result.make_with_8_bit_rgb (0, 0,255)
		ensure
			result_not_void: Result /= Void
		end

	message_font : EV_FONT is
		local
			fc : EV_FONT_CONSTANTS
		once
			create fc
			create Result.make_with_values (
				fc.family_modern,
				fc.weight_regular,
				fc.shape_regular,
				10)
		end

	color_white : EV_COLOR is
		once
			create Result.make_with_rgb (1,1,1)
		ensure
			result_not_void: Result /= Void
		end

invariant

	text_not_void: text /= Void

end
