#include <sourcemod>
#include <sdktools>
#include <tf2>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "[TF2] Crits on stalemate for all",
	author = "Meten",
	description = "Takes away the stun and enables crits for everyone on a stalemate.",
	version = "1.0",
	url = "https://github.com/matthiasmeten/random-plugins"
}

public void OnPluginStart()
{
	HookEvent("teamplay_round_win", OnTFRoundWin, EventHookMode_PostNoCopy);
	HookEvent("teamplay_round_start", OnTFRoundStart, EventHookMode_PostNoCopy);
}

public void OnTFRoundWin(Event event, const char[] name, bool dontBroadcast)
{
	if (GetEventInt(event, "winreason") == 5)
	{
		// Debug
		//PrintToChatAll("stale crits");

		// Thanks, Timely/Shku
		GameRules_SetProp("m_iRoundState", RoundState_RoundRunning);
		for (int i = 1; i <= MaxClients; i++)
    	{
			if (IsClientInGame(i))
			{
				TF2_AddCondition(i, TFCond_CritOnWin, TFCondDuration_Infinite, 0);
			}
    	}
	}
}

public void OnTFRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	// Prevents a bizzare glitch from occuring when a team wins normally and fixes no announcer voice.
	GameRules_SetProp("m_iRoundState", RoundState_Preround);
}