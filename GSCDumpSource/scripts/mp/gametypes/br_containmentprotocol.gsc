// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    var_0 = ai_dropgren_override_hide();

    if ( !var_0 )
        return;

    level._effect["vista_rocket"] = loadfx( "vfx/iw8_br/gameplay/event/vfx_smktrail_vista_rocket" );
    thread addaliasarraytoqueue();
    thread _setplayerteamrank();
    thread _x1opsassignnpctoteam();
}

addaliasarraytoqueue()
{
    wait 3.0;
    scripts\mp\utility\sound::apc_target_enemies( "br_zmb_dov_sfx" );
}

ai_dropgren_override_hide()
{
    if ( getdvarint( "scr_br_containmentprotocol_debug_alwaysactivate", 0 ) == 1 )
        level.fulton = 1;

    if ( getdvarint( "scr_br_containmentprotocol", 0 ) == 0 && !istrue( level.fulton ) )
        return 0;

    level.fullweaponobj = spawnstruct();
    level.fullweaponobj.intensity = getdvarint( "scr_br_containmentprotocol_intensity", 1 );
    var_0 = getdvarfloat( "scr_br_containmentprotocol_intensity_likelihood", 0.05 );
    var_1 = randomfloat( 1.0 ) < var_0;
    return var_1 || istrue( level.fulton );
}

_setplayerteamrank()
{
    level endon( "game_ended" );
    level endon( "end_containment_fx" );

    if ( level.mapname != "mp_br_mechanics" )
        level waittill( "br_c130_left_bounds" );

    for (;;)
    {
        var_0 = scripts\mp\flags::gameflag( "prematch_done" ) || istrue( level.fulton );

        if ( var_0 )
            thread _start_rooftop_obj();

        var_1 = 0;
        var_2 = scripts\mp\utility\game::onfieldupgradeendbuffer() == "reveal";

        if ( !var_2 && isdefined( level.br_circle ) && isdefined( level.br_circle.circleindex ) )
        {
            var_3 = getdvarint( "scr_br_containmentprotocol_ambientfx_circlenum_delay", 5 );
            var_1 = 5 * max( 0, level.br_circle.circleindex );
        }

        var_4 = var_1 + getdvarint( "scr_br_containmentprotocol_ambientfx_delay_min", 25 );
        var_5 = var_1 + getdvarint( "scr_br_containmentprotocol_ambientfx_delay_max", 70 );
        var_6 = randomfloatrange( var_4, var_5 );
        wait( var_6 );
    }
}

_start_rooftop_obj()
{
    level endon( "end_containment_fx" );

    for ( var_0 = getdvarint( "scr_br_containmentprotocol_ambientfx_rocketcount", 3 ); var_0 > 0; var_0-- )
    {
        wait( randomfloat( 15.0 ) );
        thread _start_rooftop_raid_sats();
    }

    var_1 = getdvarint( "scr_br_containmentprotocol_ambientfx_delay_before_plane_strafe", 3 );
    wait( var_1 );
    _start_rooftop_raid_exfil();
}

_start_rooftop_raid_sats()
{
    level endon( "game_ended" );
    level endon( "end_containment_fx" );
    var_0 = ( randomintrange( -10000, 10000 ), randomintrange( -10000, 10000 ), 0 );
    var_1 = level.br_level.br_mapcenter + var_0;
    var_2 = getdvarint( "scr_br_containmentprotocol_ambientfx_rocketheight", -700 );
    var_1 = ( var_1[0], var_1[1], var_2 );
    var_3 = vectornormalize( ( randomfloatrange( -1, 1 ), randomfloatrange( -1, 1 ), 0 ) );
    var_4 = scripts\mp\utility\game_utility_mp::nuke_timescalefactor( 0 );
    var_5 = getdvarfloat( "scr_br_containmentprotocol_ambientfx_rocket_pathlengthmultiplier", 1.7 );
    var_6 = var_4 * var_5;
    var_7 = var_1 - var_3 * ( var_6 / 2.0 );
    var_8 = var_1 + var_3 * ( var_6 / 2.0 );
    var_9 = getdvarint( "scr_br_containmentprotocol_ambientfx_rocketduration", 14 );
    var_10 = spawn( "script_model", var_7 );

    if ( !isdefined( var_10 ) )
        return;

    var_10 setmodel( "tag_origin" );
    var_10 forcenetfieldhighlod( 1 );
    waitframe();
    waitframe();
    var_10 playloopsound( "zmb_cont_ks_missile_lp" );
    playfxontag( level._effect["vista_rocket"], var_10, "tag_origin" );
    var_11 = -1 * getdvarint( "NPOQPMP", 800 );
    var_12 = trajectorycalculateinitialvelocity( var_7, var_8, ( 0, 0, var_11 ), var_9 );
    var_10 movegravity( var_12, var_9 );

    if ( getdvarint( "scr_br_containmentprotocol_debug_logs", 0 ) == 1 )
    {
        var_13 = "Vista Rocket start:" + var_7 + "  destination:" + var_8;
        iprintlnbold( var_13 );
        logstring( var_13 );
    }

    var_14 = gettime();
    var_15 = gettime() + var_9 * 1000;

    while ( gettime() < var_15 )
    {
        var_16 = var_10.origin;
        waitframe();
        var_17 = var_10.origin;
        var_18 = var_17 - var_16;
        var_10.angles = vectortoangles( var_18 );
        var_10 addpitch( 90 );
    }

    waitframe();
    var_10 delete();
}

