#include "common/c_converter.h"
#include "common/c_content.h"
#include "cpp_api/s_security.h"
#include "util/serialize.h"
#include "server.h"
#include "environment.h"
#include "emerge.h"
#include "mapgen/mg_biome.h"
#include "mapgen/mg_ore.h"
#include "mapgen/mg_decoration.h"
#include "mapgen/mg_schematic.h"
#include "mapgen/mapgen_v5.h"
#include "mapgen/mapgen_v7.h"
#include "filesys.h"
#include "settings.h"
#include "log.h"
#include <memory>
#include "mapnode.h"

class NativeModApiMapgen
{
public:
	struct BiomeData
	{
		u32 index;
		float heat;
		float humidity;
		BiomeData() {}
		BiomeData(u32 index, float heat, float humidity)
		{
			this->index = index;
			this->heat = heat;
			this->humidity = humidity;
		}
	};
	struct MapgenParams
	{
		std::string mg_name;
		std::string seed;
		std::string water_level;
		std::string chunk_size;
		std::string flags;
		MapgenParams(){}
	};
	
	struct NodeData
	{
		std::string *name;
		bool force_place;
		u8 probability;
		u8 param2;
	};

	struct SchematicFieldData
	{
		u32 numnodes;
		std::vector<std::string>* names;
		v3s16 *size;
		std::vector<std::pair<u16, u8>> yslice_probs;
		std::vector<NodeData> mapNode_params;
	};


	static struct EnumString NativeModApiMapgen::es_MapgenObject[];
	static u32 n_get_biome_id(const BiomeManager *bmgr, const char *biome_str);
	static std::string n_get_biome_name(const BiomeManager *bmgr, const int biome_id);
	static bool can_get_heat(
			MapSettingsManager *settingsmgr, const BiomeManager *bmgr);
	static float n_get_heat(MapSettingsManager *settingsmgr, const BiomeManager *bmgr,
			v3s16 pos);
	static bool can_get_humidity(
			MapSettingsManager *settingsmgr, const BiomeManager *bmgr);
	static float n_get_humidity(MapSettingsManager *settingsmgr,
			const BiomeManager *bmgr, v3s16 pos);
	static bool can_get_biome_data(MapSettingsManager *settingsmgr,
			const BiomeManager *bmgr, v3s16 pos);
	static BiomeData n_get_biome_data(MapSettingsManager *settingsmgr,
			const BiomeManager *bmgr, v3s16 pos);
	static enum MapgenObject n_get_mapgen_object(const char *mgobjstr);
	static int n_get_spawn_level(EmergeManager *emerge, s16 x, s16 z);
	static MapgenParams n_get_mapgen_params(MapSettingsManager *settingsmgr);
	static void n_set_mapgen_params(MapSettingsManager *settingsmgr, MapgenParams &m);
	static bool n_get_mapgen_setting(MapSettingsManager *settingsmgr, const char *name, std::string &setting);
	static bool n_get_mapgen_setting_noiseparams(MapSettingsManager *settingsmgr, const char *name, NoiseParams& np);
	static void n_set_mapgen_setting(MapSettingsManager *settingsmgr,
			const char *name, const char *value, const bool overridemeta);
	static void n_set_mapgen_setting_noiseparams(MapSettingsManager *settingsmgr,
			const char *name,const NoiseParams& np, const bool overridemeta);
	static void n_set_noiseparams(const char *name, const bool set_default, const NoiseParams &np);
	static bool n_get_noiseparams(const std::string& name, NoiseParams& np);
	static void n_set_gen_notify(EmergeManager *emerge, const bool change_notify, const u32 flags, const u32 flagmask, std::vector<u32> deco_ids);
	static std::vector<u32> n_get_gen_notify(const EmergeManager *emerge);
	static bool n_get_decoration_id(const char *deco_string, const DecorationManager *dmgr, int& deco_id);
	static bool n_register_biome(BiomeManager *bmgr, Biome *biome, ObjDefHandle& handle);
	static ObjDefHandle n_register_decoration(const NodeDefManager* ndef, DecorationManager* decomgr, Decoration *deco);
	static ObjDefHandle n_register_ore(const NodeDefManager *ndef, OreManager *oremgr, Ore* ore);
	static ObjDefHandle n_register_schematic(SchematicManager* schemmgr, Schematic* schem);
	static void n_clear_registered_biomes(BiomeManager *bmgr);
	static void n_clear_registered_decorations(DecorationManager *dmgr);
	static void n_clear_registered_ores(OreManager *omgr);
	static void n_clear_registered_schematics(SchematicManager *smgr);
	static void n_generate_ores(Mapgen& mg, OreManager* oremgr, const v3s16& pmin, const v3s16& pmax);
	static void n_generate_decorations(Mapgen& mg, DecorationManager* decomgr, const v3s16& pmin, const v3s16& pmax);
	static void n_create_schematic(const NodeDefManager* ndef, Schematic& schem, const std::string& filename);
	static void n_place_schematic(Schematic* s, ServerMap* m, const u32 flags, const v3s16 &p, const Rotation rot, const bool force_placement);
	static bool n_place_schematic_on_vmanip(MMVManip* v, Schematic* s, const v3s16 p, const u32 flags, const Rotation rot, const bool force_placement);
	static std::unique_ptr<std::string> n_serialize_schematic(const Schematic* s, const int fmt, const bool use_comments, const u32 indent_spaces);
	static SchematicFieldData n_read_schematic(Schematic *schem, std::string &write_yslice);
};