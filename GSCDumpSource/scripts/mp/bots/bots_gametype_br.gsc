// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

main()
{
    if ( scripts\mp\utility\game::onfieldupgradeendbuffer() == "dmz" && scripts\mp\gametypes\br_public.gsc::risk_flagspawnradiuschange() )
        [[ level.holoeffect ]]();
    else
    {
        setup_callbacks();
        setup_bot_br();
    }
}

setup_callbacks()
{
    level.bot_funcs["gametype_think"] = ::bot_br_think;
}

setup_bot_br()
{
    setdvarifuninitialized( "br_infil_bot_solojump_chance", 0.25 );
}

bot_br_think()
{
    self notify( "bot_br_think" );
    self endon( "bot_br_think" );
    self endon( "death_or_disconnect" );
    level endon( "game_ended" );
    var_0 = randomfloat( 1 ) < getdvarfloat( "br_infil_bot_solojump_chance", 0.0 );
    thread bomber_spawn_origin_array_init();
    self botsetflag( "ignore_nodes", 1 );

    for (;;)
    {
        if ( scripts\mp\gametypes\br_public.gsc::revive_or_disconnect_monitor() && !scripts\mp\flags::gameflag( "graceperiod_done" ) )
        {
            self.ignoreall = 0;
            wait 0.05;
            continue;
        }

        if ( isdefined( self.br_infil_type ) )
        {
            if ( scripts\mp\gametypes\br_public.gsc::revive_or_disconnect_monitor() && !isdefined( self.propcleanup ) )
            {
                self.ignoreall = 1;
                self botclearscriptgoal();
            }

            self botsetflag( "disable_all_ai", 1 );

            if ( ( scripts\mp\gametypes\br_public.gsc::runbrgametypefunc6() || var_0 ) && istrue( level.c130inbounds ) )
            {
                var_1 = level.br_ac130.origin;
                var_2 = vectornormalize( level.infilstruct.c130pathstruct.endpt - var_1 );
                var_3 = ( level.br_level.br_mapbounds[0][0] - var_1[0] ) / var_2[0];
                var_4 = ( level.br_level.br_mapbounds[0][1] - var_1[0] ) / var_2[0];
                var_5 = ( level.br_level.br_mapbounds[0][1] - var_1[1] ) / var_2[1];
                var_6 = ( level.br_level.br_mapbounds[1][1] - var_1[1] ) / var_2[1];
                var_7 = [ var_3, var_4, var_5, var_6 ];
                var_8 = -1;

                foreach ( var_10 in var_7 )
                {
                    if ( var_10 > 0 )
                    {
                        if ( var_8 < 0 || var_10 < var_8 )
                            var_8 = var_10;
                    }
                }

                var_12 = var_1 + var_2 * var_8;
                var_13 = scripts\mp\gametypes\br_c130.gsc::getc130speed();
                var_14 = var_8 / var_13;
                var_15 = randomfloatrange( 0.1, 0.9 ) * var_14;
                wait( var_15 );

                if ( scripts\mp\gametypes\br_public.gsc::runbrgametypefunc6() )
                    self notify( "halo_jump_c130" );
                else
                    self notify( "halo_jump_solo_c130" );

                self.gulaguses = 1;

                if ( getdvarint( "scr_bot_allow_gulag", 1 ) > 0 )
                    self.gulaguses = 0;

                self.select_patrol_four_spawners = 1;

                while ( isdefined( self.br_infil_type ) )
                    wait 0.05;
            }

            wait 0.05;
            continue;
        }

        if ( scripts\mp\gametypes\br_public.gsc::rungwperif_flak() )
        {
            thread cheeselocs();
            scripts\engine\utility::_id_133EF( "death_or_disconnect", "gulag_end" );
            wait 3;
        }
        else
            self botclearscriptenemy();

        if ( isdefined( level.br_circle ) && isscriptabledefined() )
        {
            var_16 = undefined;
            var_17 = self bothasscriptgoal();

            if ( var_17 )
                var_16 = self botgetscriptgoal();

            if ( !scripts\mp\bots\bots_strategy::bot_has_tactical_goal() && !scripts\mp\bots\bots_util::bot_is_remote_or_linked() )
            {
                if ( ( istrue( self isskydiving() ) || istrue( self isparachuting() ) ) && istrue( self.select_patrol_four_spawners ) && istrue( scripts\mp\gametypes\br_public.gsc::revive_or_disconnect_monitor() ) )
                {
                    self botsetflag( "disable_all_ai", 0 );
                    self botclearscriptgoal();
                    chopper_boss_fight_stage_trigger_think();
                }

                if ( scripts\mp\gametypes\br_public.gsc::revive_or_disconnect_monitor() && !isdefined( self.propcleanup ) )
                {
                    self.ignoreall = 1;
                    wait 1;
                    continue;
                }

                var_18 = self botpathexists();
                var_19 = !var_17 || !var_18 || !scripts\mp\gametypes\br_circle.gsc::ispointincurrentsafecircle( var_16 );

                if ( var_17 )
                {
                    var_20 = distancesquared( self.origin, var_16 );
                    var_21 = self botgetscriptgoalradius();
                    var_22 = var_20 < var_21 * var_21;

                    if ( !var_22 )
                        self.lasttimereachedscriptgoal = undefined;
                    else if ( !isdefined( self.lasttimereachedscriptgoal ) )
                        self.lasttimereachedscriptgoal = gettime();
                }

                var_23 = level.bot_personality_type[self.personality] == "stationary";

                if ( isdefined( self.lasttimereachedscriptgoal ) )
                {
                    var_24 = 0;

                    if ( var_23 )
                        var_24 = 20000;

                    var_19 = var_19 || gettime() - self.lasttimereachedscriptgoal >= var_24;
                }

                if ( var_19 )
                {
                    var_25 = scripts\mp\gametypes\br_circle.gsc::getrandompointincurrentcircle();
                    var_26 = self getclosestreachablepointonnavmesh( var_25 );

                    if ( isdefined( var_26 ) )
                    {
                        self botsetscriptgoal( var_26, 1024, "hunt", undefined, undefined, !var_23 );
                        self.lasttimereachedscriptgoal = gettime();
                    }
                }
            }
        }
        else
            scripts\mp\bots\bots_personality::update_personality_default();

        wait 0.05;
    }
}

