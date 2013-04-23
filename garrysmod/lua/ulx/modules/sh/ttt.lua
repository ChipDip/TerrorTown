------------------ Trouble in Terrorist Town Commads ------------------
--                                                                   --                          
--                          By: Bender180                            -- 
--                   Originally for BendersVilla CATEGORY_NAME                 --
--                     http://www.bendersvilla.net                   --   
--                                                                   -- 
-----------------------------------------------------------------------

local CATEGORY_NAME = "TTT Admin"

-------------Respawn--------------------------------
function ulx.respawn( calling_ply, target_plys )

for _,v in pairs(target_plys) do
v:SetTeam( TEAM_TERROR )
v:Spawn()
end
ulx.fancyLogAdmin( calling_ply, "#A has respawned #T!", target_plys )
end
local strip = ulx.command( CATEGORY_NAME, "ulx respawn", ulx.respawn, "!respawn" )
strip:addParam{ type=ULib.cmds.PlayersArg }
strip:defaultAccess( ULib.ACCESS_SUPERADMIN )
strip:help( "Respawn the target(s)." )

------------------------------ Traitor ------------------------------
function ulx.cc_traitor( calling_ply, target_plys )

    for _, v in ipairs( target_plys ) do
       v:SetRole(ROLE_TRAITOR)
       v:AddCredits(GetConVarNumber("ttt_credits_starting"))
       v:AddCredits("1")
    end
    SendFullStateUpdate()
ulx.fancyLogAdmin( calling_ply, true, "#A has made #T a traitor", target_plys )

 end
 local traitor = ulx.command( CATEGORY_NAME, "ulx traitor", ulx.cc_traitor, "!traitor", true )
 traitor:addParam{type=ULib.cmds.PlayersArg, hint = "<user(s)>"}
 traitor:defaultAccess( ULib.ACCESS_SUPERADMIN )
 traitor:help( "Turns target(s) into a traitor." )

------------------------------ Detective ------------------------------
function ulx.cc_detective( calling_ply, target_plys )

    for _, v in ipairs( target_plys ) do
       v:SetRole(ROLE_DETECTIVE)
       v:Give("weapon_ttt_wtester")
       v:AddCredits("1")
    end
    SendFullStateUpdate()
ulx.fancyLogAdmin( calling_ply, true, "#A has made #T a detective", target_plys )
 end
 local traitor = ulx.command( CATEGORY_NAME, "ulx detective", ulx.cc_detective, "!detective", true )
 traitor:addParam{type=ULib.cmds.PlayersArg, hint = "<user(s)>"}
 traitor:defaultAccess( ULib.ACCESS_SUPERADMIN )
 traitor:help( "Turns target(s) into a detective." )

------------------------------ Innocenct ------------------------------
function ulx.cc_innocent( calling_ply, target_plys )

    for _, v in ipairs( target_plys ) do
       v:SetRole(ROLE_INNOCENT)
    end
    SendFullStateUpdate()
ulx.fancyLogAdmin( calling_ply, true, "#A has made #T a innocent", target_plys )
 end
 local traitor = ulx.command( CATEGORY_NAME, "ulx innocent", ulx.cc_innocent, "!innocent", true )
 traitor:addParam{type=ULib.cmds.PlayersArg, hint = "<user(s)>"}
 traitor:defaultAccess( ULib.ACCESS_SUPERADMIN )
 traitor:help( "Turns target(s) into a innocent." )
 
 ------------------------------ Spectator ------------------------------
function ulx.afk( calling_ply, target_plys, should_unafk )

    local affected_plys = {}
    
    for i=1, #target_plys do
		local v = target_plys[ i ]
            if not should_unafk then
                v:ConCommand("ttt_spectator_mode 1")
                v:ConCommand("ttt_cl_idlepopup")
            else
                v:ConCommand("ttt_spectator_mode 0")
            end
    end
    
    if not should_unafk then
        ulx.fancyLogAdmin( calling_ply, "#A has forced #T into spectator mode", target_plys )
    else
        ulx.fancyLogAdmin( calling_ply, "#A has forced #T back to player.", target_plys )
    end
end

local fspec = ulx.command( CATEGORY_NAME, "ulx afk", ulx.afk, "!afk" )
fspec:addParam{ type=ULib.cmds.PlayersArg }
fspec:addParam{ type=ULib.cmds.BoolArg, invisible=true }
fspec:defaultAccess( ULib.ACCESS_SUPERADMIN )
fspec:help( "Forces the target(s) to/from spectator." )
fspec:setOpposite( "ulx unafk", {_, _, true}, "!unafk" )

