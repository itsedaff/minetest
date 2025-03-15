#include "native_base.h"
#include "../server/player_sao.h"
#include <memory>

class NativeObjectRef : public NativeModApiBase
{
	struct punchData
	{
		u16 wear;
	};

public:
	static void n_remove(ServerActiveObject *sao);
	static std::unique_ptr<v3f> n_get_pos(const ServerActiveObject *sao);
	static void n_set_pos(ServerActiveObject *sao, const v3f &pos);
	static void n_move_to(
			ServerActiveObject *sao, const v3f &pos, const bool continuous);
	static std::unique_ptr<u16> n_punch(Server* server, ServerActiveObject *puncher,
			ServerActiveObject *punchee, const ToolCapabilities &tc,
			const v3f &dir, const float time_from_last_punch);
	static void n_right_click(
			ServerActiveObject *clicker, ServerActiveObject *clickee);
	static void n_set_hp(Server* server, ServerActiveObject *sao, const int hp);
	static int n_get_hp(ServerActiveObject *sao);
	static InventoryLocation n_get_inventory(ServerActiveObject *sao);
	static std::unique_ptr<std::string> n_get_wield_list(
			const ServerActiveObject *sao);
	static int n_get_wield_index(const ServerActiveObject *sao);
	static bool n_set_wielded_item(Server* server, ServerActiveObject *sao, ItemStack &item);
	static bool n_set_armor_groups(ServerActiveObject *sao, ItemGroupList &groups);
	static std::unique_ptr<ItemGroupList> n_get_armor_groups(
			const ServerActiveObject *sao);
	static void n_set_animation(ServerActiveObject *sao, const v2f frame_range,
			const float frame_speed, const float frame_blend,
			const bool frame_loop);
	static int n_get_animation(ServerActiveObject *sao, v2f &frames,
			float &frame_speed, float &frame_blend, bool &frame_loop);
	static bool n_set_local_animation(Server *server, RemotePlayer *player,
			 v2s32 frames[], const bool frame_speed);
	static int n_get_local_animation(RemotePlayer *player, v2s32 *frames[], float *frame_speed);
};