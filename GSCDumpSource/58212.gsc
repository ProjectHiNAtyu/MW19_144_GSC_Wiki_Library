// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

_id_1318A()
{
    var_0 = spawnstruct();
    level.vehicle.collision = var_0;
    var_0.vehicledata = [];
    _id_1318B();
    _id_1317E();

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "vehicle_collision", "init" ) )
        [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "vehicle_collision", "init" ) ]]();

    thread _id_13190();
}

_id_13190()
{
    level endon( "game_ended" );
    var_0 = _id_13184();

    for (;;)
    {
        var_0.eventdata = [];
        var_0.eventid = 0;
        waitframe();
    }
}

_id_13191( var_0 )
{
    level endon( "game_ended" );

    if ( !isdefined( _id_13185( var_0.vehiclename, 0, 1 ) ) )
        return;

    var_0 notify( "vehicle_collision_updateInstance" );
    var_0 endon( "vehicle_collision_updateInstance" );
    var_0 vehphys_enablecollisioncallback( 1 );

    while ( isdefined( var_0 ) )
    {
        var_0 waittill( "collision", var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9 );
        _id_1318D( var_0, var_8, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_9 );
    }
}

_id_13192( var_0 )
{
    var_0 notify( "vehicle_collision_updateInstance" );
}

_id_13184()
{
    return level.vehicle.collision;
}

_id_13185( var_0, var_1, var_2 )
{
    var_3 = _id_13184();
    var_4 = var_3.vehicledata[var_0];

    if ( !isdefined( var_4 ) )
    {
        if ( istrue( var_1 ) )
        {
            var_4 = spawnstruct();
            var_3.vehicledata[var_0] = var_4;
            var_4.ref = var_0;
            var_4._id_11DE7 = undefined;
            var_4.play_train_speaker_vo_internal = undefined;
            var_4.bridge_one_death_func = 1;
            var_4.givebmodevloadouts = 1;
            var_4.getcombatrecordsupermisc = 0;
            var_4.getcoremapdropzones = 0;
            var_4.getcodecomputerdisplaycode = 0;
            var_4.getcrossbowammotype = 5;
            var_4.getcrossbowimpactfunc = 20;
            var_4.getcrateusetime = 40;
            var_4._id_125A3 = 0;
            var_4._id_125A4 = 0;
            var_4._id_125A2 = 0;
        }
        else if ( !istrue( var_2 ) )
        {

        }
    }

    return var_4;
}

_id_13182( var_0, var_1 )
{
    var_2 = _id_13184();
    var_3 = _id_13185( var_0.vehiclename, 0, 1 );

    if ( !isdefined( var_3 ) )
        return;

    var_4 = var_0 getentitynumber();
    var_5 = "none";

    if ( isdefined( var_1 ) && var_1 != var_0 && ( !isdefined( var_1.classname ) || var_1.classname != "worldspawn" ) )
        var_5 = var_1 getentitynumber();

    if ( !isdefined( var_2.eventdata[var_4] ) )
        var_2.eventdata[var_4] = [];

    var_6 = isdefined( var_1 ) && var_1 scripts\cp_mp\vehicles\vehicle::isvehicle() && isdefined( _id_13185( var_1.vehiclename, 0, 1 ) );
    var_7 = undefined;

    if ( isdefined( var_2.eventdata[var_4][var_5] ) )
        var_7 = var_2.eventdata[var_4][var_5];
    else if ( var_6 )
    {
        if ( !isdefined( var_2.eventdata[var_5] ) )
            var_2.eventdata[var_5] = [];

        if ( isdefined( var_2.eventdata[var_5][var_4] ) )
            var_7 = var_2.eventdata[var_5][var_4];
    }

    if ( !isdefined( var_7 ) )
    {
        var_7 = spawnstruct();
        var_2.eventdata[var_4][var_5] = var_7;

        if ( var_6 )
            var_2.eventdata[var_5][var_4] = var_7;

        var_7.id = var_2.eventid;
        var_2.eventid++;
        var_7.time = gettime();
        var_7.ent = [];
        var_7.cargo_truck_mg_initomnvars = [];
        var_7.body1 = [];
        var_7.lb_impulse_dmg_threshold_top = [];
        var_7.lb_mg_dmg_factor_driverless_collision = [];
        var_7.position = [];
        var_7.normal = [];
        var_7.trap_trigger_logic = [];
        var_7.vandalize_target_think = [];
        var_7.angles = [];
        var_7.velocity = [];
    }

    return var_7;
}

