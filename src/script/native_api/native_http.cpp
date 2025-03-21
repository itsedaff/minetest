#include "native_http.h"

HTTPFetchResult NativeHttpModApi::n_http_fetch_sync(HTTPFetchRequest& req)
{
	infostream << "Mod performs HTTP request with URL " << req.url << std::endl;
	HTTPFetchResult res;
	httpfetch_sync(req, res);
	return res;
}

std::string NativeHttpModApi::n_http_fetch_async(HTTPFetchRequest& req)
{
	httpfetch_async(req);
	// Convert handle to hex string since lua can't handle 64-bit integers
	std::stringstream handle_conversion_stream;
	handle_conversion_stream << std::hex << req.caller;
	std::string caller_handle(handle_conversion_stream.str());
	
	return caller_handle;
}

bool NativeHttpModApi::n_http_fetch_async_get(std::string &handle_str, HTTPFetchResult &res)
{
	bool success;

	// Convert hex string back to 64-bit handle
	u64 handle;
	std::stringstream handle_conversion_stream;
	handle_conversion_stream << std::hex << handle_str;
	handle_conversion_stream >> handle;
	//do fetch request
	success = httpfetch_async_get(handle, res);

	return success;
}

bool NativeHttpModApi::n_request_http_api(std::string& mod_name)
{
	std::string http_mods = g_settings->get("secure.http_mods");
	http_mods.erase(std::remove(http_mods.begin(), http_mods.end(), ' '),
			http_mods.end());
	std::vector<std::string> mod_list_http = str_split(http_mods, ',');

	std::string trusted_mods = g_settings->get("secure.trusted_mods");
	trusted_mods.erase(std::remove(trusted_mods.begin(), trusted_mods.end(), ' '),
			trusted_mods.end());
	std::vector<std::string> mod_list_trusted = str_split(trusted_mods, ',');

	mod_list_http.insert(mod_list_http.end(), mod_list_trusted.begin(), mod_list_trusted.end());
	
	bool containsMod = !(std::find(mod_list_http.begin(), mod_list_http.end(),
					     mod_name) == mod_list_http.end());
	return containsMod;
}