_start_rooftop_raid_exfil()
{
    level endon( "game_ended" );
    level endon( "end_containment_fx" );
    var_0 = scripts\mp\gametypes\br_circle.gsc::getrandompointincurrentcircle();

    if ( getdvarint( "scr_br_containmentprotocol_debug_planestafe_origin", 0 ) == 1 )
        var_0 = ( 0, 0, 0 );

    var_1 = getdvarint( "scr_br_containmentprotocol_ambientfx_rumbleradius", 10000 );
    var_2 = var_1 * var_1;
    var_3 = undefined;
    var_4 = [];

    foreach ( var_6 in level.players )
    {
        if ( var_6 scripts\mp\gametypes\br_public.gsc::rungwperif_flak() )
            continue;

        var_3 = var_6;
        var_7 = distancesquared( var_6.origin, var_0 );

        if ( var_7 < var_2 )
            var_4[var_4.size] = var_6;
    }

    foreach ( var_6 in var_4 )
    {

    }

    while ( istrue( level.fullweaponobj.initcprooftopcrate ) || istrue( level.fullweaponobj.wait_spawn_final_juggernaut ) )
        waitframe();

    level.fullweaponobj.wait_spawn_final_juggernaut = 1;
    _x1opsnpcpulsecheckteamnearby( 1, var_4 );
    _x1opsnpcwaittilluse();
    var_11 = undefined;

    if ( var_4.size > 0 )
        var_11 = var_4[0];
    else
        var_11 = var_3;

    if ( isdefined( var_11 ) )
    {
        wait 3.0;
        abandonedtimeoutoverride( var_4 );
        var_11 scripts\cp_mp\killstreaks\airstrike::disable_fulton_group_interactions( var_0, 1, 1 );

        if ( getdvarint( "scr_br_containmentprotocol_debug_logs", 0 ) == 1 )
            iprintlnbold( "Plane Strafe above:" + var_0 );

        wait 12.0;
        abandonedtimeoutdelay( var_4 );

        if ( istrue( level.fullweaponobj._id_11D98 ) )
        {
            _x1opsnpcwaittilluse( 1, level.fullweaponobj.get_total_from_call_count );
            wait 3.0;
            var_11 scripts\cp_mp\killstreaks\airstrike::disable_fulton_group_interactions( var_0, 1, 1 );

            if ( getdvarint( "scr_br_containmentprotocol_debug_logs", 0 ) == 1 )
                iprintlnbold( "Plane Strafe came back over:" + var_0 );

            wait 12.0;
            abandonedtimeoutdelay( var_4 );
            wait 3.0;
        }
    }

    level.fullweaponobj.get_total_from_call_count = undefined;
    level.fullweaponobj._id_11D98 = undefined;
    level.fullweaponobj.wait_spawn_final_juggernaut = undefined;
}

_x1opsassignnpctoteam()
{
    level endon( "game_ended" );
    level endon( "end_containment_fx" );

    if ( level.mapname != "mp_br_mechanics" )
        level waittill( "br_c130_left_bounds" );

    var_0 = _x1opsplayerredactalltacmaplocation();

    if ( !var_0 )
        return;

    abilitykey();
    _x1opsunassignnpcfromteam();
}

