#include "httpfetch.h"
#include "log.h"
#include "settings.h"
class NativeHttpModApi
{
public:
	static HTTPFetchResult n_http_fetch_sync(HTTPFetchRequest& req);
	static std::string n_http_fetch_async(HTTPFetchRequest& req);
	static bool n_http_fetch_async_get(std::string& handle_str, HTTPFetchResult& res);
	static bool n_request_http_api(std::string& mod_name);
};