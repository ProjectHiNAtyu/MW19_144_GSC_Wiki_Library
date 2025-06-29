// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

main()
{
    if ( getdvar( "mapname" ) == "mp_background" )
        return;

    scripts\mp\globallogic::init();
    scripts\mp\globallogic::setupcallbacks();
    level.give_weapon_alt_clip_ammo_hack = [];
    var_0 = getentarray( "cyber_emp_pickup_trig", "targetname" );

    foreach ( var_2 in var_0 )
        level.give_weapon_alt_clip_ammo_hack[level.give_weapon_alt_clip_ammo_hack.size] = var_2.origin;

    level.give_super_ammo_after_loadout_given = ( 0, 0, 0 );
    var_4 = getentarray( "flag_primary", "targetname" );

    foreach ( var_6 in var_4 )
    {
        if ( var_6.script_label == "_b" )
        {
            level.give_super_ammo_after_loadout_given = var_6.origin;
            break;
        }
    }

    var_8[0] = scripts\mp\utility\game::getgametype();
    var_8[1] = "tdm";
    scripts\mp\gameobjects::main( var_8 );

    if ( isusingmatchrulesdata() )
    {
        level.initializematchrules = ::initializematchrules;
        [[ level.initializematchrules ]]();
        level thread scripts\mp\utility\game::reinitializematchrulesonmigration();
    }
    else
    {
        scripts\mp\utility\game::registerroundswitchdvar( scripts\mp\utility\game::getgametype(), 0, 0, 9 );
        scripts\mp\utility\game::registertimelimitdvar( scripts\mp\utility\game::getgametype(), 10 );
        scripts\mp\utility\game::registerscorelimitdvar( scripts\mp\utility\game::getgametype(), 7500 );
        scripts\mp\utility\game::registerroundlimitdvar( scripts\mp\utility\game::getgametype(), 1 );
        scripts\mp\utility\game::registerwinlimitdvar( scripts\mp\utility\game::getgametype(), 1 );
        scripts\mp\utility\game::registernumlivesdvar( scripts\mp\utility\game::getgametype(), 0 );
        scripts\mp\utility\game::registerhalftimedvar( scripts\mp\utility\game::getgametype(), 0 );
        setdynamicdvar( "scr_tdef_possessionResetCondition", 1 );
        setdynamicdvar( "scr_tdef_possessionResetTime", 60 );
        level.matchrules_enemyflagradar = 1;
        level.matchrules_damagemultiplier = 0;
        level.matchrules_vampirism = 0;
    }

    level.carrierarmor = 100;
    updategametypedvars();
    level.teambased = 1;
    level.onstartgametype = ::onstartgametype;
    level.onplayerconnect = ::onplayerconnect;
    level.getspawnpoint = ::getspawnpoint;
    level.onplayerkilled = ::onplayerkilled;
    level.onrespawndelay = ::getrespawndelay;
    level.giveachievementwildfire = 1;
    level.giveachievementpilotkill = [];
    level.scorefrozenuntil = 0;
    level.giveachievementsmoke = 0;
    game["dialog"]["gametype"] = "gametype_defender";

    if ( getdvarint( "OSMSLRTOP" ) )
        game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];

    game["strings"]["overtime_hint"] = &"MP/FIRST_BLOOD";
    game["bomb_dropped_sound"] = "mp_war_objective_lost";
    game["bomb_recovered_sound"] = "mp_war_objective_taken";
    game["dialog"]["offense_obj"] = "boost_tdm";
    game["dialog"]["defense_obj"] = "boost_tdm";
    game["dialog"]["flag_dropped"] = "ourblitzflag_drop";
    game["dialog"]["flag_returned"] = "ourflag_return";
    game["dialog"]["flag_getback"] = "ourblitzflag_getback";
    game["dialog"]["enemy_flag_taken"] = "ourblitzflag_taken";
    game["dialog"]["enemy_flag_dropped"] = "enemyblitzflag_drop";
    game["dialog"]["enemy_flag_returned"] = "ourblitzflag_return";
    setomnvar( "ui_ctf_flag_allies", -2 );
}

initializematchrules()
{
    scripts\mp\utility\game::setcommonrulesfrommatchrulesdata();
    setdynamicdvar( "scr_tdef_ppkTeamNoFlag", getmatchrulesdata( "tdefData", "ppkTeamNoFlag" ) );
    setdynamicdvar( "scr_tdef_ppkTeamWithFlag", getmatchrulesdata( "tdefData", "ppkTeamWithFlag" ) );
    setdynamicdvar( "scr_tdef_ppkFlagCarrier", getmatchrulesdata( "tdefData", "ppkFlagCarrier" ) );
    setdynamicdvar( "scr_tdef_scoringTime", getmatchrulesdata( "tdefData", "scoringTime" ) );
    setdynamicdvar( "scr_tdef_scorePerTick", getmatchrulesdata( "tdefData", "scorePerTick" ) );
    setdynamicdvar( "scr_tdef_carrierBonusTime", getmatchrulesdata( "tdefData", "carrierBonusTime" ) );
    setdynamicdvar( "scr_tdef_carrierBonusScore", getmatchrulesdata( "tdefData", "carrierBonusScore" ) );
    setdynamicdvar( "scr_tdef_delayplayer", getmatchrulesdata( "tdefData", "delayPlayer" ) );
    setdynamicdvar( "scr_tdef_spawndelay", getmatchrulesdata( "tdefData", "spawnDelay" ) );
    setdynamicdvar( "scr_tdef_flagActivationDelay", getmatchrulesdata( "tdefData", "flagActivationDelay" ) );
    setdynamicdvar( "scr_tdef_possessionResetCondition", getmatchrulesdata( "ballCommonData", "possessionResetCondition" ) );
    setdynamicdvar( "scr_tdef_possessionResetTime", getmatchrulesdata( "ballCommonData", "possessionResetTime" ) );
    setdynamicdvar( "scr_tdef_showEnemyCarrier", getmatchrulesdata( "carryData", "showEnemyCarrier" ) );
    setdynamicdvar( "scr_tdef_idleResetTime", getmatchrulesdata( "carryData", "idleResetTime" ) );
    setdynamicdvar( "scr_tdef_halftime", 0 );
    scripts\mp\utility\game::registerhalftimedvar( "tdef", 0 );
    setdynamicdvar( "scr_tdef_promode", 0 );
}