chopper_boss_fight_stage_trigger_think()
{
    self endon( "death_or_disconnect" );
    self.ignoreall = 1;
    self.handlepersistentgungame = checkreload();
    var_0 = gettime() + randomfloatrange( 5, 10 ) * 1000;
    var_1 = 0;

    while ( istrue( self isskydiving() ) || istrue( self isparachuting() ) )
    {
        if ( level.br_circle.circleindex > 0 && istrue( level.extract_dialogue_played ) && !scripts\mp\gametypes\br_circle.gsc::ispointincurrentsafecircle( self.handlepersistentgungame ) )
            self.handlepersistentgungame = checkreload();

        var_2 = checkpoints_count( self, self.handlepersistentgungame );
        var_3 = 1;
        self botlookatpoint( self.handlepersistentgungame, 0.05, "script_forced" );
        self botsetscriptmove( var_2[1], 0.05, var_3 );

        if ( gettime() > var_0 && !var_1 )
        {
            self botpressbutton( "jump", 1 );
            var_1 = 1;
        }

        wait 0.05;
    }

    self.propcleanup = 1;
    self botlookatpoint( undefined );
    self.ignoreall = 0;
    cheese();
}

checkreload( var_0 )
{
    if ( !isdefined( level.little_bird_mg_mp_ondeathrespawncallback ) || level.little_bird_mg_mp_ondeathrespawncallback.size < 1 )
    {
        level.little_bird_mg_mp_ondeathrespawncallback = mine_caves_end_support_internal();
        level.little_bird_mg_mp_ondeathrespawncallback = scripts\engine\utility::array_randomize( level.little_bird_mg_mp_ondeathrespawncallback );
    }

    if ( isdefined( level.br_circle ) && isscriptabledefined() )
    {
        var_1 = scripts\engine\utility::random( level.little_bird_mg_mp_ondeathrespawncallback );

        if ( isdefined( var_1 ) )
        {
            var_2 = var_1.origin;
            level.little_bird_mg_mp_ondeathrespawncallback = scripts\engine\utility::array_remove( level.little_bird_mg_mp_ondeathrespawncallback, var_1 );
        }
        else
            var_2 = scripts\mp\gametypes\br_circle.gsc::getrandompointincurrentcircle();

        return getclosestpointonnavmesh( var_2, self );
    }

    return undefined;
}

