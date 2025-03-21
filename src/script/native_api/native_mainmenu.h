#include "gui/guiEngine.h"
#include "gui/guiMainMenu.h"
#include "gui/guiKeyChangeMenu.h"
#include "gui/guiPathSelectMenu.h"
#include "content/subgames.h"
#include "content/content.h"
#include "client/renderingengine.h"
#include "porting.h"

#include "filesys.h"
#include <memory>
#include "mapgen/mapgen.h"
#include "client/renderingengine.h"
#include "debug.h"
#include <IFileSystem.h>
#include <IFileArchive.h>

class NativeModApiMainMenu
{
public:
	struct ScreenInfo
	{
		float density;
		u32 display_width;
		u32 display_height;
		u32 window_width;
		u32 window_height;

		ScreenInfo(float density, u32 displayX, u32 displayY, u32 windowX, u32 windowY)
		{
			this->density = density;
			display_width = displayX;
			display_height = displayY;
			window_width = windowX;
			window_height = windowY;
		}
	};
	static void n_update_formspec(GUIEngine *engine, const std::string &formspec);
	static void n_set_formspec_prepend(
			GUIEngine *engine, const std::string &formspec);
	static void n_start(GUIEngine *engine, const MainMenuData &newData);
	static void n_close(GUIEngine *engine);
	static bool n_set_background(GUIEngine *engine, const std::string backgroundlevel,
			const std::string texturename, const bool tile_image,
			const unsigned int minsize);
	static void n_set_clouds(GUIEngine *engine, const bool value);
	static s32 n_get_table_index(GUIEngine *engine, const std::string &tablename);
	static std::vector<WorldSpec> n_get_worlds();
	static std::vector<SubgameSpec> n_get_games();
	static ContentSpec n_get_content_info(const std::string &path);
	static void n_show_keys_menu(GUIEngine *engine);
	static std::unique_ptr<std::string> n_create_world(
			const std::string &name, const int &gameidx);
	static std::unique_ptr<std::string> n_delete_world(const int &worldId);
	static void n_set_topleft_text(GUIEngine *engine, const std::string &text);
	static void n_get_mapgen_names(
			std::vector<const char *> &names, const bool include_hidden);
	static std::string n_get_user_path();
	static std::string n_get_modpath();
	static std::string n_get_clientmodpath();
	static std::string n_get_gamepath();
	static std::string n_get_texturepath();
	static std::string n_get_texturepath_share();
	static std::string n_get_cache_path();
	static std::string n_get_temp_path();
	static bool n_create_dir(const std::string& path);
	static bool n_delete_dir(const std::string& path);
	static bool n_copy_dir(const std::string &source, const std::string &destination,
			const bool keep_source);
	static bool n_is_dir(const std::string &path);
	static bool n_extract_zip(
			const std::string &zipfile, const std::string &destination);
	static std::string n_get_mainmenu_path(GUIEngine *engine);
	static bool n_may_modify_path(const std::string& path);
	static void n_show_path_select_dialog(GUIEngine* engine, const std::string& formname, const std::string& title, const bool is_file_select);
	static bool n_download_file(const std::string &url, const std::string &target); 
	static std::vector<irr::video::E_DRIVER_TYPE> n_get_video_drivers();
	static std::vector<core::vector3d<u32>> n_get_video_modes();
	static std::string n_gettext(const char *raw_text);
	static ScreenInfo n_get_screen_info();
	static int n_get_min_supp_proto();
	static int n_get_max_supp_proto();
	static bool n_open_url(const std::string& url); 
	static bool n_open_dir(const std::string &path);
	static int n_do_async_callback(GUIEngine* engine, const char* func, const char* param,
		size_t func_length, size_t param_length);
	private:
	//helper functions
	static bool mayModifyPath(std::string path);
};