onstartgametype()
{
    setclientnamemode( "auto_change" );

    if ( !isdefined( game["switchedsides"] ) )
        game["switchedsides"] = 0;

    if ( game["switchedsides"] )
    {
        var_0 = game["attackers"];
        var_1 = game["defenders"];
        game["attackers"] = var_1;
        game["defenders"] = var_0;
    }

    foreach ( var_3 in level.teamnamelist )
    {
        scripts\mp\utility\game::setobjectivetext( var_3, &"OBJECTIVES/TDEF" );

        if ( level.splitscreen )
            scripts\mp\utility\game::setobjectivescoretext( var_3, &"OBJECTIVES/TDEF" );
        else
            scripts\mp\utility\game::setobjectivescoretext( var_3, &"OBJECTIVES/TDEF_SCORE" );

        scripts\mp\utility\game::setobjectivehinttext( var_3, &"OBJECTIVES/TDEF_ATTACKER_HINT" );
    }

    initspawns();
    tdef();
}

updategametypedvars()
{
    scripts\mp\gametypes\common.gsc::updatecommongametypedvars();
    level._id_11B48 = scripts\mp\utility\dvars::dvarintvalue( "ppkTeamNoFlag", 50, 0, 250 );
    level._id_11B49 = scripts\mp\utility\dvars::dvarintvalue( "ppkTeamWithFlag", 100, 0, 250 );
    level._id_11B47 = scripts\mp\utility\dvars::dvarintvalue( "ppkFlagCarrier", 250, 0, 250 );
    level.scoringtime = scripts\mp\utility\dvars::dvarfloatvalue( "scoringTime", 1, 1, 10 );
    level.scorepertick = scripts\mp\utility\dvars::dvarintvalue( "scorePerTick", 1, 1, 25 );
    level.carrierbonustime = scripts\mp\utility\dvars::dvarfloatvalue( "carrierBonusTime", 4, 0, 10 );
    level.carrierbonusscore = scripts\mp\utility\dvars::dvarintvalue( "carrierBonusScore", 25, 0, 250 );
    level.delayplayer = scripts\mp\utility\dvars::dvarintvalue( "delayPlayer", 1, 0, 1 );
    level.spawndelay = scripts\mp\utility\dvars::dvarfloatvalue( "spawnDelay", 2.5, 0, 30 );
    level.lb_mg_impulse_dmg_factor_mid_low = scripts\mp\utility\dvars::dvarfloatvalue( "flagActivationDelay", 10, 0, 30 );
    level.possessionresetcondition = scripts\mp\utility\dvars::dvarintvalue( "possessionResetCondition", 0, 0, 2 );
    level.possessionresettime = scripts\mp\utility\dvars::dvarfloatvalue( "possessionResetTime", 0, 0, 150 );
    level.idleresettime = scripts\mp\utility\dvars::dvarfloatvalue( "idleResetTime", 15, 0, 60 );
    level.showenemycarrier = scripts\mp\utility\dvars::dvarintvalue( "showEnemyCarrier", 5, 0, 6 );
}

initspawns()
{
    level.spawnmins = ( 0, 0, 0 );
    level.spawnmaxs = ( 0, 0, 0 );
    scripts\mp\spawnlogic::setactivespawnlogic( "TDef", "Crit_Frontline" );
    scripts\mp\spawnlogic::addstartspawnpoints( "mp_tdm_spawn_allies_start" );
    scripts\mp\spawnlogic::addstartspawnpoints( "mp_tdm_spawn_axis_start" );
    scripts\mp\spawnlogic::addspawnpoints( "allies", "mp_tdm_spawn" );
    scripts\mp\spawnlogic::addspawnpoints( "allies", "mp_tdm_spawn_secondary", 1, 1 );
    scripts\mp\spawnlogic::addspawnpoints( "axis", "mp_tdm_spawn" );
    scripts\mp\spawnlogic::addspawnpoints( "axis", "mp_tdm_spawn_secondary", 1, 1 );
    var_0 = scripts\mp\spawnlogic::getspawnpointarray( "mp_tdm_spawn" );
    var_1 = scripts\mp\spawnlogic::getspawnpointarray( "mp_tdm_spawn_secondary" );
    scripts\mp\spawnlogic::registerspawnset( "normal", var_0 );
    scripts\mp\spawnlogic::registerspawnset( "fallback", var_1 );
    level.mapcenter = scripts\mp\spawnlogic::findboxcenter( level.spawnmins, level.spawnmaxs );
    setmapcenter( level.mapcenter );

    foreach ( var_3 in level.spawnpoints )
        destpoint( var_3 );
}

