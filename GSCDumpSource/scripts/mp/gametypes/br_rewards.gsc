// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init_br_rewards()
{
    processkillstreaksintotiers();
    level.tierrewardcounts = [];
    level.tierrewardcounts[3] = 0;
    level.tierrewardcounts[2] = 0;
    level.tierrewardcounts[1] = 0;
    level.tierrewardcounts[0] = 0;
}

runmissionrewarddelivery( var_0, var_1, var_2, var_3 )
{
    var_4 = undefined;

    if ( !isdefined( var_0.rewardlocation ) )
    {
        var_4 = findclosestdroplocation( var_0 );

        if ( !isdefined( var_4 ) )
            var_4 = calculatedroplocationnearlocation( var_0, 64, 2048 );
    }
    else
        var_4 = var_0.rewardlocation;

    if ( isdefined( var_2 ) )
        thread runkillstreakreward( var_4, var_1, var_2 );
    else if ( isdefined( var_3 ) )
        thread runkillstreakreward( var_4, var_1, getkillstreak( var_3 ) );
    else
        thread runkillstreakreward( var_4, var_1, getkillstreak( 3 ) );
}

runkillstreakreward( var_0, var_1, var_2 )
{
    level endon( "game_ended" );
    var_3 = undefined;

    if ( !istrue( var_0.isinside ) )
        var_4 = 72;
    else
        var_4 = 40;

    var_5 = scripts\mp\gameobjects::createobjidobject( var_0.origin, "neutral", ( 0, 0, var_4 ), undefined, "any" );
    maskobjectivetoplayerssquad( var_5, var_1 );
    var_5.origin = var_0.origin;
    var_5.angles = var_0.angles;
    thread docratedropsmoke( undefined, var_0, 16 );
    var_5.iconname = "_incoming";
    var_5.lockupdatingicons = 0;
    var_5 scripts\mp\gameobjects::setobjectivestatusicons( var_2 );
    var_5.lockupdatingicons = 1;
    wait 3;
    wait 1;

    if ( !istrue( var_0.isinside ) )
    {
        var_3 = scripts\cp_mp\killstreaks\airdrop::droparmcratefromscriptedheli( var_1.team, var_2, var_0.origin, ( 0, randomint( 360 ), 0 ), undefined );
        var_3.skipminimapicon = 1;
        var_3.nevertimeout = 0;
        var_3.waitforobjectiveactivate = 1;
        var_3.killminimapicon = 0;
        var_3.disallowheadiconid = 1;
        var_3.isarmcrate = 1;
        var_3 waittill( "crate_dropped" );
        var_5.useobj = var_3;
        var_5.origin = var_3.origin;
    }
    else
    {
        var_5.useobj = spawn( "script_model", var_5.origin );
        var_5.useobj.disallowheadiconid = 1;
        var_5.useobj.cratetype = "arm_no_owner";
        var_6 = scripts\cp_mp\killstreaks\airdrop::getleveldata( var_5.useobj.cratetype );
        var_5.useobj.minimapicon = var_6.minimapicon;
        var_5.useobj.capturestring = var_6.capturestring;
        var_5.useobj.rerollstring = var_6.rerollstring;
        var_5.useobj.supportsreroll = var_6.supportsreroll;
        var_5.useobj.isdummyarmcrate = 1;
        var_5.useobj.isarmcrate = 1;
        var_5.useobj.data = scripts\cp_mp\killstreaks\airdrop::getarmcratedatabystreakname( var_2 );
        scripts\mp\objidpoolmanager::update_objective_onentity( var_5.objidnum, var_5.useobj );
        scripts\mp\objidpoolmanager::update_objective_setzoffset( var_5.objidnum, 40 );
    }

    var_7 = 0;
    var_8 = 0.1;

    if ( istrue( var_0.isinside ) )
        var_9 = 15;
    else
        var_9 = 1;

    wait( var_9 );

    if ( !istrue( var_0.isinside ) )
    {
        var_3 notify( "objective_activate" );
        scripts\mp\objidpoolmanager::update_objective_onentity( var_5.objidnum, var_3 );
        scripts\mp\objidpoolmanager::update_objective_setzoffset( var_5.objidnum, 72 );
    }
    else
    {
        var_5.useobj scripts\cp_mp\killstreaks\airdrop::makecrateusable();
        var_6 = scripts\cp_mp\killstreaks\airdrop::getleveldata( var_5.useobj.cratetype );
        scripts\mp\objidpoolmanager::update_objective_setzoffset( var_5.objidnum, 40 );
    }

    var_5.iconname = "";
    var_5.lockupdatingicons = 0;
    var_5 scripts\mp\gameobjects::setobjectivestatusicons( var_2 );
    var_5.lockupdatingicons = 1;
    objective_setlabel( var_5.objidnum, "" );

    if ( isdefined( var_3 ) )
        var_3 waittill( "death" );
    else
        var_5.useobj waittill( "death" );

    var_5 scripts\mp\gameobjects::setvisibleteam( "none" );
    var_5 scripts\mp\gameobjects::releaseid();
    var_5.visibleteam = "none";
}

