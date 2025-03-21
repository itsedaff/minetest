#include "native_mainmenu.h"

void NativeModApiMainMenu::n_update_formspec(GUIEngine* engine, const std::string& formspec)
{
	sanity_check(engine != NULL);
	if (engine->m_formspecgui != 0) {
		engine->m_formspecgui->setForm(formspec);
	}
}

void NativeModApiMainMenu::n_set_formspec_prepend(GUIEngine* engine, const std::string& formspec)
{
	sanity_check(engine != NULL);
	engine->setFormspecPrepend(formspec);
}

void NativeModApiMainMenu::n_start(GUIEngine* engine, const MainMenuData& newData)
{
	sanity_check(engine != NULL);
	MainMenuData *currData = engine->m_data;
	currData->selected_world = newData.selected_world;
	currData->simple_singleplayer_mode = newData.simple_singleplayer_mode;
	currData->do_reconnect = newData.do_reconnect;
	if (!currData->do_reconnect) {
		currData->name = newData.name;
		currData->password = newData.password;
		currData->address = newData.address;
		currData->port = newData.port;
	}
	currData->serverdescription = newData.serverdescription;
	currData->servername = newData.servername;

	//close menu next time
	engine->m_startgame = true;
}

void NativeModApiMainMenu::n_close(GUIEngine* engine)
{
	sanity_check(engine != NULL);
	engine->m_kill = true;
}

bool NativeModApiMainMenu::n_set_background(GUIEngine *engine, const std::string backgroundlevel, const std::string texturename, const bool tile_image, const unsigned int minsize)
{
	sanity_check(engine != NULL);
	bool retval = false;
	if (backgroundlevel == "background") {
		retval |= engine->setTexture(
				TEX_LAYER_BACKGROUND, texturename, tile_image, minsize);
	}

	if (backgroundlevel == "overlay") {
		retval |= engine->setTexture(
				TEX_LAYER_OVERLAY, texturename, tile_image, minsize);
	}

	if (backgroundlevel == "header") {
		retval |= engine->setTexture(
				TEX_LAYER_HEADER, texturename, tile_image, minsize);
	}

	if (backgroundlevel == "footer") {
		retval |= engine->setTexture(
				TEX_LAYER_FOOTER, texturename, tile_image, minsize);
	}
	return retval;
}

void NativeModApiMainMenu::n_set_clouds(GUIEngine* engine, const bool value)
{
	sanity_check(engine != NULL);
	engine->m_clouds_enabled = value;
}

s32 NativeModApiMainMenu::n_get_table_index(GUIEngine* engine, const std::string& tablename)
{
	sanity_check(engine != NULL);
	GUITable *table = engine->m_menu->getTable(tablename);
	s32 selection = table ? table->getSelected() : 0;
	return selection;
}

std::vector<WorldSpec> NativeModApiMainMenu::n_get_worlds()
{
	return getAvailableWorlds();
}

std::vector<SubgameSpec> NativeModApiMainMenu::n_get_games()
{
	return getAvailableGames();
}

ContentSpec NativeModApiMainMenu::n_get_content_info(const std::string& path)
{
	ContentSpec spec;
	spec.path = path;
	parseContentInfo(spec);
	return spec;
}

void NativeModApiMainMenu::n_show_keys_menu(GUIEngine* engine)
{
	sanity_check(engine != NULL);
	GUIKeyChangeMenu *kmenu = new GUIKeyChangeMenu(RenderingEngine::get_gui_env(),
			engine->m_parent, -1, engine->m_menumanager,
			engine->m_texture_source);
	kmenu->drop();
}

std::unique_ptr<std::string> NativeModApiMainMenu::n_create_world(const std::string& name, const int& gameidx)
{
	std::string path = porting::path_user + DIR_DELIM "worlds" + DIR_DELIM +
			   sanitizeDirName(name, "world_");

	std::vector<SubgameSpec> games = getAvailableGames();

	std::unique_ptr<std::string> status;
	if ((gameidx >= 0) && (gameidx < (int)games.size())) {

		// Create world if it doesn't exist
		try {
			loadGameConfAndInitWorld(path, name, games[gameidx], true);
			return status;
		} catch (const BaseException &e) {
			std::string exception = std::string(e.what());
			status = std::make_unique<std::string>("Failed to initialize world: " + exception);
			return status;
		}
	} else {
		status = std::make_unique<std::string>("Invalid game index");
	}
	return status;
}

std::unique_ptr<std::string> NativeModApiMainMenu::n_delete_world(const int& world_id)
{
	std::unique_ptr<std::string> status;
	std::vector<WorldSpec> worlds = getAvailableWorlds();
	if (world_id < 0 || world_id >= (int)worlds.size()) {
		status = std::make_unique<std::string>("Invalid world index");
		return status;
	}
	const WorldSpec &spec = worlds[world_id];
	if (!fs::RecursiveDelete(spec.path)) {
		
		status = std::make_unique<std::string>("Failed to delete world");
		return status;
	}
	else
	{
		return status;
	}

}

