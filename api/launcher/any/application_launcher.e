note
	description: "[
				Effective class for APPLICATION_LAUNCHER_I

				You can put modification in this class
			]"
	date: "$Date: 2014-08-08 16:02:11 -0300 (vi., 08 ago. 2014) $"
	revision: "$Revision: 95593 $"

class
	APPLICATION_LAUNCHER

inherit
	APPLICATION_LAUNCHER_I

feature -- Custom

	is_console_output_supported: BOOLEAN
		do
			Result := False
		end

end

