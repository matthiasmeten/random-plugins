#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

// Replace this with how often you want the doors to close (in seconds)
// 300.0 would close it every 5 minutes.
// Set RAVE to 1 and sm_doorcloser_time to 0.2 if you're a sick motherfu- I mean 404UNF.
#define RAVE 0

Handle doortimer = null;
ConVar g_hCloseTimer = null;
int g_iDoorIndexes[1024];
// Who the hell would have more than 1024 doors in a map?
// Don't tell me you're gonna create a map now with more than that and set SECONDS to 0.5...
int g_iDoorsInMap;
#if RAVE == 1
    bool closed = true;
#endif

public Plugin myinfo = 
{
	name = "Periodical Door Closer",
	author = "Meten",
	description = "Real fake doors! Order now! (I had to make this joke)",
	version = "1.1",
	url = "https://github.com/matthiasmeten/random-plugins"
}

public void OnPluginStart()
{
    g_hCloseTimer = CreateConVar("sm_doorcloser_time", "300.0", "How often to close all doors in the map", _, true, 0.1, true, 3600.0);
    doortimer = CreateTimer(g_hCloseTimer.FloatValue, CloseDoors, _, TIMER_REPEAT);
    g_hCloseTimer.AddChangeHook(OnConVarChanged);
    FindDoorsInMap();
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if (convar == g_hCloseTimer)
    {
        KillTimer(doortimer, false);
        CreateTimer(StringToFloat(newValue), CloseDoors, _, TIMER_REPEAT); 
    }
}

void FindDoorsInMap()
{
    int latestdoor = -1;
    do // I know this can be done in a for loop, but this is more convenient for now.
    {
        latestdoor = FindEntityByClassname(latestdoor, "prop_door_rotating");
        if (latestdoor == -1)
        {
            break;
        }
        else
        {
            g_iDoorIndexes[g_iDoorsInMap] = latestdoor;
            g_iDoorsInMap++;
        }
    } while(true);
}

public Action CloseDoors(Handle timer)
{
	for(int i = 0; i < g_iDoorsInMap; i++)
    {
        if (g_iDoorIndexes[i] == 0)
        {
            break;
        } else
        {
        #if RAVE == 0
            AcceptEntityInput(g_iDoorIndexes[i], "Close", -1, -1);
        #endif
        #if RAVE == 1
            if (closed == true)
            {
                AcceptEntityInput(g_iDoorIndexes[i], "Open", -1, -1);
                //PrintToConsole("Opening a door");
                closed = false;
            } else
            {
                AcceptEntityInput(g_iDoorIndexes[i], "Close", -1, -1);
                //PrintToConsole("Closing a door");
                closed = true;
            }
        #endif
        }
    }
}