_x1opsplayerredactalltacmaplocation()
{
    if ( level.fullweaponobj.intensity == 0 || level.fullweaponobj.intensity == 1 )
    {
        if ( getdvarint( "scr_br_containmentprotocol_debug_alwaysactivate", 0 ) != 1 )
            return 0;

        level.fullweaponobj.intensity = 2;
    }

    if ( level.fullweaponobj.intensity == 2 )
    {
        game["dialog"]["containment_vo_1"] = "alert_phase1_10";
        game["dialog"]["containment_vo_2"] = "alert_phase1_20";
        game["dialog"]["containment_vo_3"] = "alert_phase1_30";
    }
    else if ( level.fullweaponobj.intensity == 3 )
    {
        game["dialog"]["containment_vo_1"] = "alert_phase2_10";
        game["dialog"]["containment_vo_2"] = "alert_phase2_20";
        game["dialog"]["containment_vo_3"] = "alert_phase2_30";
        game["dialog"]["containment_vo_4"] = "alert_phase2_40";
        game["dialog"]["containment_vo_5"] = "alert_tv_station_10";
    }
    else if ( level.fullweaponobj.intensity == 4 )
    {
        game["dialog"]["containment_vo_1"] = "alert_phase3_10";
        game["dialog"]["containment_vo_2"] = "alert_phase3_20";
        game["dialog"]["containment_vo_3"] = "alert_phase3_30";
        game["dialog"]["containment_vo_4"] = "alert_superstore_10";
        game["dialog"]["containment_vo_5"] = "alert_phase3_50";
    }
    else if ( level.fullweaponobj.intensity == 5 )
    {
        game["dialog"]["containment_vo_1"] = "alert_phase4_10";
        game["dialog"]["containment_vo_2"] = "alert_phase4_20";
        game["dialog"]["containment_vo_3"] = "alert_dam_10";
        game["dialog"]["containment_vo_4"] = "alert_phase4_30";
        var_0 = "";
        var_1 = randomintrange( 0, 4 );

        switch ( var_1 )
        {
            case 0:
                var_0 = "alert_phase4_40";
                break;
            case 1:
                var_0 = "alert_phase4_50";
                break;
            case 2:
                var_0 = "alert_phase4_70";
                break;
            case 3:
                var_0 = "alert_phase4_80";
                break;
            default:
                var_0 = "alert_phase4_40";
                break;
        }

        game["dialog"]["containment_vo_5"] = var_0;
    }
    else
        return 0;

    if ( getdvarint( "scr_br_containmentProtocol_vo_final", 0 ) == 1 )
    {
        game["dialog"]["containment_vo_1"] = "alert_phase4_10";
        game["dialog"]["containment_vo_2"] = "alert_phase4_20";
        game["dialog"]["containment_vo_3"] = "alert_phase4_30";
        game["dialog"]["containment_vo_4"] = "dov1_infil_1_10";
        game["dialog"]["containment_vo_5"] = "alert_phase4_40";
        game["dialog"]["containment_vo_6"] = "alert_phase4_50";
        game["dialog"]["containment_vo_7"] = "";
        game["dialog"]["containment_vo_8"] = "";
        game["dialog"]["containment_vo_9"] = "";
    }

    return 1;
}

abilitykey()
{
    level endon( "game_ended" );
    level endon( "end_containment_fx" );
    var_0 = getdvarint( "scr_br_containmentprotocol_vo_delay_min", 90 );
    var_1 = getdvarint( "scr_br_containmentprotocol_vo_delay_max", 360 );
    var_2 = getdvarint( "scr_br_containmentprotocol_vo_delay_override", -1 );
    var_3 = var_1;

    if ( var_2 != -1 )
        var_3 = var_2;
    else
        var_3 = randomintrange( var_0, var_1 );

    if ( getdvarint( "scr_br_containmentProtocol_vo_final", 0 ) == 1 && level.mapname != "mp_br_mechanics" )
        level waittill( "dov_1_broadcast" );
    else
        wait( var_3 );
}