dropcrate( var_0, var_1, var_2 )
{
    var_3 = scripts\cp_mp\killstreaks\airdrop::droparmcratefromscriptedheli( var_2, var_0, var_1.origin, ( 0, randomint( 360 ), 0 ), undefined );
    return var_3;
}

docratedropsmoke( var_0, var_1, var_2 )
{
    var_3 = var_1.origin + ( 0, 0, 2000 );
    var_4 = scripts\common\utility::groundpos( var_3, ( 0, 0, 1 ) );
    var_1.vfxent = spawn( "script_model", var_4 );
    var_1.vfxent setmodel( "tag_origin" );
    var_1.vfxent.angles = ( 0, 0, 0 );
    var_1.vfxent playloopsound( "smoke_carepackage_smoke_lp" );
    wait 1;
    playfxontag( scripts\engine\utility::getfx( "vfx_smk_signal_gr" ), var_1.vfxent, "tag_origin" );

    if ( isdefined( var_0 ) )
        var_0 scripts\engine\utility::_id_13403( var_2, "crate_dropped" );
    else
        wait( var_2 );

    stopfxontag( scripts\engine\utility::getfx( "vfx_smk_signal_gr" ), var_1.vfxent, "tag_origin" );
    var_1.vfxent delete();
}

getkillstreak( var_0 )
{
    if ( !isdefined( level.killstreaktierlist ) )
        processkillstreaksintotiers();

    level.killstreaktierlist[var_0] = scripts\engine\utility::array_randomize( level.killstreaktierlist[var_0] );
    return level.killstreaktierlist[var_0][0];
}