_id_1318D( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9 )
{
    if ( !isdefined( var_1 ) || var_1 == var_0 || isdefined( var_1.classname ) && var_1.classname == "worldspawn" )
        var_1 = undefined;

    var_10 = _id_13182( var_0, var_1 );

    if ( !isdefined( var_10 ) )
        return;

    level notify( "vehicle_collision_registerEvent_" + var_10.id );
    var_11 = undefined;

    foreach ( var_11, var_13 in var_10.ent )
    {
        if ( var_13 == var_0 )
            break;
    }

    if ( !isdefined( var_11 ) )
        var_11 = var_10.ent.size;

    var_10.ent[var_11] = var_0;
    var_10.cargo_truck_mg_initomnvars[var_11] = var_2;
    var_10.body1[var_11] = var_3;
    var_10.lb_impulse_dmg_threshold_top[var_11] = var_4;
    var_10.lb_mg_dmg_factor_driverless_collision[var_11] = var_5;
    var_10.position[var_11] = var_6;
    var_10.normal[var_11] = var_7;
    var_10.trap_trigger_logic[var_11] = var_8;
    var_10.vandalize_target_think[var_11] = var_9;
    var_10.angles[var_11] = var_0.angles;

    if ( !scripts\cp_mp\vehicles\vehicle_tracking::_issuspendedvehicle() )
        var_10.velocity[var_11] = var_0 vehicle_getvelocity();
    else
        var_10.velocity[var_11] = ( 0, 0, 0 );

    if ( var_10.ent.size == 1 )
        var_10.ent[1] = var_1;

    var_14 = _id_13185( var_0.vehiclename );

    if ( isdefined( var_14._id_11DE7 ) )
        [[ var_14._id_11DE7 ]]( var_10, var_11 );

    thread _id_1318E( var_10 );
}

_id_1318E( var_0 )
{
    level endon( "game_ended" );
    level endon( "vehicle_collision_registerEvent_" + var_0.id );
    waittillframeend;
    thread _id_13186( var_0 );
}

_id_13186( var_0 )
{
    _id_13187( var_0 );

    foreach ( var_4, var_2 in var_0.ent )
    {
        if ( !isdefined( var_2.vehiclename ) )
            continue;

        var_3 = _id_13185( var_2.vehiclename, 0, 1 );

        if ( !isdefined( var_3 ) )
            continue;

        if ( isdefined( var_3.play_train_speaker_vo_internal ) )
            [[ var_3.play_train_speaker_vo_internal ]]( var_0, var_4 );
    }
}

_id_13187( var_0 )
{
    var_1 = _id_13184();

    if ( var_1.tomastrike_isflyingkillstreak )
        return;

    if ( var_0.ent.size < 2 || var_0.velocity.size < 2 )
        return;

    var_2 = var_0.ent.size;
    var_0.aigroundturret_dismountcompleted = [];

    for ( var_3 = 0; var_3 < var_2; var_3++ )
        var_0.aigroundturret_dismountcompleted[var_3] = vectordot( var_0.velocity[var_3], var_0.normal[var_3] );

    var_0._id_11E15 = int( abs( var_0.aigroundturret_dismountcompleted[0] - var_0.aigroundturret_dismountcompleted[1] ) );

    for ( var_3 = 0; var_3 < var_2; var_3++ )
        var_0.aigroundturret_dismountcompleted[var_3] = int( abs( var_0.aigroundturret_dismountcompleted[var_3] ) );

    var_0.round_get_vehicles = [];
    _id_13183( var_0, 0, 1 );
    _id_13183( var_0, 1, 0 );
    _id_13180( var_0, 0, 1 );
    _id_13180( var_0, 1, 0 );
    _id_13181( var_0, 0, 1 );
    _id_13181( var_0, 1, 0 );
    _id_1318F( var_0, 0, 1 );
    _id_1318F( var_0, 1, 0 );
}

