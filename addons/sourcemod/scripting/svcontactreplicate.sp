#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

ConVar g_cvContact = null;

public Plugin myinfo = 
{
    name = "Sv_contact visibility for clients",
    author = "Meten",
    description = "Allows clients to see the server value of sv_contact.",
    version = "1.0",
    url = "https://github.com/matthiasmeten/random-plugins"
}

public void OnConfigsExecuted()
{
    g_cvContact = FindConVar("sv_contact");
    g_cvContact.Flags = FCVAR_REPLICATED|FCVAR_NOTIFY;
    char contact[64];
    g_cvContact.GetString(contact, 64);
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i))
        {
            g_cvContact.ReplicateToClient(i, contact);
        }
    }
}