_x1opsunassignnpcfromteam()
{
    level endon( "game_ended" );
    level endon( "end_containment_fx" );

    while ( istrue( level.fullweaponobj.wait_spawn_final_juggernaut ) )
        waitframe();

    level.fullweaponobj.initcprooftopcrate = 1;
    _x1opsnpcpulsecheckteamnearby( 1 );
    abandonbrsquadleader();
    abilities();
    wait 4.0;
    var_0 = 0;

    if ( getdvarint( "scr_br_containmentProtocol_vo_final", 0 ) == 1 )
    {
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_1" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_2" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_3" );
        var_0 = var_0 + abandonedtimeoutcallback( "op1_", "containment_vo_4", undefined, 1 );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_5" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_6" );
        var_0 = var_0 + 1.0;
        thread createallhistorydestinations( var_0 );
    }
    else
    {
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_1" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_2" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_3" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_4" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_5" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_6" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_7" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_8" );
        var_0 = var_0 + abandonedtimeoutcallback( "ebr_", "containment_vo_9" );
    }

    wait( var_0 );
    abilities();
    wait 4.0;
    setomnvarforallclients( "ui_br_events", 0 );
    level.fullweaponobj.initcprooftopcrate = undefined;
}

abandonedtimeoutcallback( var_0, var_1, var_2, var_3 )
{
    level endon( "game_ended" );
    level endon( "end_containment_fx" );

    if ( !isdefined( game["dialog"][var_1] ) || game["dialog"][var_1] == "" )
        return 0.0;

    var_4 = "dx_brm_" + var_0 + game["dialog"][var_1];
    var_4 = tolower( var_4 );
    var_5 = lookupsoundlength( var_4, 1 ) / 1000;
    var_5 = var_5 + 1;
    var_6 = undefined;

    if ( isdefined( var_2 ) )
        var_6 = var_2;
    else
        var_6 = level.players;

    foreach ( var_8 in var_6 )
    {
        if ( !isdefined( var_8 ) )
            continue;

        if ( !istrue( var_8 scripts\mp\gametypes\br_public.gsc::zombiejumping() ) || istrue( var_3 ) )
            var_8 queuedialogforplayer( var_4, var_1, var_5 );
    }

    return var_5;
}

abilities()
{
    foreach ( var_1 in level.players )
    {
        if ( _x1opsplayerunredacttacmaplocation( var_1 ) )
            var_1 playsoundtoplayer( "ui_broadcast_warning", var_1 );
    }
}

abandonbrsquadleader()
{
    var_0 = max( 0, level.fullweaponobj.intensity - 1 );
    setomnvarforallclients( "ui_br_events", int( var_0 ) );

    foreach ( var_2 in level.players )
    {
        if ( !_x1opsplayerunredacttacmaplocation( var_2 ) )
            var_2 setclientomnvar( "ui_br_events", 0 );
    }
}

createandstartlights()
{
    if ( istrue( level.fullweaponobj.initcprooftopcrate ) )
        self setclientomnvar( "ui_br_events", 0 );
}

createallhistorydestinations( var_0 )
{
    if ( getdvarint( "scr_br_containmentprotocol", 0 ) == 0 && !istrue( level.fulton ) )
        return;

    if ( getdvarint( "scr_br_containmentProtocol_vo_final", 0 ) != 1 )
        return;

    if ( !isdefined( level.fullweaponobj._id_13705 ) )
    {
        level.fullweaponobj._id_13705 = scripts\engine\utility::play_loopsound_in_space( "zmb_takeover_radio_background", ( 0, 0, 0 ) );
        level.fullweaponobj._id_13705 forcenetfieldhighlod( 1 );
        level.fullweaponobj._id_13705 hide();
    }

    foreach ( var_2 in level.players )
    {
        if ( !_x1opsplayerunredacttacmaplocation( var_2 ) )
            continue;

        level.fullweaponobj._id_13705 showtoplayer( var_2 );
        var_2 thread abilityleft( var_0 );
    }
}

abilityleft( var_0 )
{
    self endon( "disconnect" );
    scripts\engine\utility::waittill_notify_or_timeout_return( "spawnZombie", var_0 );

    if ( !isdefined( level.fullweaponobj._id_13705 ) )
        return;

    level.fullweaponobj._id_13705 hidefromplayer( self );

    if ( istrue( level.fullweaponobj.initcprooftopcrate ) && !_x1opsplayerunredacttacmaplocation( self ) )
        self setclientomnvar( "ui_br_events", 0 );
}

createalldestinationvfx()
{
    if ( !isdefined( level.fullweaponobj._id_13705 ) )
        return;

    level.fullweaponobj._id_13705 delete();
    level.fullweaponobj._id_13705 = undefined;
}

_x1opsplayerunredacttacmaplocation( var_0 )
{
    var_1 = istrue( var_0.clean_up_search );
    var_2 = var_0 scripts\mp\gametypes\br_public.gsc::zombiejumping();
    var_3 = var_0 scripts\mp\gametypes\br_public.gsc::rungwperif_flak();
    return !var_1 && !var_2 && !var_3;
}