_id_13180( var_0, var_1, var_2, var_3 )
{
    if ( var_0.pressure_stability_event_init[var_1] )
        return;

    if ( !isdefined( var_0.getclosestplayerforreward ) )
        var_0.getclosestplayerforreward = [];

    var_4 = _id_13184();
    var_5 = var_0.ent[var_1].vehiclename;
    var_6 = var_0.ent[var_2].vehiclename;
    var_7 = _id_13185( var_5, 0, 1 );
    var_8 = _id_13185( var_6, 0, 1 );
    var_9 = istrue( var_0.round_get_vehicles[var_1] );
    var_10 = istrue( var_0.round_get_vehicles[var_2] );
    var_11 = var_0.aigroundturret_dismountcompleted[var_1];
    var_12 = var_0.aigroundturret_dismountcompleted[var_2];
    var_13 = undefined;

    if ( var_9 && var_4.playplundersoundbyamount && var_4.playjumpsoundtosquad >= 0 )
        var_13 = var_4.playjumpsoundtosquad;
    else if ( var_10 && var_4.playingsound && var_4.playerzombiewaittillinputreturn >= 0 )
        var_13 = var_4.playerzombiewaittillinputreturn;
    else
    {
        var_13 = var_8.bridge_one_death_func;

        if ( isdefined( var_4.bridge_one_death_func[var_5] ) && isdefined( var_4.bridge_one_death_func[var_5][var_6] ) )
            var_13 = var_4.bridge_one_death_func[var_5][var_6];
    }

    var_14 = undefined;

    if ( var_9 && var_4.playingsound && var_4.playingmolotovwickfx >= 0 )
        var_14 = var_4.playingmolotovwickfx;
    else if ( var_10 && var_4.playplundersoundbyamount && var_4.playplundersound >= 0 )
        var_14 = var_4.playplundersound;
    else
    {
        var_14 = var_7.givebmodevloadouts;

        if ( isdefined( var_4.givebmodevloadouts[var_5] ) && isdefined( var_4.givebmodevloadouts[var_5][var_6] ) )
            var_14 = var_4.givebmodevloadouts[var_5][var_6];
    }

    var_15 = var_0.ent[var_1];
    var_16 = var_0.ent[var_2];

    if ( isdefined( var_16.too_far_dist ) )
        var_13 = var_13 * var_16.too_far_dist;

    if ( isdefined( var_15.top_roof_enemy_watcher ) )
        var_14 = var_14 * var_15.top_roof_enemy_watcher;

    var_0.getclosestplayerforreward[var_1] = var_12 / ( var_11 + var_12 ) * var_0._id_11E15 * var_13 * var_14;
}