mine_caves_end_support_internal()
{
    var_0 = scripts\mp\gametypes\br_circle.gsc::getdangercircleradius();
    var_1 = scripts\mp\gametypes\br_circle.gsc::getdangercircleorigin();
    return scripts\engine\utility::get_array_of_closest( var_1, level.choosefinalkillcam, undefined, undefined, var_0 );
}

checkpoints_count( var_0, var_1 )
{
    var_2 = vectornormalize( var_1 - var_0.origin );
    return vectortoangles( var_2 );
}

checkpoints_init( var_0, var_1 )
{
    return distance( var_0.origin, var_1 );
}

checkyellowmassacre()
{
    if ( !isdefined( level.checkcarpuncherprogressgeneric ) )
        level.checkcarpuncherprogressgeneric = [ "iw8_sm_papa90_mp", "iw8_sh_charlie725_mp", "iw8_ar_akilo47_mp+acog", "iw8_lm_mgolf34_mp", "iw8_sn_kilo98_mp+scope", "iw8_sm_beta_mp+reflexmini2", "iw8_sm_augolf_mp+acog", "iw8_sm_mpapa7_mp+acog", "iw8_ar_falima_mp+reflexmini", "iw8_ar_kilo433_mp+acog", "iw8_ar_scharlie_mp+reflexmini2", "iw8_lm_lima86_mp+acog" ];

    var_0 = scripts\engine\utility::random( level.checkcarpuncherprogressgeneric );

    switch ( var_0 )
    {
        case "iw8_sh_charlie725_mp":
            if ( !isdefined( level.chopper_glow_sticks ) )
                level.chopper_glow_sticks = 0;

            level.chopper_glow_sticks++;

            if ( level.chopper_glow_sticks >= 1 )
                level.checkcarpuncherprogressgeneric = scripts\engine\utility::array_remove( level.checkcarpuncherprogressgeneric, "iw8_sh_charlie725_mp" );

            break;
        case "iw8_sn_kilo98_mp+scope":
            if ( !isdefined( level.chopper_gunner_assignedtargetmarkers_onnewai ) )
                level.chopper_gunner_assignedtargetmarkers_onnewai = 0;

            level.chopper_gunner_assignedtargetmarkers_onnewai++;

            if ( level.chopper_gunner_assignedtargetmarkers_onnewai >= 1 )
                level.checkcarpuncherprogressgeneric = scripts\engine\utility::array_remove( level.checkcarpuncherprogressgeneric, "iw8_sn_kilo98_mp+scope" );

            break;
    }

    var_1 = [[ level.fnbuildweapon ]]( [[ level.fngetweaponrootname ]]( var_0 ), [], "none", "none", -1 );
    self giveweapon( var_1 );
    self setweaponammoclip( var_1, weaponclipsize( var_1 ) );
    self setweaponammostock( var_1, weaponclipsize( var_1 ) );
    self switchtoweapon( "none" );
}