br_getrandomkillstreakreward()
{
    var_0 = 0;
    var_1 = 0;
    var_2 = 0;
    var_3 = 0;
    var_4 = 0;
    var_5 = 0;
    var_6 = 10;
    var_7 = 35;
    var_8 = 35;
    var_9 = 20;

    if ( isdefined( level.tierrewardcounts[0] ) && level.tierrewardcounts[0] < 2 || 0 )
        var_0 = var_0 + 10;
    else
    {
        var_2 = 1;
        var_6 = 0;
    }

    if ( isdefined( level.tierrewardcounts[1] ) && level.tierrewardcounts[1] < -1 || 1 )
    {
        var_0 = var_0 + 35;

        if ( !var_2 )
            var_7 = var_7 + 10;
    }
    else
    {
        var_3 = 1;
        var_7 = 0;
    }

    if ( isdefined( level.tierrewardcounts[2] ) && level.tierrewardcounts[2] < -1 || 1 )
    {
        var_0 = var_0 + 35;

        if ( !var_2 )
            var_8 = var_8 + 10;

        if ( !var_3 )
            var_8 = var_8 + 35;
    }
    else
    {
        var_4 = 1;
        var_8 = 0;
    }

    if ( isdefined( level.tierrewardcounts[3] ) && level.tierrewardcounts[3] < 15 || 0 )
    {
        var_0 = var_0 + 20;

        if ( !var_2 )
            var_9 = var_9 + 10;

        if ( !var_3 )
            var_9 = var_9 + 35;

        if ( !var_3 )
            var_9 = var_9 + 35;
    }
    else
    {
        var_5 = 1;
        var_9 = 0;
    }

    var_10 = randomintrange( 1, var_0 );

    if ( var_10 <= var_6 )
    {
        level.tierrewardcounts[0]++;
        var_11 = scripts\engine\utility::array_randomize( level.killstreaktierlist[0] );
        return var_11[0];
    }
    else if ( var_10 <= var_7 )
    {
        level.tierrewardcounts[1]++;
        var_11 = scripts\engine\utility::array_randomize( level.killstreaktierlist[1] );
        return var_11[0];
    }
    else if ( var_10 <= var_8 )
    {
        level.tierrewardcounts[2]++;
        var_11 = scripts\engine\utility::array_randomize( level.killstreaktierlist[2] );
        return var_11[0];
    }
    else
    {
        level.tierrewardcounts[3]++;
        var_11 = scripts\engine\utility::array_randomize( level.killstreaktierlist[3] );
        return var_11[0];
    }
}

processkillstreaksintotiers()
{
    level.killstreaktierlist = [];
    level.killstreaktierlist[3] = [ "cruise_predator", "scrambler_drone_guard", "uav" ];
    level.killstreaktierlist[2] = [ "precision_airstrike", "multi_airstrike", "bradley" ];
    level.killstreaktierlist[1] = [ "toma_strike", "uav", "pac_sentry", "white_phosphorus" ];
    level.killstreaktierlist[0] = [ "uav" ];
}

br_getrewardicon( var_0 )
{
    return level.killstreakglobals.streaktable.tabledatabyref[var_0]["hudIcon"];
}

dropweaponcarepackage( var_0 )
{
    level endon( "game_ended" );
    var_1 = scripts\cp_mp\killstreaks\airdrop::dropcratefrommanualheli( undefined, undefined, "battle_royale", var_0, ( 0, randomfloat( 360 ), 0 ), 3000, 3000, var_0, scripts\cp_mp\killstreaks\airdrop::getbrcratedatabytype( "weapon" ) );

    if ( !isdefined( var_1 ) )
        return undefined;
    else if ( !isdefined( var_1.crate ) )
        return undefined;

    return var_1.crate;
}

initdropbagsystem()
{
    scripts\cp_mp\killstreaks\airdrop::initplundercratedata();
    level.waypointstring["icon_waypoint_marker"] = "DROP_BAG";
    level.dropbagstruct = spawnstruct();
    level.dropbagstruct.clusters = scripts\engine\utility::getstructarray( "dropBagCluterNode", "script_noteworthy" );
    var_0 = scripts\engine\utility::getstructarray( "dropBagLocation", "script_noteworthy" );

    foreach ( var_2 in var_0 )
    {
        var_2.inuse = 0;

        foreach ( var_4 in level.dropbagstruct.clusters )
        {
            if ( var_2.target == var_4.targetname )
            {
                if ( !isdefined( var_4.droplocations ) )
                    var_4.droplocations = [];

                var_4.droplocations[var_4.droplocations.size] = var_2;
                continue;
            }
        }
    }

    register_outer_room_spawners();
}

register_outer_room_spawners()
{
    game["dialog"]["dropbag_incoming"] = "gamestate_dropbag_incoming";
    game["dialog"]["dropbag_available"] = "gamestate_dropbag_available";
}