_id_13181( var_0, var_1, var_2 )
{
    if ( var_0.pressure_stability_event_init[var_1] )
        return;

    var_3 = var_0.getclosestplayerforreward[var_1];

    if ( !isdefined( var_0.getcpscriptedhelidropheight ) )
    {
        var_0.getcpscriptedhelidropheight = [];
        var_0._id_1259F = [];
    }

    if ( var_3 > 0 )
    {
        var_4 = _id_13184();
        var_5 = var_0.ent[var_1].vehiclename;
        var_6 = var_0.ent[var_2].vehiclename;
        var_7 = _id_13185( var_5, 0, 1 );
        var_8 = _id_13185( var_6, 0, 1 );
        var_9 = istrue( var_0.round_get_vehicles[var_1] );
        var_10 = istrue( var_0.round_get_vehicles[var_2] );
        var_11 = undefined;

        if ( var_9 && var_4.playingsound && var_4.playgotinfectedsoundcount >= 0 )
            var_11 = var_4.playgotinfectedsoundcount;
        else if ( var_10 && var_4.playplundersoundbyamount && var_4.playkillstreakdeploydialog >= 0 )
            var_11 = var_4.playkillstreakdeploydialog;
        else
        {
            var_11 = var_7.getcodecomputerdisplaycode;

            if ( isdefined( var_4.getcodecomputerdisplaycode[var_6] ) && isdefined( var_4.getcodecomputerdisplaycode[var_6][var_5] ) )
                var_11 = var_4.getcodecomputerdisplaycode[var_6][var_5];
        }

        if ( var_11 > 0 && var_3 >= var_11 )
        {
            var_0.getcpscriptedhelidropheight[var_1] = 0;

            if ( var_9 && var_4.playingsound && var_4.playing_stealth_alert_music >= 0 )
                var_0.getcpscriptedhelidropheight[var_1] = var_4.playing_stealth_alert_music;
            else if ( var_10 && var_4.playplundersoundbyamount && var_4.playmatchendcamera >= 0 )
                var_0.getcpscriptedhelidropheight[var_1] = var_4.playmatchendcamera;
            else
            {
                var_0.getcpscriptedhelidropheight[var_1] = var_7.getcrateusetime;

                if ( isdefined( var_4.getcrateusetime[var_6] ) && isdefined( var_4.getcrateusetime[var_6][var_5] ) )
                    var_0.getcpscriptedhelidropheight[var_1] = var_4.getcrateusetime[var_6][var_5];
            }

            if ( var_0.getcpscriptedhelidropheight[var_1] > 0 )
            {
                if ( var_9 && var_4.playingsound && var_4.playingthrowingknifewickfx >= 0 )
                    var_0._id_1259F[var_1] = var_4.playingthrowingknifewickfx > 0;
                else if ( var_10 && var_4.playplundersoundbyamount && var_4.playscorestatusdialog >= 0 )
                    var_0._id_1259F[var_1] = var_4.playscorestatusdialog > 0;
                else
                {
                    var_0._id_1259F[var_1] = var_7._id_125A2;

                    if ( isdefined( var_4._id_125A2[var_6] ) && isdefined( var_4._id_125A2[var_6][var_5] ) )
                        var_0._id_1259F[var_1] = var_4._id_125A2[var_6][var_5];
                }

                return;
            }
        }

        var_11 = undefined;

        if ( var_9 && var_4.playingsound && var_4.playing_bomb_counter_beep >= 0 )
            var_11 = var_4.playing_bomb_counter_beep;
        else if ( var_10 && var_4.playplundersoundbyamount && var_4.playlinkfx >= 0 )
            var_11 = var_4.playlinkfx;
        else
        {
            var_11 = var_7.getcoremapdropzones;

            if ( isdefined( var_4.getcoremapdropzones[var_6] ) && isdefined( var_4.getcoremapdropzones[var_6][var_5] ) )
                var_11 = var_4.getcoremapdropzones[var_6][var_5];
        }

        if ( var_11 > 0 && var_3 >= var_11 )
        {
            var_0.getcpscriptedhelidropheight[var_1] = 0;

            if ( var_9 && var_4.playingsound && var_4.playinggulagbink >= 0 )
                var_0.getcpscriptedhelidropheight[var_1] = var_4.playinggulagbink;
            else if ( var_10 && var_4.playplundersoundbyamount && var_4.playoverwatch_dialogue_with_endon >= 0 )
                var_0.getcpscriptedhelidropheight[var_1] = var_4.playoverwatch_dialogue_with_endon;
            else
            {
                var_0.getcpscriptedhelidropheight[var_1] = var_7.getcrossbowimpactfunc;

                if ( isdefined( var_4.getcrossbowimpactfunc[var_6] ) && isdefined( var_4.getcrossbowimpactfunc[var_6][var_5] ) )
                    var_12 = var_4.getcrossbowimpactfunc[var_6][var_5];
            }

            if ( var_0.getcpscriptedhelidropheight[var_1] > 0 )
            {
                if ( var_9 && var_4.playingsound && var_4.playjailbreakvo >= 0 )
                    var_0._id_1259F[var_1] = var_4.playjailbreakvo > 0;
                else if ( var_10 && var_4.playplundersoundbyamount && var_4.playtutsound >= 0 )
                    var_0._id_1259F[var_1] = var_4.playtutsound > 0;
                else
                {
                    var_0._id_1259F[var_1] = var_7._id_125A4;

                    if ( isdefined( var_4._id_125A4[var_6] ) && isdefined( var_4._id_125A4[var_6][var_5] ) )
                        var_0._id_1259F[var_1] = var_4._id_125A4[var_6][var_5];
                }

                return;
            }
        }

        var_11 = undefined;

        if ( var_9 && var_4.playingsound && var_4.playimpactfx >= 0 )
            var_11 = var_4.playimpactfx;
        else if ( var_10 && var_4.playplundersoundbyamount && var_4.playlandingbreath >= 0 )
            var_11 = var_4.playlandingbreath;
        else
        {
            var_11 = var_7.getcombatrecordsupermisc;

            if ( isdefined( var_4.getcombatrecordsupermisc[var_6] ) && isdefined( var_4.getcombatrecordsupermisc[var_6][var_5] ) )
                var_11 = var_4.getcombatrecordsupermisc[var_6][var_5];

            if ( var_11 > 0 && var_3 >= var_11 )
            {
                var_0.getcpscriptedhelidropheight[var_1] = 0;

                if ( var_9 && var_4.playingsound && var_4.playingcoughdamagesound >= 0 )
                    var_0.getcpscriptedhelidropheight[var_1] = var_4.playingcoughdamagesound;
                else if ( var_10 && var_4.playplundersoundbyamount && var_4.playoverwatch_dialogue >= 0 )
                    var_0.getcpscriptedhelidropheight[var_1] = var_4.playoverwatch_dialogue;
                else
                {
                    var_0.getcpscriptedhelidropheight[var_1] = var_7.getcrossbowammotype;

                    if ( isdefined( var_4.getcrossbowammotype[var_6] ) && isdefined( var_4.getcrossbowammotype[var_6][var_5] ) )
                        var_13 = var_4.getcrossbowammotype[var_6][var_5];
                }

                if ( var_0.getcpscriptedhelidropheight[var_1] > 0 )
                {
                    if ( var_9 && var_4.playingsound && var_4.playingtutorialdialogue >= 0 )
                        var_0._id_1259F[var_1] = var_4.playingtutorialdialogue > 0;
                    else if ( var_10 && var_4.playplundersoundbyamount && var_4.playslamzoomflashcolor >= 0 )
                        var_0._id_1259F[var_1] = var_4.playslamzoomflashcolor > 0;
                    else
                    {
                        var_0._id_1259F[var_1] = var_7._id_125A3;

                        if ( isdefined( var_4._id_125A3[var_6] ) && isdefined( var_4._id_125A3[var_6][var_5] ) )
                            var_0._id_125A3[var_1] = var_4._id_125A3[var_6][var_5];
                    }

                    return;
                }
            }
        }
    }

    var_0.getcpscriptedhelidropheight[var_1] = 0;
    var_0._id_1259F[var_1] = 0;
}