cheese()
{
    self switchtoweapon( "none" );
    var_0 = maxbetarank();

    if ( !isdefined( var_0 ) )
    {
        var_0 = spawnstruct();
        var_0.origin = old_getspawnpoint();
    }

    var_0.claimed = 1;
    var_1 = level.bot_personality_type[self.personality] == "stationary";
    self botsetscriptgoal( self getclosestreachablepointonnavmesh( var_0.origin ), 256, "guard", undefined, undefined, !var_1 );
    scripts\engine\utility::_id_133EF( "goal", "last_stand_start" );
    var_0.claimed = undefined;

    if ( !istrue( self.inlaststand ) )
        checkyellowmassacre();

    checkcodeentered();
}

maxbetarank()
{
    var_0 = maxcastsperframe();
    var_0 = sortbydistance( var_0, self.origin );
    var_1 = matchdata_logplayerlife( var_0 );

    if ( !isdefined( var_1 ) )
        var_1 = matchdata_logaward( var_0 );

    return var_1;
}

maxcastsperframe()
{
    var_0 = scripts\mp\gametypes\br_circle.gsc::getdangercircleradius();
    var_1 = scripts\mp\gametypes\br_circle.gsc::getdangercircleorigin();
    var_2 = scripts\engine\utility::get_array_of_closest( var_1, level.checkpoint_create_carepackage_munitions, undefined, undefined, var_0 );
    return var_2;
}

matchdata_logplayerlife( var_0 )
{
    foreach ( var_2 in var_0 )
    {
        if ( !istrue( var_2.claimed ) )
            return var_2;
    }

    return undefined;
}

matchdata_logaward( var_0 )
{
    return scripts\engine\utility::getclosest( self.origin, var_0 );
}

init_death_animations()
{
    self endon( "death_or_disconnect" );

    for (;;)
        wait 0.05;
}

checkcodeentered()
{
    var_0 = level.bot_personality_type[self.personality] == "stationary";
    var_1 = 0;

    for (;;)
    {
        var_2 = oil_puddles();
        var_1 = chooseanim_arrival_forcode() || istrue( level.extract_dialogue_played );

        if ( var_1 )
            var_2 = old_getspawnpoint();

        if ( isdefined( var_2 ) )
        {
            var_3 = checksolospawnselections();

            if ( istrue( level.chopperexfil_sh020_start ) && isdefined( var_3 ) && !var_1 )
            {
                thread _id_13054();
                self getenemyinfo( var_3 );

                if ( self botgetpersonality() != "run_and_gun" )
                    scripts\mp\bots\bots_util::bot_set_personality( "run_and_gun" );

                if ( self bothasscriptgoal() )
                    self botclearscriptgoal();

                if ( !isdefined( self.watch_for_player_entered_trap_room ) )
                {
                    self botsetscriptenemy( var_3 );
                    self.watch_for_player_entered_trap_room = var_3;
                }
            }
            else
            {
                self.watch_for_player_entered_trap_room = undefined;
                self notify( "update_on_death" );

                if ( self bothasscriptgoal() )
                    self botclearscriptgoal();

                self botclearscriptenemy();

                if ( var_1 )
                    self botsetscriptgoal( var_2, 128, "critical", undefined, undefined, 0 );
                else
                    self botsetscriptgoal( var_2, 400, "guard", undefined, undefined, 0 );

                if ( istrue( var_1 ) )
                    var_1 = 0;

                thread vehicle_collision_getleveldataforvehicle();
                var_4 = scripts\engine\utility::waittill_any_ents_return( self, "goal", self, "bad path", level, "br_circle_started", self, "last_stand_start", self, "path_timeout" );

                if ( isdefined( var_4 ) && ( var_4 != "bad path" && var_4 != "br_circle_started" && var_4 != "path_timeout" && var_4 != "last_stand_start" ) )
                {
                    var_5 = gettime() + randomintrange( 3, 8 ) * 1000;

                    while ( gettime() < var_5 )
                    {
                        if ( chooseanim_arrival_forcode() )
                        {
                            self.watch_for_player_entered_trap_room = undefined;
                            self notify( "update_on_death" );
                            break;
                        }

                        wait 0.1;
                    }
                }
            }
        }

        wait 1;
    }
}