destpoint( var_0 )
{
    var_0.scriptdata.hitleashrange = undefined;
    var_1 = getpathdist( var_0.origin, level.give_weapon_alt_clip_ammo_hack[0], 1000 );

    if ( var_1 < 0 )
        var_1 = scripts\engine\utility::distance_2d_squared( var_0.origin, level.give_weapon_alt_clip_ammo_hack[0] );
    else
        var_1 = var_1 * var_1;

    var_0.scriptdata.hitleashrange = var_1;
}

getspawnpoint()
{
    var_0 = self.pers["team"];

    if ( game["switchedsides"] )
        var_0 = scripts\mp\utility\game::getotherteam( var_0 )[0];

    if ( scripts\mp\spawnlogic::shoulduseteamstartspawn() )
    {
        var_1 = scripts\mp\spawnlogic::getspawnpointarray( "mp_tdm_spawn_" + var_0 + "_start" );
        var_2 = scripts\mp\spawnlogic::getspawnpoint_startspawn( var_1 );
    }
    else
    {
        var_3 = [];
        var_3["defenderFlagPosition"] = level.give_secondary_attachments_only.visuals[0].origin;

        if ( isdefined( level.give_secondary_attachments_only.carrier ) )
            var_3["activeCarrierPosition"] = level.give_secondary_attachments_only.carrier.origin;
        else
            var_3["activeCarrierPosition"] = var_3["defenderFlagPosition"];

        var_3["avoidDefenderFlagDeadZoneDistSq"] = 1000000;
        var_2 = scripts\mp\spawnlogic::getspawnpoint( self, var_0, "normal", "fallback", undefined, var_3 );
    }

    return var_2;
}

tdef()
{
    level.flagmodel["allies"] = "ctf_game_flag_west";
    level.flagbase["allies"] = "ctf_game_flag_base";
    level.carryflag["allies"] = "prop_ctf_game_flag_west";
    level.flagmodel["axis"] = "ctf_game_flag_east";
    level.flagbase["axis"] = "ctf_game_flag_base";
    level.carryflag["axis"] = "prop_ctf_game_flag_east";
    setupwaypointicons();
    level.iconescort = "waypoint_escort_flag";
    level.iconkill = "waypoint_ctf_kill";
    level.iconcaptureflag = "waypoint_take_flag";
    level.icondefendflag = "waypoint_defend_flag";
    level.iconreturnflag = "waypoint_recover_flag";
    level.suicide_on_end_remote = "waypoint_mlg_empty_flag";
    level.suicideandskydive = "waypoint_mlg_full_flag";
    level.icontarget = "waypoint_target";
    get_has_combined_counters_alias();
}

setupwaypointicons()
{
    scripts\mp\gamelogic::setwaypointiconinfo( "waypoint_ctf_kill", 2, "enemy", "MP_INGAME_ONLY/OBJ_KILL_CAPS", "icon_waypoint_kill", 0 );
    scripts\mp\gamelogic::setwaypointiconinfo( "waypoint_recover_flag", 0, "neutral", "MP_INGAME_ONLY/OBJ_RECOVER_CAPS", "icon_waypoint_flag", 0 );
    scripts\mp\gamelogic::setwaypointiconinfo( "waypoint_escort_flag", 2, "friendly", "MP_INGAME_ONLY/OBJ_DEFEND_CAPS", "icon_waypoint_flag", 0 );
    scripts\mp\gamelogic::setwaypointiconinfo( "waypoint_take_flag", 0, "neutral", "MP_INGAME_ONLY/OBJ_TAKE_CAPS", "icon_waypoint_flag", 0 );
    scripts\mp\gamelogic::setwaypointiconinfo( "waypoint_defend_flag", 0, "friendly", "MP_INGAME_ONLY/OBJ_DEFEND_CAPS", "icon_waypoint_flag", 0 );
    scripts\mp\gamelogic::setwaypointiconinfo( "waypoint_target", 0, "neutral", "MP_INGAME_ONLY/OBJ_TARGET_CAPS", "icon_waypoint_locked", 0 );
    scripts\mp\gamelogic::setwaypointiconinfo( "waypoint_mlg_empty_flag", 0, "friendly", "MP_INGAME_ONLY/OBJ_DEFEND_CAPS", "codcaster_icon_waypoint_ctf_empty", 0 );
    scripts\mp\gamelogic::setwaypointiconinfo( "waypoint_mlg_full_flag", 0, "friendly", "MP_INGAME_ONLY/OBJ_DEFEND_CAPS", "codcaster_icon_waypoint_ctf_full", 0 );
}