_id_1318F( var_0, var_1, var_2 )
{
    if ( var_0.pressure_stability_event_init[var_1] )
        return;

    if ( var_0.getcpscriptedhelidropheight[var_1] <= 0 )
        return;

    var_3 = var_0.ent[var_1];
    var_4 = var_0.ent[var_2];
    var_5 = var_3.maxhealth * var_0.getcpscriptedhelidropheight[var_1] / 100;
    var_6 = var_0.ent[var_1].health;

    if ( var_0._id_1259F[var_1] )
        var_3 scripts\cp_mp\vehicles\vehicle_damage::_id_131B9( 1 );

    if ( isdefined( var_3 ) && isdefined( var_4 ) )
        var_3 dodamage( var_5, var_0.position[var_1], undefined, var_4, "MOD_CRUSH", var_4.objweapon );

    if ( isdefined( var_3 ) )
    {
        if ( var_0._id_1259F[var_1] )
            var_3 scripts\cp_mp\vehicles\vehicle_damage::_id_131B9( 0 );

        if ( var_3.health < var_6 )
            thread _id_13189( var_3, var_4, 1.5 );
    }
}

_id_13189( var_0, var_1, var_2 )
{
    if ( !isdefined( var_0._id_13176 ) )
        var_0._id_13176 = [];

    var_3 = var_1 getentitynumber();
    var_0._id_13176[var_3] = var_1;
    wait( var_2 );

    if ( isdefined( var_0 ) && isdefined( var_0._id_13176 ) )
    {
        var_0._id_13176[var_3] = undefined;

        if ( var_0._id_13176.size == 0 )
            var_0._id_13176 = undefined;
    }
}

_id_13183( var_0, var_1, var_2 )
{
    if ( !isdefined( var_0.pressure_stability_event_init ) )
        var_0.pressure_stability_event_init = [];

    if ( var_0._id_11E15 < 100 )
    {
        var_0.pressure_stability_event_init[var_1] = 1;
        return;
    }

    var_3 = var_0.ent[var_1];

    if ( isdefined( var_3._id_13176 ) && isdefined( var_0.ent[var_2] ) && isdefined( var_3._id_13176[var_0.ent[var_2] getentitynumber()] ) )
    {
        var_0.pressure_stability_event_init[var_1] = 1;
        return;
    }

    var_0.pressure_stability_event_init[var_1] = 0;
}

_id_1317E()
{
    _id_1317F();
}

