// Created as an example use of sv_registration_message

#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

ConVar g_cvContact;
ConVar g_cvRegMsg;

public Plugin myinfo = 
{
    name = "Sv_contact info in status",
    author = "Meten",
    description = "Shows the contects of sv_contact in the status command using sv_registration_message.",
    version = "1.0",
    url = "https://github.com/matthiasmeten/random-plugins"
}

public void OnPluginStart()
{
    HookConVarChange(g_cvContact, ContactChanged);
}
public void OnConfigsExecuted()
{
    g_cvContact = FindConVar("sv_contact");
    g_cvRegMsg = FindConVar("sv_registration_message");
    char buffer[256];
    char output[256];
    g_cvContact.GetString(buffer, 256);
    Format(buffer, 256, "No account specified)\n%s", output);
    g_cvRegMsg.SetString(output, true, false);
}

public void ContactChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    char output[256];
    Format(output, 256, "No account specified)\n%s", newValue);
    g_cvRegMsg.SetString(newValue, true, false);
}