get_has_combined_counters_alias()
{
    level.give_weapon_alt_clip_ammo_hack = scripts\engine\utility::array_randomize( level.give_weapon_alt_clip_ammo_hack );
    var_0 = level.give_weapon_alt_clip_ammo_hack[0] + ( 0, 0, 64 );
    var_1 = level.give_weapon_alt_clip_ammo_hack[0] + ( 0, 0, -64 );
    var_2 = scripts\engine\trace::ray_trace( var_0, var_1, undefined, scripts\engine\trace::create_default_contents( 1 ) );
    level.give_weapon_alt_clip_ammo_hack[0] = var_2["position"];
    level.give_secondary_attachments_only = get_num_of_valid_players( "allies" );
    level thread lb_mg_impulse_dmg_threshold_top();
}

lb_mg_impulse_dmg_threshold_top()
{
    if ( !scripts\mp\flags::gameflag( "prematch_done" ) )
    {
        level.give_xp_to_all_players_hack.trychangesuitsforplayer scripts\mp\gameobjects::setvisibleteam( "none" );
        level scripts\engine\utility::_id_133EF( "prematch_done", "start_mode_setup" );
        level.give_xp_to_all_players_hack.trychangesuitsforplayer scripts\mp\gameobjects::setvisibleteam( "any" );
    }

    if ( level.lb_mg_impulse_dmg_factor_mid_low )
    {
        scripts\mp\flags::gameflagwait( "prematch_done" );
        level.give_xp_to_all_players_hack.trychangesuitsforplayer thread scripts\mp\gametypes\obj_zonecapture.gsc::spawn_boss_wave_section( level.lb_mg_impulse_dmg_factor_mid_low, level.give_secondary_attachments_only.curorigin + level.give_secondary_attachments_only.offset3d );
        wait( level.lb_mg_impulse_dmg_factor_mid_low );
        level.give_xp_to_all_players_hack.trychangesuitsforplayer scripts\mp\gameobjects::_id_123A1( level.iconcaptureflag, level.iconcaptureflag, level.suicideandskydive );
        level.give_secondary_attachments_only.trigger scripts\engine\utility::trigger_on();

        foreach ( var_1 in level.teamnamelist )
            scripts\mp\utility\dialog::leaderdialog( "obj_generic_capture", var_1 );
    }
}

get_num_of_valid_players( var_0 )
{
    level.pickuptime = 0;
    level.returntime = 0;
    var_1 = 32;
    var_2 = spawn( "trigger_radius", level.give_weapon_alt_clip_ammo_hack[0], 0, var_1, 128 );
    var_3 = [];
    var_3[0] = spawn( "script_model", level.give_weapon_alt_clip_ammo_hack[0] );
    var_3[0] setmodel( level.flagmodel[var_0] );
    var_3[0] setasgametypeobjective();
    var_3[0] setteaminhuddatafromteamname( var_0 );
    var_4 = "neutral";
    var_5 = scripts\mp\gameobjects::createcarryobject( var_4, var_2, var_3, ( 0, 0, 85 ) );
    var_5 scripts\mp\gameobjects::allowcarry( "any" );
    var_5 scripts\mp\gameobjects::setteamusetime( "friendly", level.pickuptime );
    var_5 scripts\mp\gameobjects::setteamusetime( "enemy", level.returntime );
    var_5 scripts\mp\gameobjects::setvisibleteam( "none" );
    var_5 scripts\mp\gameobjects::_id_123A1( level.iconescort, level.iconkill, level.suicideandskydive );
    var_5 scripts\mp\objidpoolmanager::objective_set_play_intro( var_5.objidnum, 0 );
    var_5 scripts\mp\objidpoolmanager::objective_set_play_outro( var_5.objidnum, 0 );
    var_5 scripts\mp\gameobjects::_id_11DDE( ::lb_mg_wood_surf_dmg_scalar );
    var_5.allowweapons = 1;
    var_5.onpickup = ::onpickup;
    var_5.onpickupfailed = ::onpickup;
    var_5.ondrop = ::ondrop;
    var_5.onreset = ::onreset;

    if ( isdefined( level.showenemycarrier ) )
    {
        switch ( level.showenemycarrier )
        {
            case 0:
                var_5.objidpingfriendly = 1;
                var_5.objidpingenemy = 0;
                var_5.objpingdelay = 60.0;
                break;
            case 1:
                var_5.objidpingfriendly = 0;
                var_5.objidpingenemy = 0;
                var_5.objpingdelay = 0.05;
                break;
            case 2:
                var_5.objidpingfriendly = 1;
                var_5.objidpingenemy = 0;
                var_5.objpingdelay = 1.0;
                break;
            case 3:
                var_5.objidpingfriendly = 1;
                var_5.objidpingenemy = 0;
                var_5.objpingdelay = 1.5;
                break;
            case 4:
                var_5.objidpingfriendly = 1;
                var_5.objidpingenemy = 0;
                var_5.objpingdelay = 2.0;
                break;
            case 5:
                var_5.objidpingfriendly = 1;
                var_5.objidpingenemy = 0;
                var_5.objpingdelay = 3.0;
                break;
            case 6:
                var_5.objidpingfriendly = 1;
                var_5.objidpingenemy = 0;
                var_5.objpingdelay = 4.0;
                break;
        }

        var_6 = scripts\mp\objidpoolmanager::requestobjectiveid( 99 );
        var_5.pingobjidnum = var_6;
        scripts\mp\objidpoolmanager::objective_add_objective( var_6, "done", var_5.origin );
        scripts\mp\objidpoolmanager::objective_set_play_intro( var_6, 0 );
        scripts\mp\objidpoolmanager::objective_set_play_outro( var_6, 0 );
        var_5 scripts\mp\gameobjects::setvisibleteam( "none", var_6 );
        objective_setownerteam( var_6, var_0 );
        var_5 scripts\mp\gameobjects::_id_123A1( level.iconescort, level.iconkill, level.suicideandskydive, var_6 );
    }
    else
    {
        var_5.objidpingfriendly = 1;
        var_5.objidpingenemy = 0;
        var_5.objpingdelay = 3.0;
    }

    level.give_xp_to_all_players_hack = get_num_of_wire_to_cut( var_0, var_5 );
    return var_5;
}