_id_1317F()
{
    var_0 = _id_13184();
    var_0.tomastrike_isflyingkillstreak = getdvarint( "scr_vehColDisableMulti", 0 ) > 0;
    var_0.tomastrike_getrandombombingpoint = getdvarint( "scr_vehColDebugMulti", 0 ) > 0;
    var_0.playingsound = getdvarint( "scr_vehColHost", 0 ) > 0;
    var_0.playerzombiewaittillinputreturn = getdvarfloat( "scr_vehColHost_attackFactorMod", -1 );
    var_0.playingmolotovwickfx = getdvarfloat( "scr_vehColHost_defenseFactorMod", -1 );
    var_0.playimpactfx = getdvarint( "scr_vehColHost_damageFactorLow", -1 );
    var_0.playing_bomb_counter_beep = getdvarint( "scr_vehColHost_damageFactorMedium", -1 );
    var_0.playgotinfectedsoundcount = getdvarint( "scr_vehColHost_damageFactorHigh", -1 );
    var_0.playingcoughdamagesound = getdvarint( "scr_vehColHost_damagePercentLow", -1 );
    var_0.playinggulagbink = getdvarint( "scr_vehColHost_damagePercentMedium", -1 );
    var_0.playing_stealth_alert_music = getdvarint( "scr_vehColHost_damagePercentHigh", -1 );
    var_0.playingtutorialdialogue = getdvarint( "scr_vehColHost_skipBurnDownLow", -1 );
    var_0.playjailbreakvo = getdvarint( "scr_vehColHost_skipBurnDownMedium", -1 );
    var_0.playingthrowingknifewickfx = getdvarint( "scr_vehColHost_skipBurnDownHigh", -1 );
    var_0.playplundersoundbyamount = getdvarint( "scr_vehColHostVictim", 0 ) > 0;
    var_0.playjumpsoundtosquad = getdvarfloat( "scr_vehColHostVictim_attackFactorMod", -1 );
    var_0.playplundersound = getdvarfloat( "scr_vehColHostVictim_defenseFactorMod", -1 );
    var_0.playlandingbreath = getdvarint( "scr_vehColHostVictim_damageFactorLow", -1 );
    var_0.playlinkfx = getdvarint( "scr_vehColHostVictim_damageFactorMedium", -1 );
    var_0.playkillstreakdeploydialog = getdvarint( "scr_vehColHostVictim_damageFactorHigh", -1 );
    var_0.playoverwatch_dialogue = getdvarint( "scr_vehColHostVictim_damagePercentLow", -1 );
    var_0.playoverwatch_dialogue_with_endon = getdvarint( "scr_vehColHostVictim_damagePercentMedium", -1 );
    var_0.playmatchendcamera = getdvarint( "scr_vehColHostVictim_damagePercentHigh", -1 );
    var_0.playslamzoomflashcolor = getdvarint( "scr_vehColHostVictim_skipBurnDownLow", -1 );
    var_0.playtutsound = getdvarint( "scr_vehColHostVictim_skipBurnDownMedium", -1 );
    var_0.playscorestatusdialog = getdvarint( "scr_vehColHostVictim_skipBurnDownHigh", -1 );
}

_id_1318B()
{
    var_0 = _id_13184();
    var_1 = spawnstruct();
    var_0.bridge_one_death_func = [];
    var_0.givebmodevloadouts = [];
    var_0.getcombatrecordsupermisc = [];
    var_0.getcoremapdropzones = [];
    var_0.getcodecomputerdisplaycode = [];
    var_0.getcrossbowammotype = [];
    var_0.getcrossbowimpactfunc = [];
    var_0.getcrateusetime = [];
    var_0._id_125A3 = [];
    var_0._id_125A4 = [];
    var_0._id_125A2 = [];
    var_2 = [];
    var_3 = [];
    var_3["attackFactorMod"] = [];
    var_3["defenseFactorMod"] = [];
    var_3["damageFactorLow"] = [];
    var_3["damageFactorMedium"] = [];
    var_3["damageFactorHigh"] = [];
    var_3["damagePercentLow"] = [];
    var_3["damagePercentMedium"] = [];
    var_3["damagePercentHigh"] = [];
    var_3["skipBurnDownLow"] = [];
    var_3["skipBurnDownMedium"] = [];
    var_3["skipBurnDownHigh"] = [];
    var_4 = tablelookupgetnumcols( "mp_cp/vehicleCollisionTable.csv" );

    for ( var_5 = 1; var_5 < var_4; var_5++ )
    {
        var_6 = tablelookupbyrow( "mp_cp/vehicleCollisionTable.csv", 0, var_5 );

        if ( isdefined( var_6 ) && var_6 != "" )
        {
            if ( getsubstr( var_6, 0, 1 ) != "*" )
                var_2[var_6] = var_5;
        }
    }

    var_7 = undefined;
    var_8 = 0;
    var_9 = tablelookupgetnumrows( "mp_cp/vehicleCollisionTable.csv" );

    for ( var_8 = 0; var_8 < var_9; var_8++ )
    {
        var_10 = tablelookupbyrow( "mp_cp/vehicleCollisionTable.csv", var_8, 1 );

        if ( isdefined( var_10 ) && var_10 != "" )
        {
            if ( getsubstr( var_10, 0, 1 ) == "*" )
            {
                var_7 = getsubstr( var_10, 1, var_10.size );
                continue;
            }

            if ( isdefined( var_3[var_7] ) )
                var_3[var_7][var_10] = var_8;
        }
    }

    foreach ( var_7, var_12 in var_3 )
    {
        foreach ( var_10, var_14 in var_12 )
        {
            foreach ( var_6, var_16 in var_2 )
            {
                var_17 = tablelookup( "mp_cp/vehicleCollisionTable.csv", 0, var_14, var_16 );

                if ( isdefined( var_17 ) && var_17 != "" )
                    _id_1318C( var_17, var_10, var_7, var_6 );
            }
        }
    }
}

