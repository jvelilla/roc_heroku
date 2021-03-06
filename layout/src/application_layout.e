note
	description: "[API Layout, to provide paths(config, application, log, documentation, www, html cj)]"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	APPLICATION_LAYOUT

create
	make_default,
	make_with_path

feature {NONE} -- Initialization

	make_default
			-- Create a default layout based on current working directory.
		local
			p: PATH
		do
			create p.make_current
			p := p.extended ("site")
			make_with_path (p)
		end

	make_with_path (p: PATH)
			-- Create a layour based on a path `p'.
		do
			path := p.absolute_path.canonical_path
		end

feature -- Access

	path: PATH

feature -- Access: internal

	config_path: PATH
			-- Configuration file path.
		once
			Result := path.extended ("config")
		end

	application_config_path: PATH
			-- Database Configuration file path.
		once
			Result := config_path.extended ("application_configuration.json")
		end

	logs_path: PATH
			-- Directory for logs.
		once
			Result := path.extended ("logs")
		end

	documentation_path: PATH
			-- Directory for API documentation.
		once
			Result := path.extended ("doc")
		end

	www_path: PATH
			-- Directory for www.
		once
			Result := path.extended ("www")
		end

	assets_path: PATH
			-- Directory for public assets.
			-- css, images, js.
		once
			Result := path.extended ("www").extended ("assets")
		end

	template_path: PATH
			-- Directory for templates (HTML, etc).
		once
			Result := www_path.extended ("template")
		end

end