_x1opsnpcwaittilluse( var_0, var_1 )
{
    var_2 = -1;
    var_3 = "";
    var_2 = randomintrange( 0, 3 );

    switch ( var_2 )
    {
        case 0:
            var_3 = "clv_";
            break;
        case 1:
            var_3 = "g51_";
            break;
        case 2:
            var_3 = "g68_";
            break;
        default:
            var_3 = "clv_";
            break;
    }

    if ( isdefined( var_1 ) )
        var_3 = var_1;

    level.fullweaponobj.get_total_from_call_count = var_3;
    game["dialog"]["strafing_pre"] = "";
    game["dialog"]["strafing_before"] = "";
    game["dialog"]["strafing_after"] = "";
    game["dialog"]["strafing_post"] = "";

    switch ( var_3 )
    {
        case "clv_":
            var_2 = randomintrange( 0, 5 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_pre"] = "missile_away_10";
                    break;
                case 1:
                    game["dialog"]["strafing_pre"] = "missile_away_20";
                    break;
                default:
                    game["dialog"]["strafing_pre"] = "";
                    break;
            }

            break;
        case "g51_":
            var_2 = randomintrange( 0, 4 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_pre"] = "strafing_strangers_10";
                default:
                    game["dialog"]["strafing_pre"] = "";
                    break;
            }

            break;
        case "g68_":
            var_2 = randomintrange( 0, 4 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_pre"] = "strafing_strangers_10";
                    break;
                case 1:
                    game["dialog"]["strafing_pre"] = "strafing_swarming_10";
                    break;
                default:
                    game["dialog"]["strafing_pre"] = "";
                    break;
            }

            break;
        default:
            break;
    }

    switch ( var_3 )
    {
        case "clv_":
            var_2 = randomintrange( 0, 6 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_before"] = "missile_inbound_10";
                    break;
                case 1:
                    game["dialog"]["strafing_before"] = "missile_launch_confirmed_10";
                    break;
                case 2:
                    game["dialog"]["strafing_before"] = "missile_launch_confirmed_20";
                    break;
                case 3:
                    game["dialog"]["strafing_before"] = "missile_launched_10";
                    break;
                case 4:
                    game["dialog"]["strafing_before"] = "missile_launched_20";
                    break;
                case 5:
                    game["dialog"]["strafing_before"] = "missile_launched_30";
                    break;
                default:
                    game["dialog"]["strafing_before"] = "";
                    break;
            }

            break;
        case "g51_":
            var_2 = randomintrange( 0, 3 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_before"] = "strafing_commence_10";
                    break;
                case 1:
                    game["dialog"]["strafing_before"] = "strafing_inbound_10";
                    break;
                case 2:
                    game["dialog"]["strafing_before"] = "strafing_weapon_drop_10";
                    break;
                default:
                    game["dialog"]["strafing_before"] = "";
                    break;
            }

            break;
        case "g68_":
            var_2 = randomintrange( 0, 2 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_before"] = "strafing_ground_attack_10";
                    break;
                case 1:
                    game["dialog"]["strafing_before"] = "strafing_target_grid_10";
                    break;
                default:
                    game["dialog"]["strafing_before"] = "";
                    break;
            }

            break;
        default:
            break;
    }

    switch ( var_3 )
    {
        case "clv_":
            var_2 = randomintrange( 0, 3 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_after"] = "missile_miss_10";
                    break;
                case 1:
                    game["dialog"]["strafing_after"] = "missile_miss_20";
                    break;
                case 2:
                    game["dialog"]["strafing_after"] = "missile_miss_30";
                    break;
                default:
                    game["dialog"]["strafing_after"] = "";
                    break;
            }

            break;
        case "g51_":
            var_2 = randomintrange( 0, 9 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_after"] = "strafing_1_kill_10";
                    break;
                case 1:
                    game["dialog"]["strafing_after"] = "strafing_2_kill_10";
                    break;
                case 2:
                    game["dialog"]["strafing_after"] = "strafing_eliminated_10";
                    break;
                case 3:
                    game["dialog"]["strafing_after"] = "strafing_fail_10";
                    break;
                case 4:
                    game["dialog"]["strafing_after"] = "strafing_fail_20";
                    break;
                case 5:
                    game["dialog"]["strafing_after"] = "strafing_fail_30";
                    break;
                case 6:
                    game["dialog"]["strafing_after"] = "strafing_hits_10";
                    break;
                case 7:
                    game["dialog"]["strafing_after"] = "strafing_multiple_hit_10";
                    break;
                case 8:
                    game["dialog"]["strafing_after"] = "strafing_strangers_down_10";
                    break;
                default:
                    game["dialog"]["strafing_after"] = "";
                    break;
            }

            break;
        case "g68_":
            var_2 = randomintrange( 0, 6 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_after"] = "strafing_1_kill_10";
                    break;
                case 1:
                    game["dialog"]["strafing_after"] = "strafing_2_targets_down_10";
                    break;
                case 2:
                    game["dialog"]["strafing_after"] = "strafing_2_kill_10";
                    break;
                case 3:
                    game["dialog"]["strafing_after"] = "strafing_3_kill_10";
                    break;
                case 4:
                    game["dialog"]["strafing_after"] = "strafing_fail_10";
                    break;
                case 5:
                    game["dialog"]["strafing_after"] = "strafing_fail_20";
                    break;
                case 6:
                    game["dialog"]["strafing_after"] = "strafing_fail_30";
                    break;
                case 7:
                    game["dialog"]["strafing_after"] = "strafing_on_target_10";
                    break;
                case 8:
                    game["dialog"]["strafing_after"] = "strafing_stranger_down_10";
                    break;
                default:
                    game["dialog"]["strafing_after"] = "";
                    break;
            }

            break;
        default:
            break;
    }

    switch ( var_3 )
    {
        case "clv_":
            game["dialog"]["strafing_post"] = "";
            break;
        case "g51_":
            var_2 = randomintrange( 0, 4 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_post"] = "strafing_down_there_10";
                    break;
                case 1:
                    game["dialog"]["strafing_post"] = "strafing_reengage_12";
                    level.fullweaponobj._id_11D98 = 1;
                    break;
                default:
                    game["dialog"]["strafing_pre"] = "";
                    break;
            }

            break;
        case "g68_":
            var_2 = randomintrange( 0, 4 );

            switch ( var_2 )
            {
                case 0:
                    game["dialog"]["strafing_post"] = "strafing_down_there_10";
                    break;
                case 1:
                    game["dialog"]["strafing_post"] = "strafing_reengage_10";
                    level.fullweaponobj._id_11D98 = 1;
                    break;
                default:
                    game["dialog"]["strafing_post"] = "";
                    break;
            }

            break;
        default:
            break;
    }

    if ( istrue( var_0 ) )
    {
        game["dialog"]["strafing_pre"] = "";
        game["dialog"]["strafing_before"] = "";
        game["dialog"]["strafing_post"] = "";
    }
}