_id_1318C( var_0, var_1, var_2, var_3 )
{
    var_4 = _id_13184();

    if ( var_2 == "attackFactorMod" )
    {
        var_5 = float( var_0 );

        if ( !isdefined( var_4.bridge_one_death_func[var_1] ) )
            var_4.bridge_one_death_func[var_1] = [];

        var_4.bridge_one_death_func[var_1][var_3] = var_5;
    }
    else if ( var_2 == "defenseFactorMod" )
    {
        var_5 = float( var_0 );

        if ( !isdefined( var_4.givebmodevloadouts[var_1] ) )
            var_4.givebmodevloadouts[var_1] = [];

        var_4.givebmodevloadouts[var_1][var_3] = var_5;
    }
    else if ( var_2 == "damageFactorLow" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4.getcombatrecordsupermisc[var_1] ) )
            var_4.getcombatrecordsupermisc[var_1] = [];

        var_4.getcombatrecordsupermisc[var_1][var_3] = var_5;
    }
    else if ( var_2 == "damageFactorMedium" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4.getcoremapdropzones[var_1] ) )
            var_4.getcoremapdropzones[var_1] = [];

        var_4.getcoremapdropzones[var_1][var_3] = var_5;
    }
    else if ( var_2 == "damageFactorHigh" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4.getcodecomputerdisplaycode[var_1] ) )
            var_4.getcodecomputerdisplaycode[var_1] = [];

        var_4.getcodecomputerdisplaycode[var_1][var_3] = var_5;
    }
    else if ( var_2 == "damagePercentLow" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4.getcrossbowammotype[var_1] ) )
            var_4.getcrossbowammotype[var_1] = [];

        var_4.getcrossbowammotype[var_1][var_3] = var_5;
    }
    else if ( var_2 == "damagePercentMedium" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4.getcrossbowimpactfunc[var_1] ) )
            var_4.getcrossbowimpactfunc[var_1] = [];

        var_4.getcrossbowimpactfunc[var_1][var_3] = var_5;
    }
    else if ( var_2 == "damagePercentHigh" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4.getcrateusetime[var_1] ) )
            var_4.getcrateusetime[var_1] = [];

        var_4.getcrateusetime[var_1][var_3] = var_5;
    }
    else if ( var_2 == "skipBurnDownLow" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4._id_125A3[var_1] ) )
            var_4._id_125A3[var_1] = [];

        var_4._id_125A3[var_1][var_3] = var_5 > 0;
    }
    else if ( var_2 == "skipBurnDownMedium" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4._id_125A4[var_1] ) )
            var_4._id_125A4[var_1] = [];

        var_4._id_125A4[var_1][var_3] = var_5 > 0;
    }
    else if ( var_2 == "skipBurnDownHigh" )
    {
        var_5 = int( var_0 );

        if ( !isdefined( var_4._id_125A2[var_1] ) )
            var_4._id_125A2[var_1] = [];

        var_4._id_125A2[var_1][var_3] = var_5 > 0;
    }
}