void NativeModApiMainMenu::n_set_topleft_text(GUIEngine* engine, const std::string& text)
{
	sanity_check(engine != NULL);
	engine->setTopleftText(text);
}

void NativeModApiMainMenu::n_get_mapgen_names(
		std::vector<const char *> &names, bool include_hidden)
{
	Mapgen::getMapgenNames(&names, include_hidden);
}

std::string NativeModApiMainMenu::n_get_user_path()
{
	return fs::RemoveRelativePathComponents(porting::path_user);
}

std::string NativeModApiMainMenu::n_get_modpath()
{
	return fs::RemoveRelativePathComponents(porting::path_user + DIR_DELIM + "mods" + DIR_DELIM);
}

std::string NativeModApiMainMenu::n_get_clientmodpath()
{
	return fs::RemoveRelativePathComponents(
			porting::path_user + DIR_DELIM + "clientmods" + DIR_DELIM);
}

std::string NativeModApiMainMenu::n_get_gamepath()
{
	return fs::RemoveRelativePathComponents(
			porting::path_user + DIR_DELIM + "games" + DIR_DELIM);
}

std::string NativeModApiMainMenu::n_get_texturepath()
{
	return fs::RemoveRelativePathComponents(
			porting::path_user + DIR_DELIM + "textures");
}

std::string NativeModApiMainMenu::n_get_texturepath_share()
{
	return fs::RemoveRelativePathComponents(
			porting::path_share + DIR_DELIM + "textures");
}

std::string NativeModApiMainMenu::n_get_cache_path()
{
	return fs::RemoveRelativePathComponents(porting::path_cache);
}

std::string NativeModApiMainMenu::n_get_temp_path()
{
	return fs::TempPath();
}

bool NativeModApiMainMenu::n_create_dir(const std::string &path)
{
	if (mayModifyPath(path)) {
		return fs::CreateAllDirs(path);
	}
	return false;
}

bool NativeModApiMainMenu::mayModifyPath(std::string path)
{
	path = fs::RemoveRelativePathComponents(path);

	if (fs::PathStartsWith(path, fs::TempPath()))
		return true;

	std::string path_user = fs::RemoveRelativePathComponents(porting::path_user);

	if (fs::PathStartsWith(path, path_user + DIR_DELIM "client"))
		return true;
	if (fs::PathStartsWith(path, path_user + DIR_DELIM "games"))
		return true;
	if (fs::PathStartsWith(path, path_user + DIR_DELIM "mods"))
		return true;
	if (fs::PathStartsWith(path, path_user + DIR_DELIM "textures"))
		return true;
	if (fs::PathStartsWith(path, path_user + DIR_DELIM "worlds"))
		return true;

	if (fs::PathStartsWith(
			    path, fs::RemoveRelativePathComponents(porting::path_cache)))
		return true;

	return false;
}

bool NativeModApiMainMenu::n_delete_dir(const std::string& path)
{
	std::string absolute_path = fs::RemoveRelativePathComponents(path);
	if (mayModifyPath(absolute_path)) {
		return fs::RecursiveDelete(absolute_path);
	}
	return false;
}

bool NativeModApiMainMenu::n_copy_dir(const std::string& source, const std::string& destination, const bool keep_source)
{
	std::string absolute_destination = fs::RemoveRelativePathComponents(destination);
	std::string absolute_source = fs::RemoveRelativePathComponents(source);

	if ((mayModifyPath(absolute_destination))) {
		bool retval = fs::CopyDir(absolute_source, absolute_destination);

		if (retval && (!keep_source)) {

			retval &= fs::RecursiveDelete(absolute_source);
		}
		return retval;
	}
	return false;
}

bool NativeModApiMainMenu::n_is_dir(const std::string &path)
{
	return fs::IsDir(path);
}

