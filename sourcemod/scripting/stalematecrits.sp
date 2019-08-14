#include <sourcemod>
#include <tf2>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "[TF2] Crits on stalemate for all",
	author = "Meten",
	description = "Enables crits for all and takes away the stunned cond during a round stalemate.",
	version = "0.1",
	url = "https://github.com/matthiasmeten/random-plugins"
}

public void OnPluginStart()
{
    HookEvent("teamplay_round_win", OnTFRoundStalemate, EventHookMode_Post);
}

public void OnTFRoundStalemate(Event event, const char[] name, bool dontBroadcast)
{
    for (int i = 1; i <= MaxClients; i++)
    {
		if (IsClientInGame(i))
		{
			SetEntProp(i, Prop_Send, "m_iStunFlags", 0);
		}
    }
}