lb_mg_wood_surf_dmg_scalar( var_0 )
{
    return !var_0 scripts\cp_mp\utility\player_utility::isinvehicle();
}

get_num_of_wire_to_cut( var_0, var_1 )
{
    var_2 = var_1.visuals[0].origin;
    var_3 = spawn( "script_model", var_2 );
    var_3 setmodel( level.flagbase[var_0] );
    var_3.ownerteam = "neutral";
    var_3 setasgametypeobjective();
    var_3 setteaminhuddatafromteamname( var_0 );
    var_3.trychangesuitsforplayer = scripts\mp\gameobjects::createobjidobject( var_2, "neutral", ( 0, 0, 85 ), undefined, "any", 0 );
    var_3.trychangesuitsforplayer scripts\mp\gameobjects::setvisibleteam( "any" );

    if ( level.lb_mg_impulse_dmg_factor_mid_low )
    {
        var_1.trigger scripts\engine\utility::trigger_off();
        var_3.trychangesuitsforplayer scripts\mp\gameobjects::_id_123A1( level.icontarget, level.icontarget, level.suicideandskydive );
    }
    else
        var_3.trychangesuitsforplayer scripts\mp\gameobjects::_id_123A1( level.iconcaptureflag, level.iconcaptureflag, level.suicideandskydive );

    return var_3;
}

setteaminhuddatafromteamname( var_0 )
{
    if ( var_0 == "axis" )
        self setteaminhuddata( 1 );
    else if ( var_0 == "allies" )
        self setteaminhuddata( 2 );
    else
        self setteaminhuddata( 0 );
}

onpickup( var_0, var_1, var_2 )
{
    self notify( "picked_up" );
    var_0 notify( "obj_picked_up" );
    level.give_xp_to_all_players_hack.trychangesuitsforplayer scripts\mp\gameobjects::setvisibleteam( "none" );
    level.give_secondary_attachments_only.get_station_names_on_track = var_0;
    var_0 thread brrebirth_playernakeddroploadout();
    var_0 thread lb_mg_impulse_dmg_threshold_low();
    var_3 = scripts\mp\gameobjects::getownerteam();
    scripts\mp\gameobjects::setownerteam( var_0.team );
    var_4 = var_0.pers["team"];

    if ( var_4 == "allies" )
        var_5 = "axis";
    else
        var_5 = "allies";

    var_0 attachflag();
    var_0 scripts\mp\utility\stats::incpersstat( "pickups", 1 );

    if ( self.ownerteam == "allies" )
        setomnvar( "ui_ctf_flag_allies", var_0 getentitynumber() );
    else
        setomnvar( "ui_ctf_flag_allies", var_0 getentitynumber() );

    var_0 setclientomnvar( "ui_ctf_flag_carrier", 1 );

    if ( isdefined( level.showenemycarrier ) )
    {
        if ( level.showenemycarrier == 0 )
            scripts\mp\gameobjects::setvisibleteam( "none" );
        else
        {
            scripts\mp\gameobjects::setvisibleteam( "friendly" );
            objective_state( self.pingobjidnum, "current" );
            scripts\mp\gameobjects::updatecompassicon( "enemy", self.pingobjidnum );
            objective_icon( self.pingobjidnum, "icon_waypoint_kill" );
            objective_setbackground( self.pingobjidnum, 2 );
            scripts\mp\objidpoolmanager::truckwarspawnlocations( self.pingobjidnum, 1 );
            scripts\mp\objidpoolmanager::update_objective_setfriendlylabel( self.pingobjidnum, "MP_INGAME_ONLY/OBJ_DEFEND_CAPS" );
            scripts\mp\objidpoolmanager::update_objective_setenemylabel( self.pingobjidnum, "MP_INGAME_ONLY/OBJ_KILL_CAPS" );
            objective_setownerteam( self.pingobjidnum, var_4 );
        }
    }

    scripts\mp\gameobjects::_id_123A1( level.iconescort, level.iconkill, level.suicideandskydive );
    scripts\mp\utility\print::printandsoundoneveryone( var_4, var_5, undefined, undefined, "mp_obj_taken", "mp_enemy_obj_taken", var_0 );

    if ( !level.gameended )
    {
        scripts\mp\utility\dialog::leaderdialog( "enemy_flag_taken", var_4 );
        scripts\mp\utility\dialog::leaderdialog( "flag_getback", var_5 );
    }

    thread scripts\mp\hud_util::teamplayercardsplash( "callout_flagpickup", var_0 );
    var_0 thread scripts\mp\hud_message::showsplash( "flagpickup" );

    if ( !isdefined( self.previouscarrier ) || self.previouscarrier != var_0 )
        var_0 thread scripts\mp\utility\points::giveunifiedpoints( "flag_grab" );

    var_0 thread scripts\common\utility::_id_12ED6( level.stack_patch_waittill_context_patch, "pickup", var_0.origin );
    self.previouscarrier = var_0;

    if ( level.codcasterenabled )
        var_0 setgametypevip( 1 );
}