_id_11B59( var_0 )
{
    var_1 = [];
    var_2 = [];
    var_3 = scripts\mp\gametypes\br_circle.gsc::getsafecircleorigin();
    var_4 = scripts\mp\gametypes\br_circle.gsc::getsafecircleradius();
    var_5 = getarraykeys( level.teamdata );

    foreach ( var_7 in var_5 )
    {
        if ( level.teamdata[var_7]["teamCount"] > 0 )
        {
            var_8 = 0;
            var_9 = undefined;

            foreach ( var_11 in level.teamdata[var_7]["alivePlayers"] )
            {
                if ( !isdefined( var_9 ) && !istrue( var_11.gulag ) && !istrue( var_11.rotateeffect ) )
                    var_9 = var_11;

                if ( istrue( var_11.issquadleader ) && !istrue( var_11.gulag ) && !istrue( var_11.rotateeffect ) )
                {
                    var_8 = 1;
                    var_1[var_1.size] = var_11;

                    if ( istrue( var_0 ) && isdefined( level.br_spawns[var_11.team].groundorigin ) )
                        var_2[var_2.size] = level.br_spawns[var_11.team].groundorigin;
                    else
                        var_2[var_2.size] = var_11.origin;

                    break;
                }
            }

            if ( !var_8 )
            {
                if ( isdefined( var_9 ) )
                {
                    var_11 = var_9;
                    var_1[var_1.size] = var_11;

                    if ( istrue( var_0 ) && isdefined( level.br_spawns[var_11.team].groundorigin ) )
                        var_2[var_2.size] = level.br_spawns[var_11.team].groundorigin;
                    else
                        var_2[var_2.size] = var_11.origin;
                }
                else if ( level.teamdata[var_7]["aliveCount"] > 0 )
                {
                    var_11 = level.teamdata[var_7]["alivePlayers"][0];
                    var_1[var_1.size] = var_11;
                    var_13 = randomfloat( 360.0 );
                    var_14 = randomfloat( var_4 );
                    var_15 = var_3 + ( cos( var_13 ) * var_14, sin( var_13 ) * var_14, 0.0 );
                    var_2[var_2.size] = var_15;
                }
            }
        }
    }

    var_17 = 5;

    if ( isdefined( level.dropbagstruct.clusters ) && level.dropbagstruct.clusters.size && isdefined( level.dropbagstruct.clusters[0].droplocations ) )
        var_17 = level.dropbagstruct.clusters[0].droplocations.size;

    var_18 = getdvarfloat( "scr_dropbag_mindist", 3000 );
    var_19 = getdvarfloat( "scr_dropbag_maxdist", 7000 );
    var_20 = spawnstruct();
    var_20.origin = ( 0, 0, 0 );
    var_21 = [ var_20 ];

    if ( isdefined( level.br_level ) )
    {
        if ( var_4 > 0 )
            var_21 = getunusedlootcachepoints( var_2, level.dropbagstruct.clusters, level.br_level.br_mapbounds, var_18, var_19, 2000, var_17, 128, var_3, var_4 );
        else
            var_21 = getunusedlootcachepoints( var_2, level.dropbagstruct.clusters, level.br_level.br_mapbounds, var_18, var_19, 2000, var_17, 128 );
    }

    if ( isdefined( var_21 ) )
    {
        for ( var_22 = 0; var_22 < var_21.size; var_22++ )
        {
            var_11 = var_1[var_22];

            if ( isdefined( var_21[var_22].node ) )
            {
                var_23 = var_21[var_22].node;
                var_24 = level.dropbagstruct.clusters[var_23];
                var_25 = var_21[var_22].index;
                var_11._id_11B57 = var_24.droplocations[var_25].origin;
                continue;
            }

            var_11._id_11B57 = var_21[var_22].origin;
        }

        level._id_11B58 = 1;
        level thread _id_127C6( var_1 );
    }

    level thread spawnpoint_clearspawnpoint();
}

