#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

// Fun mode: Allows the plugin for both opening and closing.
// Set RAVE to 1 and sm_doorcloser_time to 0.2 if you're a sick motherfu- I mean 404UNF.
#define RAVE 0

Handle g_hDoorTimer = null;
ConVar g_hCloseTimer = null;
int g_iDoorIndexes[1024]; // Who the hell would have more than 1024 doors in a map?
                          // Don't tell me you're gonna create a map now with more than that and set SECONDS to 0.5...
int g_iDoorsInMap;
#if RAVE == 1
    bool g_bClosed = true;
#endif

public Plugin myinfo = 
{
    name = "Periodical Door Closer",
    author = "Meten",
    description = "Real fake doors! Order now! (I had to make this joke)",
    version = "1.1.1",
    url = "https://github.com/matthiasmeten/random-plugins"
}

public void OnPluginStart()
{
    g_hCloseTimer = CreateConVar("sm_doorcloser_time", "300.0", "How often to close all doors in the map", _, true, 0.1, true, 3600.0);
    g_hDoorTimer = CreateTimer(g_hCloseTimer.FloatValue, CloseDoors, _, TIMER_REPEAT);
    g_hCloseTimer.AddChangeHook(OnConVarChanged);
    FindDoorsInMap();
}

void FindDoorsInMap()
{
    int latestdoor = -1;
    for(g_iDoorsInMap = 0; g_iDoorsInMap < 1024; g_iDoorsInMap++)
    {
        latestdoor = FindEntityByClassname(latestdoor, "prop_door_rotating");
        if (latestdoor == -1)
        {
            break;
        } else
        {
            g_iDoorIndexes[g_iDoorsInMap] = latestdoor;
        }
    }
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if (convar == g_hCloseTimer)
    {
        KillTimer(g_hDoorTimer, false);
        CreateTimer(StringToFloat(newValue), CloseDoors, _, TIMER_REPEAT); 
    }
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
            if (g_bClosed == true)
            {
                AcceptEntityInput(g_iDoorIndexes[i], "Open", -1, -1);
                //PrintToServer("Opening a door");
                g_bClosed = false;
            } else
            {
                AcceptEntityInput(g_iDoorIndexes[i], "Close", -1, -1);
                //PrintToServer("Closing a door");
                g_bClosed = true;
            }
        #endif
        }
    }
}