returnflag()
{
    scripts\mp\gameobjects::returnhome();
}

ondrop( var_0 )
{
    if ( isdefined( var_0.leaving_team ) )
    {
        self.droppedteam = var_0.leaving_team;
        var_0.leaving_team = undefined;
    }
    else if ( !isdefined( var_0 ) )
        self.droppedteam = self.ownerteam;
    else
        self.droppedteam = var_0.team;

    level.give_secondary_attachments_only.get_station_names_on_track = undefined;

    if ( isdefined( var_0 ) )
        var_0 _id_1309A();

    scripts\mp\gameobjects::setownerteam( "neutral" );
    var_1 = self.droppedteam;
    var_2 = scripts\mp\utility\game::getotherteam( self.droppedteam )[0];
    scripts\mp\gameobjects::allowcarry( "any" );
    scripts\mp\gameobjects::setvisibleteam( "any" );
    objective_state( self.pingobjidnum, "done" );

    if ( level.returntime >= 0 )
        scripts\mp\gameobjects::_id_123A1( level.iconreturnflag, level.iconreturnflag, level.suicideandskydive );
    else
    {
        scripts\mp\gameobjects::_id_123A1( level.iconreturnflag, level.iconreturnflag, level.suicideandskydive );
        scripts\mp\objidpoolmanager::truckwarspawnlocations( self.objidnum, 1 );
    }

    if ( self.ownerteam == "allies" )
        setomnvar( "ui_ctf_flag_allies", -1 );
    else
        setomnvar( "ui_ctf_flag_allies", -1 );

    if ( isdefined( var_0 ) )
        var_0 setclientomnvar( "ui_ctf_flag_carrier", 0 );

    if ( isdefined( var_0 ) )
    {
        if ( !scripts\mp\utility\player::isreallyalive( var_0 ) )
            var_0.carryobject.previouscarrier = undefined;

        if ( isdefined( var_0.carryflag ) )
            var_0 detachflag();

        scripts\mp\utility\print::printandsoundoneveryone( var_2, "none", undefined, undefined, "mp_war_objective_lost", "", var_0 );

        if ( level.codcasterenabled )
            var_0 setgametypevip( 0 );
    }
    else
        scripts\mp\utility\sound::playsoundonplayers( "mp_war_objective_lost", var_2 );

    if ( !level.gameended )
    {
        scripts\mp\utility\dialog::leaderdialog( "enemy_flag_dropped", scripts\mp\utility\game::getotherteam( self.droppedteam )[0], "status" );
        scripts\mp\utility\dialog::leaderdialog( "flag_dropped", self.droppedteam, "status" );
    }

    if ( level.idleresettime > 0 )
        thread returnaftertime();
}

returnaftertime()
{
    self endon( "picked_up" );
    var_0 = 0.0;

    while ( var_0 < level.idleresettime )
    {
        waitframe();

        if ( self.claimteam == "none" )
            var_0 = var_0 + level.framedurationseconds;
    }

    foreach ( var_2 in level.teamnamelist )
        scripts\mp\utility\sound::playsoundonplayers( "mp_war_objective_lost", var_2 );

    scripts\mp\gameobjects::returnhome();
}

onreset()
{
    level.give_secondary_attachments_only.get_station_names_on_track = undefined;

    if ( isdefined( level.give_secondary_attachments_only._id_11B00 ) )
    {
        level.give_secondary_attachments_only._id_11B00 clearportableradar();
        level.give_secondary_attachments_only._id_11B00 delete();
    }

    if ( isdefined( self.droppedteam ) )
        scripts\mp\gameobjects::setownerteam( self.droppedteam );

    var_0 = scripts\mp\gameobjects::getownerteam();
    var_1 = scripts\mp\utility\game::getotherteam( var_0 )[0];
    scripts\mp\gameobjects::allowcarry( "any" );
    scripts\mp\gameobjects::setvisibleteam( "none" );
    scripts\mp\gameobjects::setobjectivestatusicons( level.iconescort, level.iconkill );
    level.give_xp_to_all_players_hack.trychangesuitsforplayer scripts\mp\gameobjects::setvisibleteam( "any" );

    if ( !level.gameended )
    {
        scripts\mp\utility\dialog::leaderdialog( "enemy_flag_returned", scripts\mp\utility\game::getotherteam( self.droppedteam )[0], "status" );
        scripts\mp\utility\dialog::leaderdialog( "enemy_flag_returned", self.droppedteam, "status" );
    }

    self.droppedteam = undefined;

    if ( self.ownerteam == "allies" )
        setomnvar( "ui_ctf_flag_allies", -2 );
    else
        setomnvar( "ui_ctf_flag_allies", -2 );

    self.previouscarrier = undefined;
}