spawnpoint_clearspawnpoint()
{
    level notify( "manageDropBags" );
    level endon( "manageDropBags" );
    var_0 = -1;
    var_1 = getdvarfloat( "scr_br_circle_object_cleanup_threshold", 2400.0 );

    for (;;)
    {
        if ( !isdefined( level.br_pickups.crates ) || !level.br_pickups.crates.size )
        {
            var_0 = -1;
            wait 1.0;
            continue;
        }

        var_0 = ( var_0 + 1 ) % level.br_pickups.crates.size;
        var_2 = level.br_pickups.crates[var_0];

        if ( !isdefined( var_2 ) )
        {
            level.br_pickups.crates = scripts\engine\utility::array_removeundefined( level.br_pickups.crates );
            waitframe();
            continue;
        }

        if ( isdefined( var_2.team ) )
        {
            var_3 = 0;

            if ( isdefined( var_2.numuses ) )
                var_3 = var_2.numuses;

            if ( var_3 >= level.teamdata[var_2.team]["teamCount"] )
            {
                var_2 thread scripts\cp_mp\killstreaks\airdrop::destroycrate();
                waitframe();
                continue;
            }
        }

        var_4 = scripts\mp\gametypes\br_circle.gsc::getdangercircleradius();

        if ( var_4 > 0.0 )
        {
            var_5 = scripts\mp\gametypes\br_circle.gsc::getdangercircleorigin();
            var_6 = distance2dsquared( var_2.origin, var_5 );
            var_7 = max( 0, var_4 + var_1 );

            if ( var_6 > var_7 * var_7 )
            {
                var_2 thread scripts\cp_mp\killstreaks\airdrop::destroycrate();
                waitframe();
                continue;
            }
        }

        waitframe();
    }
}

fail_mission_if_killed( var_0, var_1 )
{
    var_2 = [];

    foreach ( var_4 in level.br_pickups.crates )
    {
        if ( !isdefined( var_4 ) || !isdefined( var_4.team ) || var_4.team != var_0 )
            continue;

        var_2[var_2.size] = var_4;
    }

    var_6 = var_2.size - var_1;

    if ( var_6 <= 0 )
        return;

    for ( var_7 = var_6 - 1; var_7 >= 0; var_7-- )
    {
        var_8 = var_2[var_7];
        var_8 thread scripts\cp_mp\killstreaks\airdrop::destroycrate();
    }
}

_id_127C5( var_0, var_1 )
{
    fail_mission_if_killed( self.team, 1 );
    var_2 = 4096;
    var_3 = scripts\engine\utility::getstruct( "soa_tower_elevator_floor_3", "targetname" );

    if ( istrue( self.risk_flagspawncountchange ) || isdefined( var_3 ) && distance2d( var_0, var_3.origin ) < 5000 )
        var_2 = 10000;

    var_4 = scripts\cp_mp\killstreaks\airdrop::dropbrloadoutcrate( self.team, var_0 + ( 0, 0, var_2 ), var_0 + ( 0, 0, 512 ) );
    var_4 endon( "death" );
    _id_12D3A( var_4 );
    enabledropbagobjective( var_4 );
    enter_laser_panel_anim_sequence( var_4 );
    var_5 = [];

    foreach ( var_7 in level.teamdata[self.team]["alivePlayers"] )
    {
        if ( isdefined( var_7 ) && !var_7 scripts\mp\gametypes\br_public.gsc::isplayeringulag() )
        {
            var_5[var_5.size] = var_7;
            var_7 thread scripts\mp\hud_message::showsplash( "br_airdrop_incoming" );
        }
    }

    if ( !scripts\mp\gametypes\br_public.gsc::scn_infil_tango_npc_4_sfx() )
        scripts\mp\gametypes\br_public.gsc::cpoperationcrateactivatecallback( "dropbag_incoming", self.team, 1 );

    if ( scripts\mp\utility\game::getgametype() == "br" )
    {
        scripts\mp\gametypes\br_analytics.gsc::cloned_collision( self, var_0, var_1, var_4 );
        thread play_spotrep_capture_sfx( var_4 );
    }
}