bool NativeModApiMainMenu::n_extract_zip(const std::string& zipfile,const std::string& destination)
{
	//will return false if path is not modifiable or operation fails at any point. Only returns true if ENTIRE OPERATION succeeds
	std::string absolute_destination = fs::RemoveRelativePathComponents(destination);
	if (mayModifyPath(absolute_destination)) {
		fs::CreateAllDirs(absolute_destination);

		io::IFileSystem *fs = RenderingEngine::get_filesystem();

		if (!fs->addFileArchive(zipfile.c_str(), false, false, io::EFAT_ZIP)) {
			return false;
		}

		sanity_check(fs->getFileArchiveCount() > 0);

		/**********************************************************************/
		/* WARNING this is not threadsafe!!                                   */
		/**********************************************************************/
		io::IFileArchive *opened_zip =
				fs->getFileArchive(fs->getFileArchiveCount() - 1);

		const io::IFileList *files_in_zip = opened_zip->getFileList();

		unsigned int number_of_files = files_in_zip->getFileCount();

		for (unsigned int i = 0; i < number_of_files; i++) {
			std::string fullpath = destination;
			fullpath += DIR_DELIM;
			fullpath += files_in_zip->getFullFileName(i).c_str();
			std::string fullpath_dir = fs::RemoveLastPathComponent(fullpath);

			if (!files_in_zip->isDirectory(i)) {
				if (!fs::PathExists(fullpath_dir) &&
						!fs::CreateAllDirs(fullpath_dir)) {
					fs->removeFileArchive(
							fs->getFileArchiveCount() - 1);
					return false;
				}

				io::IReadFile *toread = opened_zip->createAndOpenFile(i);

				FILE *targetfile = fopen(fullpath.c_str(), "wb");

				if (targetfile == NULL) {
					fs->removeFileArchive(
							fs->getFileArchiveCount() - 1);
					return false;
				}

				char read_buffer[1024];
				long total_read = 0;

				while (total_read < toread->getSize()) {

					unsigned int bytes_read = toread->read(
							read_buffer, sizeof(read_buffer));
					if ((bytes_read == 0) ||
							(fwrite(read_buffer, 1,
									 bytes_read,
									 targetfile) !=
									bytes_read)) {
						fclose(targetfile);
						fs->removeFileArchive(
								fs->getFileArchiveCount() -
								1);
						return false;
					}
					total_read += bytes_read;
				}

				fclose(targetfile);
			}
		}

		fs->removeFileArchive(fs->getFileArchiveCount() - 1);
		return true;
	}
	return false;

}

std::string NativeModApiMainMenu::n_get_mainmenu_path(GUIEngine* engine)
{
	sanity_check(engine != NULL);
	return engine->getScriptDir();
}

bool NativeModApiMainMenu::n_may_modify_path(const std::string& path)
{
	std::string absolute_destination = fs::RemoveRelativePathComponents(path);
	return mayModifyPath(absolute_destination);
}

void NativeModApiMainMenu::n_show_path_select_dialog(GUIEngine *engine,
		const std::string &formname, const std::string &title,
		const bool is_file_select)
{
	GUIFileSelectMenu *fileOpenMenu = new GUIFileSelectMenu(
			RenderingEngine::get_gui_env(), engine->m_parent, -1,
			engine->m_menumanager, title, formname, is_file_select);
	fileOpenMenu->setTextDest(engine->m_buttonhandler);
	fileOpenMenu->drop();
}

bool NativeModApiMainMenu::n_download_file(
		const std::string &url, const std::string &target)
{
	std::string absolute_destination = fs::RemoveRelativePathComponents(target);
	if (mayModifyPath(absolute_destination)) {
		if (GUIEngine::downloadFile(url, absolute_destination)) {
			return true;
		}
	} else {
		errorstream << "DOWNLOAD denied: " << absolute_destination
			    << " isn't a allowed path" << std::endl;
	}
	return false;
}

std::vector<irr::video::E_DRIVER_TYPE> NativeModApiMainMenu::n_get_video_drivers()
{
	return RenderingEngine::getSupportedVideoDrivers();
}

std::vector<core::vector3d<u32>> NativeModApiMainMenu::n_get_video_modes()
{
	return RenderingEngine::getSupportedVideoModes();
}

std::string NativeModApiMainMenu::n_gettext(const char* raw_text)
{
	std::string text = strgettext(std::string(raw_text));
	return text;
}

NativeModApiMainMenu::ScreenInfo NativeModApiMainMenu::n_get_screen_info()
{
	const v2u32 window_size = RenderingEngine::get_instance()->getWindowSize();
	const ScreenInfo s = ScreenInfo(RenderingEngine::getDisplayDensity(),
			RenderingEngine::getDisplaySize().X,
			RenderingEngine::getDisplaySize().Y, window_size.X,
			window_size.Y);
	return s;
}

int NativeModApiMainMenu::n_get_min_supp_proto()
{
	return CLIENT_PROTOCOL_VERSION_MIN;
}

int NativeModApiMainMenu::n_get_max_supp_proto()
{
	return CLIENT_PROTOCOL_VERSION_MAX;
}

bool NativeModApiMainMenu::n_open_dir(const std::string& path)
{
	return porting::open_directory(path);
}

bool NativeModApiMainMenu::n_open_url(const std::string& url)
{
	return porting::open_url(std::string(url));
}

int NativeModApiMainMenu::n_do_async_callback(GUIEngine *engine, const char *func,
		const char *param, size_t func_length, size_t param_length)
{
	sanity_check(func != NULL);
	sanity_check(param != NULL);

	std::string serialized_func = std::string(func, func_length);
	std::string serialized_param = std::string(param, param_length);

	return engine->queueAsync(serialized_func, serialized_param);
}