attachflag()
{
    _id_13099();
    var_0 = scripts\mp\utility\game::getotherteam( self.pers["team"] )[0];
    self attach( level.carryflag[var_0], "tag_stowed_back3", 1 );
    self.carryflag = level.carryflag[var_0];
}

detachflag()
{
    self detach( self.carryflag, "tag_stowed_back3" );
    self.carryflag = undefined;
}

_id_1309A()
{
    self setclientomnvar( "ui_match_status_hint_text", 43 );
}

_id_13099()
{
    self setclientomnvar( "ui_match_status_hint_text", 43 );
}

brrebirth_playernakeddroploadout( var_0 )
{
    level endon( "game_ended" );
    level.give_secondary_attachments_only endon( "dropped" );
    level.give_secondary_attachments_only endon( "reset" );
    level notify( "objTimePointsRunning" );
    level endon( "objTimePointsRunning" );

    while ( !level.gameended )
    {
        wait 1;
        scripts\mp\hostmigration::waittillhostmigrationdone();

        if ( !level.gameended )
        {
            level.give_secondary_attachments_only.carrier scripts\mp\utility\stats::incpersstat( "objTime", 1 );
            level.give_secondary_attachments_only.carrier scripts\mp\persistence::statsetchild( "round", "objTime", level.give_secondary_attachments_only.carrier.pers["objTime"] );
            level.give_secondary_attachments_only.carrier scripts\mp\utility\stats::setextrascore0( level.give_secondary_attachments_only.carrier.pers["objTime"] );
            level.give_secondary_attachments_only.carrier scripts\mp\gamescore::giveplayerscore( "tdef_hold_obj", 10 );
        }
    }
}

lb_mg_impulse_dmg_threshold_low( var_0 )
{
    level endon( "game_ended" );
    level.give_secondary_attachments_only endon( "dropped" );
    level.give_secondary_attachments_only endon( "reset" );
    level notify( "portableRadarRunning" );
    level endon( "portableRadarRunning" );

    if ( isdefined( level.give_secondary_attachments_only._id_11B00 ) )
    {
        level.give_secondary_attachments_only._id_11B00 clearportableradar();
        level.give_secondary_attachments_only._id_11B00 delete();
    }

    if ( !isdefined( var_0 ) )
        var_0 = self.team;

    var_1 = new_col_map( var_0 );
    var_2 = spawn( "script_model", level.give_secondary_attachments_only.visuals[0].origin );
    var_2.team = scripts\mp\utility\game::getotherteam( var_0 )[0];
    var_2.owner = var_1;
    var_2 makeportableradar( var_1 );
    level.give_secondary_attachments_only._id_11B00 = var_2;
    level.give_secondary_attachments_only thread lb_pitch_roll_dmg_factor();
    level.give_secondary_attachments_only thread lb_pitch_roll_dmg_threshold();
}

new_col_map( var_0 )
{
    level endon( "game_ended" );
    self endon( "dropped" );
    level endon( "portableRadarRunning" );
    var_1 = 0;

    for (;;)
    {
        if ( level.teamswithplayers.size == 1 && game["state"] == "playing" )
            var_1 = 1;
        else
        {
            if ( var_1 )
                wait 15;

            var_2 = scripts\mp\utility\game::getotherteam( var_0 )[0];
            var_1 = 0;

            foreach ( var_4 in level.players )
            {
                if ( isalive( var_4 ) && var_4.pers["team"] == var_2 )
                    return var_4;
            }
        }

        wait 0.05;
    }
}

lb_pitch_roll_dmg_factor()
{
    level endon( "game_ended" );
    self endon( "dropped" );
    self._id_11B00 endon( "death" );
    level endon( "portableRadarRunning" );

    for (;;)
    {
        self._id_11B00 moveto( self.get_station_names_on_track.origin, 0.05 );
        wait 0.05;
    }
}

lb_pitch_roll_dmg_threshold()
{
    level endon( "game_ended" );
    self endon( "dropped" );
    var_0 = self._id_11B00.team;
    var_0 = scripts\mp\utility\game::getotherteam( var_0 )[0];
    self._id_11B00.owner scripts\engine\utility::_id_133F0( "disconnect", "joined_team", "joined_spectators" );
    self._id_11B00 clearportableradar();
    self._id_11B00 = undefined;
    lb_mg_impulse_dmg_threshold_low( var_0 );
}

getrespawndelay()
{
    var_0 = level.give_secondary_attachments_only scripts\mp\gameobjects::getownerteam();

    if ( isdefined( var_0 ) )
    {
        if ( self.pers["team"] == var_0 )
        {
            if ( !level.spawndelay )
                return undefined;

            if ( level.delayplayer )
                return level.spawndelay;
        }
    }
}

onplayerconnect( var_0 )
{
    thread onplayerspawned( var_0 );
}

onplayerspawned( var_0 )
{
    for (;;)
    {
        var_0 waittill( "spawned" );
        var_0 setclientomnvar( "ui_ctf_flag_carrier", 0 );
        var_0 scripts\mp\utility\stats::setextrascore0( 0 );

        if ( isdefined( var_0.pers["objTime"] ) )
            var_0 scripts\mp\utility\stats::setextrascore0( var_0.pers["objTime"] );

        var_0 scripts\mp\utility\stats::setextrascore1( 0 );

        if ( isdefined( var_0.pers["defends"] ) )
            var_0 scripts\mp\utility\stats::setextrascore1( var_0.pers["defends"] );
    }
}