play_spotrep_capture_sfx( var_0 )
{
    var_0 endon( "death" );
    wait 1.0;
    var_1 = var_0 physics_getbodyid( 0 );

    while ( isdefined( var_0 ) )
    {
        var_2 = physics_getbodylinvel( var_1 );

        if ( abs( var_2[2] ) < 0.01 )
        {
            var_3 = [ var_0 ];
            var_4 = scripts\engine\trace::create_contents( 0, 1, 1, 1, 0, 0, 1 );
            var_5 = scripts\engine\trace::ray_trace( var_0.origin + ( 0, 0, 100 ), var_0.origin + ( 0, 0, -100 ), var_3, var_4 );

            if ( var_5["fraction"] == 1 )
                var_0 scripts\cp_mp\killstreaks\airdrop::gesture_checker( var_0.origin, ( 0, 0, -10 ) );
            else
                break;
        }

        wait 0.5;
    }
}

_id_127C6( var_0 )
{
    foreach ( var_2 in var_0 )
    {
        if ( !isdefined( var_2 ) )
            continue;

        var_3 = var_2._id_11B57;

        if ( isdefined( level.br_circle ) && isdefined( level.br_circle.safecircleent ) )
        {
            var_4 = scripts\mp\gametypes\br_circle.gsc::getsafecircleorigin();
            var_5 = scripts\mp\gametypes\br_circle.gsc::getsafecircleradius();

            if ( distance2dsquared( var_4, var_3 ) > var_5 * var_5 )
            {
                var_6 = vectornormalize( var_3 - var_4 );
                var_7 = var_4 + var_6 * var_5 * 0.95;

                if ( isscriptabledefined() )
                    var_3 = getclosestpointonnavmesh( var_7 );
                else
                    var_3 = var_7;
            }
            else if ( istrue( level._id_1311C ) && isscriptabledefined() )
                var_3 = getclosestpointonnavmesh( var_3 );

            if ( istrue( level._id_13103 ) )
                var_3 = obj_room_fire_03( var_3 );

            if ( scripts\mp\outofbounds::ispointinoutofbounds( var_3 ) )
            {
                var_4 = scripts\mp\gametypes\br_circle.gsc::getsafecircleorigin();
                var_7 = scripts\mp\gametypes\br_c130.gsc::_id_125F1( var_4, var_3 );

                if ( isscriptabledefined() )
                    var_3 = getclosestpointonnavmesh( var_7 );
                else
                    var_3 = var_7;
            }
        }

        var_8 = nearby_ai_investigate_grenade( 1, 0, 0, 0, 0 );
        var_2 _id_127C5( var_3, var_8 );
        waitframe();
    }
}

obj_room_fire_03( var_0 )
{
    if ( isdefined( level.init_oscilloscopes ) )
    {
        if ( !safehouse_hotjoin_func( var_0, level.init_oscilloscopes ) )
        {
            var_1 = mp_piccadilly_patch( var_0, level.init_oscilloscopes );

            if ( isdefined( var_1 ) )
                var_0 = var_1;
        }
    }

    return var_0;
}

safehouse_hotjoin_func( var_0, var_1 )
{
    foreach ( var_3 in var_1 )
    {
        if ( ispointinvolume( var_0, var_3 ) )
            return 1;
    }

    return 0;
}

mp_piccadilly_patch( var_0, var_1 )
{
    var_2 = undefined;
    var_3 = undefined;
    var_4 = ( var_0[0], var_0[1], 0 );

    foreach ( var_6 in var_1 )
    {
        var_7 = ( var_6.origin[0], var_6.origin[1], 0 );
        var_8 = var_4 - var_7;
        var_9 = var_6.radius / length( var_8 );
        var_8 = var_8 * var_9;
        var_10 = var_7 + var_8;
        var_11 = length( var_4 - var_10 );

        if ( !isdefined( var_3 ) || var_11 < var_3 )
        {
            var_2 = var_10;
            var_3 = var_11;
        }
    }

    if ( isdefined( var_2 ) )
        var_2 = ( var_2[0], var_2[1], var_0[2] );

    return var_2;
}

