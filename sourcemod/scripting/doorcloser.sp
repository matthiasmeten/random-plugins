#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

// Replace this with how often you want the doors to close (in seconds)
// 300.0 would close it every 5 minutes.
// Set to 0.3 and set RAVE to 1 if you're a sick motherfu- I mean 404UNF.
#define MY_TIME 300.0
#define RAVE 0

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
	version = "1.0",
	url = "https://github.com/matthiasmeten/random-plugins"
}

public void OnPluginStart()
{
    CreateTimer(MY_TIME, CloseDoors, _, TIMER_REPEAT);
    FindDoorsInMap();
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