--for _,v in pairs(target_plys) do

  --  v:ConCommand("ttt_spectator_mode 1")
    --v:ConCommand("ttt_cl_idlepopup")
    
--end
--ulx.fancyLogAdmin( calling_ply, "#A has forced #T into spectator mode", target_plys )
--end

 ------------------------------ Karma ------------------------------
function ulx.karma( calling_ply, target_plys, amount )
    
    for i=1, #target_plys do
		target_plys[ i ]:SetBaseKarma(amount)
        target_plys[ i ]:SetLiveKarma( amount )
    end
    
ulx.fancyLogAdmin( calling_ply, "#A set the karma for #T to #i", target_plys, amount )
end
local karma = ulx.command( CATEGORY_NAME, "ulx karma", ulx.karma, "!karma" )
karma:addParam{ type=ULib.cmds.PlayersArg }
karma:addParam{ type=ULib.cmds.NumArg, min=0, max = 10000, default=1000, hint="Karma", ULib.cmds.round }
karma:defaultAccess( ULib.ACCESS_SUPERADMIN )
karma:help( "Changes the target(s) Karma." )

 ------------------------------ Credits ------------------------------
function ulx.credits( calling_ply, target_plys, amount )
    
    for i=1, #target_plys do
        target_plys[ i ]:AddCredits(amount)
    end
    
ulx.fancyLogAdmin( calling_ply, true, "#A has given #T #i credits", target_plys, amount )
end
local acred = ulx.command("TTT Fun", "ulx credits", ulx.credits, "!credits")
acred:addParam{ type=ULib.cmds.PlayersArg }
acred:addParam{ type=ULib.cmds.NumArg, hint="Credits", ULib.cmds.round }
acred:defaultAccess( ULib.ACCESS_SUPERADMIN )
acred:help( "Gives the target(s) credits." )


------------------------------ Community ------------------------------
--                                                                   -- 
--                          From Here Down                           -- 
--                All item are community contrubutions               --
--                                                                   --   
--Next Round Slay: ozymandias (Modified by bender180 to use Opposite)-- 
--                    Give Body Armor: centran                       -- 
--                                                                   -- 
-----------------------------------------------------------------------

------------------------------ Next Round Slay ------------------------------
local PlysMarkedForDeath = {}
function ulx.nrslay( calling_ply, target_plys, should_noslay )

	local affected_plys = {}
	local unaffected_plys = {}

	for i=1, #target_plys do
		local v = target_plys[ i ]
		local ID = v:UniqueID()
        
        -- reversed original code to add an Opposite
        if not should_noslay then
            PlysMarkedForDeath[ID] = true
            table.insert( affected_plys, v )
        else
            PlysMarkedForDeath[ID] = false
            table.insert( affected_plys, v )
		end
	end
    
    if not should_noslay then
        ulx.fancyLogAdmin( calling_ply, "#A marked #T to be slain next round.", affected_plys )
    else
        ulx.fancyLogAdmin( calling_ply, "#A unmarked #T to be slain next round.", affected_plys )
    end
	

end
local nrslay= ulx.command( CATEGORY_NAME, "ulx nrslay", ulx.nrslay, "!nrslay" )
nrslay:addParam{ type=ULib.cmds.PlayersArg }
nrslay:addParam{ type=ULib.cmds.BoolArg, invisible=true }
nrslay:defaultAccess( ULib.ACCESS_SUPERADMIN )
nrslay:help( "Forces the target to be slain the following round." )
nrslay:setOpposite( "ulx noslay", {_, _, true}, "!noslay" )

local function SlayMarkedPlayers()
	for k, v in pairs(PlysMarkedForDeath) do
		if v then
			ply = player.GetByUniqueID(k)
			ply:Kill()
			ply:ChatPrint("You have been forced to sit out by an admin this round.")
			PlysMarkedForDeath[k] = false
		end
	end
end

hook.Add("TTTBeginRound", "Admin_Round_Slay", SlayMarkedPlayers)

------------------------------ Body Armor ----------------------------
function ulx.bodyarmor( calling_ply, target_plys )
        for i=1, #target_plys do
                target_plys[ i ]:GiveEquipmentItem(EQUIP_ARMOR)
        end
        ulx.fancyLogAdmin( calling_ply, "#A gave #T body armor", target_plys)
end
local armor = ulx.command( "TTT Fun", "ulx bodyarmor", ulx.bodyarmor, "!bodyarmor" )
armor:addParam{ type=ULib.cmds.PlayersArg }
armor:defaultAccess( ULib.ACCESS_ADMIN )
armor:help( "<user(s)> - Give target(s) body armor." )