vehicle_collision_getleveldataforvehicle()
{
    self endon( "last_stand_start" );
    level endon( "game_ended" );
    self endon( "goal" );
    self endon( "bad path" );
    level endon( "br_circle_started" );
    wait 15;
    self notify( "path_timeout" );
}

cheeselocs()
{
    self endon( "death_or_disconnect" );
    self endon( "gulag_end" );
    level endon( "game_ended" );
    var_0 = level.bot_personality_type[self.personality] == "stationary";
    self.watch_for_player_entered_trap_room = undefined;
    self.ignoreme = 1;
    self.ignoreall = 1;
    self botclearscriptgoal();

    while ( !istrue( self.gulagarena ) )
        wait 1;

    self.ignoreme = 0;
    self.ignoreall = 0;
    scripts\mp\bots\bots_util::bot_set_personality( "run_and_gun" );

    for (;;)
    {
        var_1 = self.arena;

        foreach ( var_3 in var_1.arenaplayers )
        {
            if ( var_3 == self )
                continue;

            if ( istrue( var_1.overtime ) && isdefined( var_1.i_see_player_vehicle_watcher ) && isdefined( var_1.i_see_player_vehicle_watcher.arenaflag ) && isdefined( var_1.i_see_player_vehicle_watcher.arenaflag.flagmodel ) )
            {
                self botsetscriptgoal( var_1.i_see_player_vehicle_watcher.arenaflag.flagmodel.origin, 64, "objective" );
                self botclearscriptenemy();
                continue;
            }

            self getenemyinfo( var_3 );
            self botsetscriptgoal( self getclosestreachablepointonnavmesh( var_3.origin ), 256, "guard" );
            self botsetscriptenemy( var_3 );
        }

        wait 3;
    }
}

bomber_spawn_origin_array_init()
{
    self endon( "death_or_disconnect" );

    for (;;)
    {
        var_0 = self getweaponslistprimaries();

        if ( var_0.size == 1 && var_0[0].basename == "iw8_fists_mp" )
        {
            wait 1;
            continue;
        }

        foreach ( var_2 in var_0 )
        {
            if ( self getweaponammostock( var_2 ) < weaponclipsize( var_2 ) )
                self setweaponammostock( var_2, weaponclipsize( var_2 ) );
        }

        wait 0.1;
    }
}

checksolospawnselections()
{
    if ( isdefined( level.watch_for_player_going_belowmap_or_oob ) && gettime() <= level.watch_for_player_going_belowmap_or_oob )
        return undefined;

    var_0 = missionbonustimer();

    if ( !isdefined( var_0 ) )
        return undefined;

    return var_0;
}

chopperexfil_sh025_start()
{
    var_0 = 0;

    foreach ( var_2 in level.players )
    {
        if ( !isbot( var_2 ) )
            continue;

        if ( var_2 cheesewedge() )
            var_0++;
    }

    return var_0;
}

cheesewedge()
{
    return isdefined( self.watch_for_player_entered_trap_room );
}

missionbonustimer()
{
    var_0 = get_player();
    var_1 = squared( 3000 );

    if ( istrue( self.inlaststand ) || scripts\mp\gametypes\br_public.gsc::rungwperif_flak() )
        return undefined;

    if ( !isdefined( var_0 ) || istrue( var_0.inlaststand ) || !isalive( var_0 ) || var_0 scripts\mp\gametypes\br_public.gsc::rungwperif_flak() )
        return undefined;

    if ( chooseanim_arrival_forcode() )
        return undefined;

    var_2 = manual_turret_operate_by_nearby_enemies();

    if ( var_2 >= 3 )
    {
        if ( distancesquared( var_0.origin, self.origin ) > var_1 )
            return undefined;

        var_3 = chopperexfil_sh025_start();

        if ( cheesewedge() )
            return var_0;

        if ( var_3 >= 1 )
            return undefined;

        return var_0;
    }
    else
        return var_0;
}