spawndropbagonlanding()
{
    var_0 = undefined;
    var_0 = findunuseddropbaglocation( self );

    if ( !isdefined( var_0 ) )
    {
        var_1 = getdvarfloat( "scr_dropbag_mindist", 3000 );
        var_2 = getdvarfloat( "scr_dropbag_maxdist", 7000 );
        var_0 = calculatedroplocationnearlocation( self, var_1, var_2 );
    }

    if ( isdefined( var_0 ) )
    {
        var_3 = nearby_ai_investigate_grenade( 0, 0, 0, 1, 0 );
        _id_127C5( var_0.origin, var_3 );
        level thread spawnpoint_clearspawnpoint();
    }
}

findunuseddropbaglocation( var_0 )
{
    var_1 = [];
    var_2 = getdvarfloat( "scr_dropbag_mindist", 3000 );
    var_3 = getdvarfloat( "scr_dropbag_maxdist", 7000 );
    var_4 = var_2 * var_2;
    var_5 = var_3 * var_3;

    foreach ( var_7 in level.dropbagstruct.clusters )
    {
        var_8 = distance2dsquared( var_0.origin, var_7.origin );

        if ( var_8 >= var_4 && var_8 <= var_5 )
            var_1[var_1.size] = var_7;
    }

    if ( var_1.size == 0 )
        return undefined;

    var_1 = scripts\engine\utility::array_randomize( var_1 );
    var_10 = 0;

    foreach ( var_7 in var_1 )
    {
        var_12 = scripts\engine\utility::array_randomize( var_7.droplocations );

        foreach ( var_14 in var_12 )
        {
            if ( !var_14.inuse )
            {
                var_14.inuse = 1;
                return var_14;
            }
        }
    }

    return undefined;
}

_id_12D3A( var_0 )
{
    level thread _id_12D3B( var_0, self );
}

_id_12D3B( var_0, var_1 )
{
    level endon( "game_ended" );
    var_0 endon( "death" );
    var_2 = var_1;
    var_3 = var_1.team;

    for (;;)
    {
        var_0 setotherent( var_2 );
        var_2 waittill( "disconnect" );
        var_4 = undefined;
        var_5 = level.teamdata[var_3]["players"];

        foreach ( var_1 in var_5 )
        {
            if ( isdefined( var_2 ) && var_2 == var_1 )
                continue;

            var_4 = var_1;
            break;
        }

        if ( !isdefined( var_4 ) )
            break;

        var_2 = var_4;
    }
}

enabledropbagobjective( var_0 )
{
    var_0 setscriptablepartstate( "objective", "active" );
}

enter_laser_panel_anim_sequence( var_0 )
{
    var_0 setscriptablepartstate( "model", "choose" );
}

grenade_exploded_during_stealth_listener( var_0 )
{
    level endon( "game_ended" );
    var_1 = 0;

    foreach ( var_3 in var_0 )
    {
        var_4 = var_3 - var_1;

        if ( var_4 > 0 )
            wait( var_4 );

        var_1 = var_3;
        _id_11B59( 0 );
    }
}

bnoself()
{
    if ( scripts\mp\gametypes\br_gametypes.gsc::roof_enemy_groups( "dropbag" ) )
        return;

    foreach ( var_1 in level.br_pickups.crates )
    {
        if ( !isdefined( var_1 ) || !isdefined( var_1.team ) || var_1.team != self.team )
            continue;

        var_2 = isdefined( var_1.playerscaptured ) && isdefined( var_1.playerscaptured[self getentitynumber()] );

        if ( var_2 )
        {
            var_1.playerscaptured[self getentitynumber()] = undefined;

            for ( var_3 = 0; var_3 < var_1.playersused.size; var_3++ )
            {
                if ( isdefined( var_1.playersused[var_3] ) && var_1.playersused[var_3] == self )
                    var_1.playersused[var_3] = undefined;
            }

            var_1.playersused = scripts\engine\utility::array_removeundefined( var_1.playersused );
            var_1.numuses--;
        }
    }
}