abandonedtimeoutoverride( var_0 )
{
    level endon( "end_containment_fx" );
    var_1 = abandonedtimeoutcallback( level.fullweaponobj.get_total_from_call_count, "strafing_pre", var_0 );

    if ( var_1 != 0 )
        wait( var_1 + 3.0 );

    abandonedtimeoutcallback( level.fullweaponobj.get_total_from_call_count, "strafing_before", var_0 );
}

abandonedtimeoutdelay( var_0 )
{
    level endon( "end_containment_fx" );
    var_1 = abandonedtimeoutcallback( level.fullweaponobj.get_total_from_call_count, "strafing_after", var_0 );

    if ( var_1 != 0 )
        wait( var_1 + 3.0 );

    var_1 = abandonedtimeoutcallback( level.fullweaponobj.get_total_from_call_count, "strafing_post", var_0 );

    if ( var_1 != 0 )
        wait( var_1 );
}

_x1opsnpcpulsecheckteamnearby( var_0, var_1 )
{
    level endon( "game_ended" );
    level endon( "end_containment_fx" );
    var_2 = undefined;

    if ( isdefined( var_1 ) )
        var_2 = var_1;
    else
        var_2 = level.players;

    var_3 = gettime();
    var_4 = var_3 + 10000;

    while ( var_3 < var_4 )
    {
        waitframe();
        var_5 = 0;

        foreach ( var_7 in var_2 )
        {
            if ( !isdefined( var_7 ) )
                continue;

            if ( !var_7 _meth_87C1() )
            {
                var_5 = 1;
                break;
            }
        }

        if ( var_5 )
        {
            var_3 = gettime();
            continue;
        }

        break;
    }
}
