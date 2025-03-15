#include "native_object.h"

void NativeObjectRef::n_remove(ServerActiveObject *sao)
{
	if (sao == nullptr || sao->getType() == ACTIVEOBJECT_TYPE_PLAYER)
		return;
	else
	{
		sao->clearChildAttachments();
		sao->clearParentAttachment();

		verbosestream << "ObjectRef::l_remove(): id=" << sao->getId()
			      << std::endl;
		sao->markForRemoval();
	}
}

std::unique_ptr<v3f> NativeObjectRef::n_get_pos(const ServerActiveObject *sao)
{
	std::unique_ptr<v3f> pos;
	if (sao != nullptr)
		pos = std::make_unique<v3f>(sao->getBasePosition());
	
	return pos;
}

void NativeObjectRef::n_set_pos(ServerActiveObject* sao, const v3f& pos)
{
	if (sao != nullptr)
		sao->setPos(pos);
}

void NativeObjectRef::n_move_to(ServerActiveObject* sao, const v3f& pos, const bool continuous)
{
	if (sao != nullptr)
		sao->moveTo(pos, continuous);
}

//will theoretically return nullptr if either puncher or punchee doesn't exist.
std::unique_ptr<u16> NativeObjectRef::n_punch(Server *server, ServerActiveObject *puncher,
		ServerActiveObject *punchee, const ToolCapabilities &tc, const v3f &dir,
		const float time_from_last_punch)
{
	std::unique_ptr<u16> wear;
	if (puncher != nullptr && punchee != nullptr)
	{
		u16 puncher_og_hp = puncher->getHP();
		u16 punchee_og_hp = punchee->getHP();
		wear = std::make_unique<u16>(punchee->punch(dir, &tc, puncher, time_from_last_punch));

		if (puncher_og_hp != punchee->getHP() &&
				punchee->getType() == ACTIVEOBJECT_TYPE_PLAYER) {
			server->SendPlayerHPOrDie((PlayerSAO *)punchee,
					PlayerHPChangeReason(PlayerHPChangeReason::
									     PLAYER_PUNCH,
							puncher));
		}

		if (punchee_og_hp != puncher->getHP() &&
				puncher->getType() == ACTIVEOBJECT_TYPE_PLAYER) {
			server->SendPlayerHPOrDie((PlayerSAO *)puncher,
					PlayerHPChangeReason(PlayerHPChangeReason::
									     PLAYER_PUNCH,
							punchee));
		}
	}
	return wear;
}
void NativeObjectRef::n_right_click(ServerActiveObject* clicker, ServerActiveObject* clickee)
{
	if (clicker != nullptr && clickee != nullptr)
		clicker->rightClick(clickee);
}

void NativeObjectRef::n_set_hp(Server *server, ServerActiveObject *sao, const int hp)
{
	PlayerHPChangeReason reason(PlayerHPChangeReason::SET_HP);
	sao->setHP(hp, reason);

	if (sao->getType() == ACTIVEOBJECT_TYPE_PLAYER)
		server->SendPlayerHPOrDie((PlayerSAO *)sao, reason);
}

int NativeObjectRef::n_get_hp(ServerActiveObject *sao)
{
	if (sao != nullptr)
		return sao->getHP();
	return 1;
}

InventoryLocation NativeObjectRef::n_get_inventory(ServerActiveObject *sao)
{
	return sao->getInventoryLocation();
}

std::unique_ptr<std::string> n_get_wield_list(const ServerActiveObject* sao)
{
	std::unique_ptr<std::string> wield_list;
	if (sao != nullptr)
		wield_list = std::make_unique<std::string>(sao->getWieldList());
	return wield_list;
}

int NativeObjectRef::n_get_wield_index(const ServerActiveObject *sao)
{
	if (sao != nullptr)
		return sao->getWieldIndex();
	return -1;
}

bool NativeObjectRef::n_set_wielded_item(Server* server,ServerActiveObject *sao, ItemStack &item)
{
	bool success = sao->setWieldedItem(item);
	if (success && sao->getType() == ACTIVEOBJECT_TYPE_PLAYER) {
		server->SendInventory((PlayerSAO *)sao, true);
	}
	return success;
}

bool NativeObjectRef::n_set_armor_groups(ServerActiveObject *sao, ItemGroupList &groups)
{
	if (sao->getType() == ACTIVEOBJECT_TYPE_PLAYER) {
		if (!g_settings->getBool("enable_damage") &&
				!itemgroup_get(groups, "immortal")) {
			warningstream << "Mod tried to enable damage for a player, but "
					 "it's "
					 "disabled globally. Ignoring."
				      << std::endl;
			groups["immortal"] = 1;
		}
	}
	sao->setArmorGroups(groups);
}

std::unique_ptr<ItemGroupList> NativeObjectRef::n_get_armor_groups(const ServerActiveObject *sao)
{
	std::unique_ptr<ItemGroupList> armor_groups;
	if (sao != nullptr)
		armor_groups = std::make_unique<ItemGroupList>(sao->getArmorGroups());
	return armor_groups;
}

void NativeObjectRef::n_set_animation(ServerActiveObject* sao, const v2f frame_range,
	const float frame_speed, const float frame_blend, const bool frame_loop)
{
	if (sao != nullptr)
	{
		sao->setAnimation(frame_range, frame_speed, frame_blend, frame_loop);
	}
}

int NativeObjectRef::n_get_animation(ServerActiveObject *sao, v2f &frames, float &frame_speed, float &frame_blend, bool &frame_loop)
{
	if (sao == nullptr)
		return 0;
	else
	{
		sao->getAnimation(&frames, &frame_speed, &frame_blend, &frame_loop);
		return 4;
	}
}

bool NativeObjectRef::n_set_local_animation(Server* server, RemotePlayer* player, v2s32 frames[], const bool frame_speed)
{
	if (!player)
		return false;
	else
	{
		server->setLocalPlayerAnimations(player, frames, frame_speed);
		return true;
	}
}

int NativeObjectRef::n_get_local_animation(RemotePlayer* player, v2s32* frames[], float* frame_speed)
{
	if (!player)
		return 0;
	else
	{
		player->getLocalAnimations(frames, frame_speed);
		return 5;
	}
}