unset_relic_martyrdom()
{
    bnoself();
}

nearby_ai_investigate_grenade( var_0, var_1, var_2, var_3, var_4 )
{
    if ( istrue( var_0 ) )
        return 0;

    if ( istrue( var_1 ) )
        return 1;

    if ( istrue( var_2 ) )
        return 2;

    if ( istrue( var_3 ) )
        return 3;

    if ( istrue( var_4 ) )
        return 4;

    return -1;
}

testmissionrewards()
{
    runmissionrewarddelivery( level.players[0], level.players[0], undefined, 3 );
}

findclosestdroplocation( var_0 )
{
    var_1 = var_0 scripts\engine\utility::array_sort_with_func( level.dropbagstruct.clusters, ::sortlocationsbydistance );

    foreach ( var_3 in var_1 )
    {
        var_4 = scripts\engine\utility::array_randomize( var_3.droplocations );

        foreach ( var_6 in var_4 )
        {
            if ( !var_6.inuse )
            {
                var_6.inuse = 1;
                return var_6;
            }
        }
    }

    return undefined;
}

sortlocationsbydistance( var_0, var_1 )
{
    return distancesquared( var_0.origin, self.origin ) < distancesquared( var_1.origin, self.origin );
}

calculatedroplocationnearlocation( var_0, var_1, var_2 )
{
    var_3 = var_0.origin;
    var_4 = undefined;
    var_5 = undefined;
    var_6 = randomint( 2 );
    var_7 = scripts\engine\utility::ter_op( var_6, -1.0, 1.0 );

    if ( var_7 > 0 )
    {
        var_4 = randomfloatrange( var_3[0] + var_1 * var_7, var_3[0] + var_2 * var_7 );

        if ( var_4 >= level.br_level.br_mapbounds[0][0] )
            var_4 = level.br_level.br_mapbounds[0][0] - 250;
    }
    else
    {
        var_4 = randomfloatrange( var_3[0] + var_2 * var_7, var_3[0] + var_1 * var_7 );

        if ( var_4 <= level.br_level.br_mapbounds[1][0] )
            var_4 = level.br_level.br_mapbounds[1][0] + 250;
    }

    var_6 = randomint( 2 );
    var_7 = scripts\engine\utility::ter_op( var_6, -1.0, 1.0 );

    if ( var_7 > 0 )
    {
        var_5 = randomfloatrange( var_3[1] + var_1 * var_7, var_3[1] + var_2 * var_7 );

        if ( var_5 >= level.br_level.br_mapbounds[0][1] )
            var_5 = level.br_level.br_mapbounds[0][1] - 250;
    }
    else
    {
        var_5 = randomfloatrange( var_3[1] + var_2 * var_7, var_3[1] + var_1 * var_7 );

        if ( var_5 <= level.br_level.br_mapbounds[1][1] )
            var_5 = level.br_level.br_mapbounds[1][1] + 250;
    }

    if ( isscriptabledefined() )
    {
        var_8 = getclosestpointonnavmesh( ( var_4, var_5, var_3[2] ) );

        if ( isdefined( var_8 ) )
        {
            var_9 = spawnstruct();
            var_9.origin = var_8;
            return var_9;
        }
    }

    var_9 = spawnstruct();
    var_9.origin = ( var_4, var_5, var_3[2] );
    return var_9;
}

debugsphereonlocation( var_0 )
{

}

maskobjectivetoplayerssquad( var_0, var_1 )
{
    var_0.visibilitymanuallycontrolled = 1;
    objective_removeallfrommask( var_0.objidnum );

    foreach ( var_3 in level.squaddata[var_1.team][var_1.squadindex].players )
        objective_addclienttomask( var_0.objidnum, var_3 );
}