get_player()
{
    foreach ( var_1 in level.players )
    {
        if ( !isbot( var_1 ) )
            return var_1;
    }
}

_id_13054()
{
    self notify( "update_on_death" );
    self endon( "update_on_death" );
    scripts\engine\utility::_id_133F0( "death", "death_or_disconnect", "last_stand_start" );
    self.watch_for_player_entered_trap_room = undefined;
    level.watch_for_player_going_belowmap_or_oob = gettime() + 7;
}

chooseanim_arrival_forcode()
{
    var_0 = scripts\mp\gametypes\br_circle.gsc::getdangercircleorigin();
    var_1 = scripts\mp\gametypes\br_circle.gsc::getdangercircleradius();

    if ( istrue( level.extract_dialogue_played ) )
    {
        var_0 = scripts\mp\gametypes\br_circle.gsc::getsafecircleorigin();
        var_1 = scripts\mp\gametypes\br_circle.gsc::getsafecircleradius();
    }

    if ( scripts\mp\gametypes\br_public.gsc::rungwperif_flak() )
        return 0;

    if ( !isalive( self ) || self.sessionstate != "playing" )
        return 0;

    return !scripts\engine\utility::safefromnuke( self.origin, var_0, var_1 );
}

oilfire_burning_player_watch( var_0 )
{
    var_1 = scripts\mp\gametypes\br_circle.gsc::getrandompointincurrentcircle();

    if ( !isdefined( var_0 ) )
        var_0 = 1000;

    if ( distance2d( self.origin, var_1 ) > var_0 )
    {
        var_2 = vectortoangles( var_1 - self.origin );
        var_3 = anglestoforward( var_2 );
        var_1 = self.origin + var_3 * var_0;
    }

    return self getclosestreachablepointonnavmesh( var_1 );
}

old_getspawnpoint()
{
    var_0 = scripts\mp\gametypes\br_circle.gsc::getsafecircleorigin();
    var_1 = scripts\mp\gametypes\br_circle.gsc::getsafecircleradius();
    var_2 = scripts\mp\gametypes\br_circle.gsc::getrandompointincircle( var_0, var_1, 0.75, 0.9, 1, 1 );
    return self getclosestreachablepointonnavmesh( var_2 );
}

oil_puddles()
{
    var_0 = gettime() + 5000;

    while ( gettime() < var_0 )
    {
        var_1 = scripts\mp\gametypes\br_circle.gsc::getrandompointincircle( self.origin, 750, 0.6, 1, 1, 1 );
        var_2 = self getclosestreachablepointonnavmesh( var_1 );

        if ( safecheckweapon( var_2 ) )
            return var_2;

        wait 0.05;
    }

    var_3 = scripts\mp\gametypes\br_circle.gsc::getrandompointincurrentcircle();
    return self getclosestreachablepointonnavmesh( var_3 );
}

safecheckweapon( var_0 )
{
    var_1 = scripts\mp\gametypes\br_circle.gsc::getdangercircleorigin();
    var_2 = scripts\mp\gametypes\br_circle.gsc::getdangercircleradius();
    return scripts\engine\utility::safefromnuke( var_0, var_1, var_2 );
}

manual_turret_operate_by_nearby_enemies()
{
    var_0 = 0;

    foreach ( var_2 in level.players )
    {
        if ( !isbot( var_2 ) || !isalive( var_2 ) || var_2.sessionstate != "playing" )
            continue;

        var_0++;
    }

    return var_0;
}

chopperexfil_music_start( var_0 )
{
    var_1 = level.teamdata[var_0.team]["alivePlayers"];

    if ( scripts\engine\utility::array_contains( var_1, self ) )
        return 1;

    return 0;
}