onplayerkilled( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9 )
{
    if ( !isplayer( var_1 ) || var_1 == self )
    {
        if ( isdefined( self.carryflag ) )
            detachflag();

        return;
    }

    var_10 = level._id_11B48;

    if ( isdefined( level.give_secondary_attachments_only ) && level.give_secondary_attachments_only scripts\mp\gameobjects::getownerteam() == var_1.pers["team"] )
    {
        if ( isdefined( level.give_secondary_attachments_only.carrier ) && var_1 != level.give_secondary_attachments_only.carrier )
        {
            level.give_secondary_attachments_only.carrier thread scripts\mp\rank::scoreeventpopup( "carrier_bonus" );
            var_11 = scripts\mp\rank::getscoreinfovalue( "carrier_bonus" );
            scripts\mp\gamescore::giveplayerscore( "carrier_bonus", var_11, self );
            level.give_secondary_attachments_only.carrier thread scripts\mp\rank::giverankxp( "carrier_bonus", var_11 );
            var_1 thread scripts\mp\rank::scoreeventpopup( "kill_bonus" );
            var_11 = scripts\mp\rank::getscoreinfovalue( "kill_bonus" );
            scripts\mp\gamescore::giveplayerscore( "kill_bonus", var_11, self );
            var_1 thread scripts\mp\rank::giverankxp( "kill_bonus", var_11 );
        }

        var_10 = level._id_11B49;
    }
    else if ( isdefined( self.carryflag ) )
        var_10 = level._id_11B47;

    var_1 scripts\mp\gamescore::giveteamscoreforobjective( var_1.pers["team"], var_10 );
    var_12 = 0;
    var_13 = var_1.origin;
    var_14 = 0;

    if ( isdefined( var_0 ) )
    {
        var_13 = var_0.origin;
        var_14 = var_0 == var_1;
    }

    if ( isdefined( var_1 ) && isplayer( var_1 ) && var_1.pers["team"] != self.pers["team"] )
    {
        if ( isdefined( var_1.carryflag ) && var_14 )
        {
            var_1 thread scripts\mp\rank::scoreeventpopup( "carrier_kill" );
            var_1 thread scripts\mp\awards::givemidmatchaward( "mode_ctf_kill_with_flag" );
            var_12 = 1;
        }

        if ( isdefined( self.carryflag ) )
        {
            var_1 thread scripts\mp\awards::givemidmatchaward( "mode_ctf_kill_carrier" );
            var_1 scripts\mp\utility\stats::incpersstat( "carrierKills", 1 );
            var_1 thread scripts\mp\hud_message::showsplash( "killed_carrier" );
            var_1 scripts\mp\utility\stats::incpersstat( "defends", 1 );
            var_1 scripts\mp\persistence::statsetchild( "round", "defends", var_1.pers["defends"] );
            thread scripts\common\utility::_id_12ED6( level.stadium_puzzle, var_9, "carrying" );
            scripts\mp\utility\game::setmlgannouncement( 20, var_1.team, var_1 getentitynumber() );
            var_12 = 1;
        }

        if ( !var_12 )
        {
            var_15 = 0;
            var_16 = 0;
            var_17 = distsquaredcheck( var_13, self.origin, level.give_secondary_attachments_only.curorigin );

            if ( var_17 )
            {
                if ( level.give_secondary_attachments_only.ownerteam == self.team )
                    var_15 = 1;
                else
                    var_16 = 1;
            }

            if ( var_15 )
            {
                var_1 thread scripts\mp\rank::scoreeventpopup( "assault" );
                var_1 thread scripts\mp\awards::givemidmatchaward( "mode_x_assault" );
                thread scripts\common\utility::_id_12ED6( level.stadium_puzzle, var_9, "defending" );
                var_1 scripts\mp\utility\stats::incpersstat( "assaults", 1 );
            }
            else if ( var_16 )
            {
                var_1 thread scripts\mp\rank::scoreeventpopup( "defend" );
                var_1 thread scripts\mp\awards::givemidmatchaward( "mode_x_defend" );
                var_1 scripts\mp\utility\stats::incpersstat( "defends", 1 );
                var_1 scripts\mp\persistence::statsetchild( "round", "defends", var_1.pers["defends"] );
                thread scripts\common\utility::_id_12ED6( level.stadium_puzzle, var_9, "assaulting" );
            }
        }
    }

    if ( isdefined( self.carryflag ) )
        detachflag();
}

distsquaredcheck( var_0, var_1, var_2 )
{
    var_3 = distancesquared( var_2, var_0 );
    var_4 = distancesquared( var_2, var_1 );

    if ( var_3 < 90000 || var_4 < 90000 )
        return 1;
    else
        return 0;
}

carriergivescore()
{
    level endon( "game_ended" );
    self endon( "death" );
    level.give_secondary_attachments_only endon( "dropped" );
    level.give_secondary_attachments_only endon( "reset" );

    for (;;)
    {
        wait( level.carrierbonustime );
        thread scripts\mp\utility\points::giveunifiedpoints( "ball_carry", undefined, level.carrierbonusscore );
    }
}
