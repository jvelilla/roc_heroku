note
	description: "API configuration factory"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	CONFIGURATION_FACTORY

inherit

	SHARED_EXECUTION_ENVIRONMENT

	SHARED_ERROR

feature -- Factory

	roc_config (a_dir: detachable STRING): ROC_CONFIG
		local
			l_layout: APPLICATION_LAYOUT
			l_email_service: ROC_EMAIL_SERVICE
			l_database: DATABASE_CONNECTION
			l_api_service: ROC_API_SERVICE
			l_retried: BOOLEAN
		do
			if not l_retried then
				if attached a_dir then
					create l_layout.make_with_path (create {PATH}.make_from_string (a_dir))
				else
					create l_layout.make_default
				end
				log.write_information (generator + ".roc_config " + l_layout.path.name.out)

				create l_email_service.make ((create {JSON_CONFIGURATION}).new_smtp_configuration(l_layout.application_config_path))

				if attached (create {JSON_CONFIGURATION}).new_database_configuration (l_layout.application_config_path) as l_database_config then
					create {DATABASE_CONNECTION_MYSQL} l_database.login_with_connection_string (l_database_config.connection_string)
					create l_api_service.make (create {CMS_STORAGE_MYSQL}.make (l_database))
					create Result.make (l_database, l_api_service, l_email_service, l_layout)
					if (create {ROC_JSON_CONFIGURATION}).is_web_mode(l_layout.application_config_path) then
						Result.mark_web
					elseif (create {ROC_JSON_CONFIGURATION}).is_html_mode(l_layout.application_config_path) then
						Result.mark_html
					end
					set_successful
				else
					create {DATABASE_CONNECTION_NULL} l_database.make_common
					create l_api_service.make (create {CMS_STORAGE_NULL})
					create Result.make (l_database, l_api_service, l_email_service, l_layout)
					set_last_error ("Database Connections", generator + ".roc_config")
					log.write_error (generator + ".roc_config Error database connection" )
				end
			else
				if attached a_dir then
					create l_layout.make_with_path (create {PATH}.make_from_string (a_dir))
				else
					create l_layout.make_default
				end
				create l_email_service.make ((create {JSON_CONFIGURATION}).new_smtp_configuration(l_layout.application_config_path))

				create {DATABASE_CONNECTION_NULL} l_database.make_common
				create l_api_service.make (create {CMS_STORAGE_NULL})
				create Result.make (l_database, l_api_service, l_email_service, l_layout)
			end
		rescue
			set_last_error_from_exception ("Database Connection execution")
			log.write_critical (generator + ".roc_config Database Connection execution exceptions")
			l_retried := True
			retry
		end
end
