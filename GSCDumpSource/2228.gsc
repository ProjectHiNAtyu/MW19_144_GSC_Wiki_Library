// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "cruise_predator", "init" ) )
        [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "cruise_predator", "init" ) ]]();

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "cruise_predator", "registerVO" ) )
        [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "cruise_predator", "registerVO" ) ]]();

    level._effect["predator_pod_break"] = loadfx( "vfx/iw8_mp/killstreak/vfx_cruise_predator_explosion.vfx" );
    scripts\cp_mp\utility\killstreak_utility::registervisibilityomnvarforkillstreak( "cruise_predator", "invisible", 7 );
    scripts\cp_mp\utility\killstreak_utility::registervisibilityomnvarforkillstreak( "cruise_predator", "on", 8 );
}

weapongivencruisepredator( var_0 )
{
    return 1;
}

tryusecruisepredator()
{
    var_0 = scripts\cp_mp\utility\killstreak_utility::createstreakinfo( "cruise_predator", self );
    return tryusecruisepredatorfromstruct( var_0 );
}

tryusecruisepredatorfromstruct( var_0 )
{
    if ( !scripts\cp_mp\vehicles\vehicle_tracking::reservevehicle() )
        return 0;

    if ( isdefined( level.killstreaktriggeredfunc ) )
    {
        if ( !level [[ level.killstreaktriggeredfunc ]]( var_0 ) )
        {
            scripts\cp_mp\vehicles\vehicle_tracking::clearvehiclereservation();
            return 0;
        }
    }

    var_1 = scripts\cp_mp\killstreaks\killstreakdeploy::streakdeploy_doweapontabletdeploy( var_0, ::weapongivencruisepredator );

    if ( !istrue( var_1 ) )
    {
        scripts\cp_mp\vehicles\vehicle_tracking::clearvehiclereservation();
        return 0;
    }

    if ( isdefined( level.killstreakbeginusefunc ) )
    {
        if ( !level [[ level.killstreakbeginusefunc ]]( var_0 ) )
        {
            var_0 notify( "killstreak_finished_with_deploy_weapon" );
            scripts\cp_mp\vehicles\vehicle_tracking::clearvehiclereservation();
            return 0;
        }
    }

    if ( level.gameended )
    {
        var_0 notify( "killstreak_finished_with_deploy_weapon" );
        return 0;
    }

    var_2 = getdvarint( "scr_cruise_3rd", 0 );
    var_3 = runcruisepredator( var_0.streakname, var_0, var_2 );

    if ( !istrue( var_3 ) )
        return 0;

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "hud", "teamPlayerCardSplash" ) )
        [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "hud", "teamPlayerCardSplash" ) ]]( "used_cruise_predator", self );

    return 1;
}

runcruisepredator( var_0, var_1, var_2 )
{
    self disablephysicaldepthoffieldscripting();
    var_3 = scripts\cp_mp\utility\killstreak_utility::nuclear_core_on_chopper();
    var_4 = 10000;

    if ( isdefined( var_3 ) )
        var_4 = var_3.origin[2] + 6000;

    var_5 = level.mapcenter;

    if ( scripts\cp_mp\utility\game_utility::islargemap() || scripts\common\utility::iscp() || scripts\cp_mp\utility\game_utility::riskspawn_debugobjective() )
        var_5 = self.origin;

    var_6 = [];
    var_7 = ( 0, 0, 0 );
    var_8 = undefined;
    var_9 = level.players;

    if ( scripts\common\utility::iscp() )
        var_9 = level.characters;

    foreach ( var_11 in var_9 )
    {
        if ( var_11 == self )
            continue;

        if ( level.teambased && var_11.team == self.team )
            continue;

        var_7 = var_7 + ( var_11.origin - var_5 );
        var_6[var_6.size] = var_11;
    }

    if ( isdefined( var_7 ) && var_6.size > 0 )
    {
        var_8 = vectornormalize( var_7 / var_6.size );
        var_8 = var_8 * ( 1, 1, 0 );
    }
    else
    {
        var_13 = randomint( 360 );
        var_8 = anglestoforward( ( 0, var_13, 0 ) );
    }

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "cruise_predator", "directionOverride" ) )
        var_8 = self [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "cruise_predator", "directionOverride" ) ]]( var_8 );

    var_14 = var_5 + ( 0, 0, var_4 );
    var_15 = var_14 + var_8 * -3000;
    var_16 = var_14;
    var_17 = spawn( "script_model", var_15 );
    var_17 setmodel( "wmd_vm_missile_cruise" );
    var_17.owner = self;
    var_17.origin = var_15;
    var_17.angles = vectortoangles( var_16 - var_15 );
    var_17.type = "remote";
    var_17.team = self.team;
    var_17.entitynumber = var_17 getentitynumber();
    var_17.streakinfo = var_1;
    var_17.duration = 30;
    self.restoreangles = self.angles;

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "killstreak", "logKillstreakEvent" ) )
        self [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "killstreak", "logKillstreakEvent" ) ]]( var_0, var_17.origin );

    level.rockets[var_17.entitynumber] = var_17;
    level.remotemissileinprogress = 1;
    scripts\cp_mp\utility\killstreak_utility::playkillstreakoperatordialog( "use_" + var_0, 1 );
    var_18 = cruisepredator_followmissilepod( var_17, var_16, var_2, var_1 );
    return var_18;
}

get_player_drone( var_0, var_1, var_2 )
{
    self endon( "death" );
    level endon( "game_ended" );
    self waittill( "disowned" );

    if ( isdefined( self ) )
    {
        get_player_cumulative_damage( var_0, var_1, var_2 );
        self delete();
    }
}

get_player_cumulative_damage( var_0, var_1, var_2 )
{
    var_3 = self.owner;

    if ( isdefined( var_3 ) )
    {
        var_3 disablephysicaldepthoffieldscripting();
        var_3 unlink();
        var_3 scripts\common\utility::allow_fire( 1 );
        var_3 scripts\common\utility::allow_melee( 1 );
        var_3 scripts\common\utility::allow_weapon_switch( 1 );
        var_3 scripts\common\utility::allow_usability( 1 );
        var_3 scripts\common\utility::allow_shellshock( 1 );
        var_3 scripts\cp_mp\utility\killstreak_utility::_setvisibiilityomnvarforkillstreak( var_0.streakname, "off" );
        var_3 setclientomnvar( "ui_predator_missile", 0 );
        var_3 painvisionon();
        var_3 scripts\cp_mp\utility\killstreak_utility::killstreak_restorenvgstate();
        var_3 visionsetkillstreakforplayer( "" );
        level thread scripts\cp_mp\utility\game_utility::fadetoblackforplayer( var_3, 0, 0 );
    }

    var_0 notify( "killstreak_finished_with_deploy_weapon" );

    if ( isdefined( var_1 ) )
        scripts\cp_mp\targetmarkergroups::targetmarkergroup_off( var_1 );

    if ( isdefined( var_2 ) )
        scripts\cp_mp\targetmarkergroups::targetmarkergroup_off( var_2 );
}

#using_animtree("script_model");

cruisepredator_followmissilepod( var_0, var_1, var_2, var_3 )
{
    var_4 = scripts\engine\utility::get_notetrack_time( %mp_cruise_missile_move_intro, "wingtrails" );
    var_5 = scripts\engine\utility::get_notetrack_time( %mp_cruise_missile_move_intro, "shell_break" );
    var_6 = scripts\engine\utility::get_notetrack_time( %mp_cruise_missile_move_intro, "second_missile_thruster" );
    var_7 = scripts\engine\utility::get_notetrack_time( %mp_cruise_missile_move_intro, "anim_end" );
    var_8 = var_4;
    var_9 = var_5 - var_4;
    var_10 = var_6 - var_5;
    var_11 = var_7 - var_6;
    var_12 = undefined;
    var_13 = undefined;

    if ( !istrue( var_2 ) )
    {
        scripts\cp_mp\utility\shellshock_utility::_stopshellshock();
        scripts\common\utility::allow_fire( 0 );
        scripts\common\utility::allow_melee( 0 );
        scripts\common\utility::allow_weapon_switch( 0 );
        scripts\common\utility::allow_usability( 0 );
        scripts\common\utility::allow_shellshock( 0 );
        scripts\cp_mp\utility\killstreak_utility::_setvisibiilityomnvarforkillstreak( var_3.streakname, "invisible" );
        self setclientomnvar( "ui_predator_missile", 1 );
        var_14 = [];
        var_15 = [];
        var_16 = undefined;

        if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "cruise_predator", "assignTargetMarkers" ) )
            var_16 = self thread [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "cruise_predator", "assignTargetMarkers" ) ]]( self );

        if ( isdefined( var_16.enemytargetmarkergroup ) )
            var_14 = var_16.enemytargetmarkergroup;

        if ( isdefined( var_16.friendlytargetmarkergroup ) )
            var_15 = var_16.friendlytargetmarkergroup;

        var_12 = scripts\cp_mp\targetmarkergroups::targetmarkergroup_on( "thermalvisionenemydefault", self, var_14, self, 0, 1, 1 );
        var_13 = scripts\cp_mp\targetmarkergroups::targetmarkergroup_on( "thermalvisionfriendlydefault", self, var_15, self, 1, 1 );
        self playerlinkweaponviewtodelta( var_0, "tag_player", 1, 0, 0, 0, 0, 1 );
        self playerlinkedsetviewznear( 0 );
        var_0 thread cruisepredator_playdofsequence();
        self painvisionoff();
        scripts\cp_mp\utility\killstreak_utility::killstreak_savenvgstate();
        var_0 thread get_player_drone( var_3, var_12, var_13 );
        var_0 thread get_player_enemy( "disconnect" );
        var_0 thread get_player_enemy( "joined_team" );
        var_0 thread get_player_enemy( "joined_spectators" );
    }

    var_17 = "mp_cruise_missile_move_intro";
    var_18 = getdvarint( "scr_cruise_intro_anim", 0 );

    if ( var_18 == 1 )
        var_17 = "mp_cruise_missile_move_angle_intro";

    var_0 scriptmodelplayanimdeltamotion( var_17 );
    var_0 setscriptablepartstate( "main_thruster", "on", 0 );
    var_0 setscriptablepartstate( "clouds", "on", 0 );

    if ( !istrue( var_2 ) )
        var_0 playsoundtoplayer( "iw8_cruise_missile_plr_intro", self );

    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( var_8 );

    if ( !isdefined( var_0 ) )
        return 0;

    var_0 setscriptablepartstate( "wing_trails", "on" );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( var_9 );

    if ( !isdefined( var_0 ) )
        return 0;

    var_0 setscriptablepartstate( "wing_trails", "off" );
    var_0 setscriptablepartstate( "main_thruster", "off", 0 );
    playfxontag( scripts\engine\utility::getfx( "predator_pod_break" ), var_0, "tag_missile" );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( var_10 );

    if ( !isdefined( var_0 ) )
        return 0;

    var_0 setscriptablepartstate( "sub_thruster", "on", 0 );

    if ( !isdefined( var_0 ) || !isdefined( self ) )
        return 0;

    thread cruisepredator_delayplayslamzoom( var_11 - 0.15, var_2 );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( var_11 - 0.05 );

    if ( !isdefined( var_0 ) || !isdefined( self ) )
        return 0;

    thread cruisepredator_takecontrol( var_0, var_3, var_2, var_12, var_13 );
    return 1;
}

cruisepredator_playdofsequence()
{
    self endon( "death" );
    self.owner endon( "disconnect" );
    level endon( "game_ended" );
    self.owner enablephysicaldepthoffieldscripting();
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 0.5 );
    self.owner setphysicaldepthoffield( 0.2, 300, 20, 10 );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 3 );
    self.owner setphysicaldepthoffield( 5.6, 5000, 3, 10 );
}

cruisepredator_takecontrol( var_0, var_1, var_2, var_3, var_4 )
{
    var_0 endon( "death" );
    self endon( "disconnect" );
    level endon( "game_ended" );
    var_0 setscriptablepartstate( "clouds", "off", 0 );
    var_0 setscriptablepartstate( "sub_thruster", "off", 0 );
    scripts\cp_mp\vehicles\vehicle_tracking::clearvehiclereservation();
    var_5 = spawnstruct();
    var_5.origin = var_0 gettagorigin( "tag_missile" );
    var_5.angles = var_0 gettagangles( "tag_missile" );
    var_5.modelname = "wmd_vm_missile_cruise_warhead";
    var_5.vehicletype = "veh_cruise_predator_mp";
    var_5.targetname = "rcplane";
    var_5.cannotbesuspended = 1;
    var_6 = spawnstruct();
    var_7 = scripts\cp_mp\vehicles\vehicle_tracking::_spawnvehicle( var_5, var_6 );

    if ( !isdefined( var_7 ) )
        return;

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "killstreak", "killstreakMakeVehicle" ) )
        var_7 [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "killstreak", "killstreakMakeVehicle" ) ]]( var_1.streakname );

    scripts\cp_mp\vehicles\vehicle_tracking::vehicle_tracking_registerinstance( var_7 );
    var_1.shots_fired++;
    var_7 setcandamage( 0 );
    var_7 setotherent( self );
    var_7 setentityowner( self );
    var_7.angles = var_0 gettagangles( "tag_missile" );
    var_7.team = self.team;
    var_7.owner = self;
    var_7.streakinfo = var_1;
    var_7.lifetime = 10;
    var_7 setscriptablepartstate( "warhead_thruster", "on", 0 );
    var_7 setvehicleteam( var_7.team );

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "killstreak", "addToActiveKillstreakList" ) )
        var_7 [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "killstreak", "addToActiveKillstreakList" ) ]]( var_1.streakname, "Killstreak_Air", self, 0, 1, 50 );

    var_7.killcament = spawn( "script_model", var_7 gettagorigin( "tag_player" ) );
    var_7.killcament setmodel( "tag_origin" );
    var_7.killcament linkto( var_7, "tag_player" );
    var_7 endon( "death" );
    var_7 scripts\cp_mp\emp_debuff::set_apply_emp_callback( ::cruisepredator_empapplied );
    var_8 = spawn( "script_model", var_7 gettagorigin( "tag_fx" ) );
    var_8 setmodel( "ks_cruise_predator_mp" );
    var_8.angles = var_7 gettagangles( "tag_fx" );
    var_8.team = var_7.team;
    var_8.owner = var_7.owner;
    var_8.streakinfo = var_7.streakinfo;
    var_8 linkto( var_7, "tag_fx" );
    var_8 setscriptablepartstate( "fake_trail", "on", 0 );
    var_8 setotherent( self );
    var_8 thread get_player_defusing_zone( var_1 );
    var_8 thread cruisepredator_watchmissileinfo( var_7 );
    var_8 thread cruisepredator_watchmissileexplosion( var_7, self, var_7.killcament, var_2, var_3, var_4 );
    var_7 thread get_player_enemy( "disconnect" );
    var_7 thread get_player_enemy( "joined_team" );
    var_7 thread get_player_enemy( "joined_spectators" );

    if ( !istrue( var_2 ) )
        self visionsetkillstreakforplayer( "", 0.1 );

    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 0.05 );

    if ( !istrue( var_2 ) )
    {
        self disablephysicaldepthoffieldscripting();
        self unlink();
        self cameralinkto( var_7, "tag_player", 1 );
        self controlslinkto( var_7 );
        self visionsetkillstreakforplayer( "cruise_color" );
        self.soundent = spawn( "script_origin", var_7.origin );
        self.soundent showonlytoplayer( self );
        self.soundent playloopsound( "iw8_cruise_missile_plr" );
        scripts\cp_mp\utility\shellshock_utility::_shellshock( "killstreak_veh_camera_mp", "top", var_7.lifetime, 0 );
        scripts\cp_mp\utility\killstreak_utility::_setvisibiilityomnvarforkillstreak( var_1.streakname, "on" );
        self setclientomnvar( "ui_predator_missile", 2 );
        self setclientomnvar( "ui_killstreak_health", 1 );
        self setclientomnvar( "ui_killstreak_countdown", gettime() + int( 10000 ) );
        self setclientomnvar( "ui_predator_missiles_left", -1 );

        if ( scripts\cp_mp\utility\game_utility::isnightmap() )
        {
            self visionsetthermalforplayer( "flir_0_black_to_white" );
            scripts\cp_mp\utility\player_utility::setthermalvision( 1, 12, 1500 );
            scripts\cp_mp\utility\shellshock_utility::_shellshock( "killstreak_veh_camera_flir_mp", "top", var_7.lifetime, 0 );
        }
    }

    var_7 thread cruisepredator_delaymissilecollision();
    var_9 = randomintrange( 1, 3 );
    var_7 scripts\cp_mp\utility\killstreak_utility::playkillstreakoperatordialog( "cruise_control_" + var_9 );
    var_7 thread cruisepredator_watchtimer( self );
    waitframe();

    if ( isdefined( var_0 ) )
        var_0 delete();
}

cruisepredator_watchkillborder()
{
    if ( !isdefined( level.kill_border_triggers ) )
        return;

    self endon( "death" );
    self endon( "explode" );
    self endon( "collision" );
    self endon( "emp_defused" );
    self endon( "trophy_blocked" );

    for (;;)
    {
        if ( cruisepredator_istouchingkillborder( level.kill_border_triggers ) )
        {
            self notify( "explode" );
            break;
        }

        waitframe();
    }
}

cruisepredator_istouchingkillborder( var_0 )
{
    var_1 = 0;

    foreach ( var_3 in var_0 )
    {
        if ( self istouching( var_3 ) )
        {
            var_1 = 1;
            break;
        }
    }

    return var_1;
}

cruisepredator_delaymissilecollision()
{
    self endon( "explode" );
    self endon( "death" );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 0.75 );
    self vehphys_enablecollisioncallback( 1 );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 1.25 );
    thread cruisepredator_watchkillborder();
}

get_player_defusing_zone( var_0 )
{
    self endon( "death" );
    self.owner endon( "disconnect" );
    self.owner endon( "cruise_missile_finished" );
    level waittill( "game_ended" );
    self.owner scripts\cp_mp\utility\killstreak_utility::_id_11D86( var_0 );
}

cruisepredator_watchmissileinfo( var_0 )
{
    self endon( "death" );

    for (;;)
    {
        self.missilelastpos = var_0.origin;
        self.missilelastangle = var_0.angles;
        waitframe();
    }
}

cruisepredator_watchmissileexplosion( var_0, var_1, var_2, var_3, var_4, var_5 )
{
    var_6 = var_2;
    var_7 = undefined;
    var_8 = undefined;
    var_9 = var_0.streakinfo;
    var_10 = var_0 cruisepredator_waittillexplode( "collision", "explode", "death", "disowned", "emp_defused", "trophy_blocked" );

    if ( isdefined( var_4 ) )
        scripts\cp_mp\targetmarkergroups::targetmarkergroup_off( var_4 );

    if ( isdefined( var_5 ) )
        scripts\cp_mp\targetmarkergroups::targetmarkergroup_off( var_5 );

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "cruise_predator", "CPUnMarkEnemies" ) )
        [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "cruise_predator", "CPUnMarkEnemies" ) ]]( var_1 );

    if ( isdefined( self ) )
    {
        var_7 = self.missilelastpos;
        var_8 = self.missilelastangle;

        if ( isdefined( var_1 ) )
        {
            var_1 cameraunlink();
            var_1 controlsunlink();
        }

        if ( isdefined( var_0 ) )
        {
            scripts\cp_mp\vehicles\vehicle_tracking::vehicle_tracking_registerinstance( var_0 );
            scripts\cp_mp\vehicles\vehicle_tracking::_deletevehicle( var_0 );
        }

        if ( !isdefined( var_10 ) || var_10.msg != "emp_defused" && var_10.msg != "trophy_blocked" )
        {
            var_11 = 600;
            var_12 = "MOD_EXPLOSIVE";
            var_13 = "cruise_proj_mp";

            if ( isdefined( var_1 ) )
            {
                var_14 = isdefined( var_10 ) && var_10.msg == "disowned";

                if ( !istrue( var_14 ) )
                    self radiusdamage( var_7, var_11, 1000, 1000, var_1, var_12, var_13 );

                var_15 = scripts\common\utility::playersinsphere( var_7, var_11 );

                foreach ( var_17 in var_15 )
                {
                    if ( var_17 scripts\cp_mp\utility\player_utility::_isalive() && scripts\cp_mp\utility\player_utility::playersareenemies( var_17, var_1 ) )
                    {
                        if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "sound", "trySayLocalSound" ) )
                            level thread [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "sound", "trySayLocalSound" ) ]]( var_17, "flavor_closecall", undefined, 1 );
                    }
                }
            }
        }

        scripts\cp_mp\utility\shellshock_utility::shellshock_artilleryearthquake( var_7, 1, 1, 1000 );
        thread cruisepredator_handlevfxstates( var_10 );
    }

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "cruise_predator", "eventRecord" ) )
        [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "cruise_predator", "eventRecord" ) ]]( var_7 );

    if ( isdefined( var_1 ) )
    {
        var_1 thread cruisepredator_watchkills( var_10 );

        if ( !istrue( var_3 ) )
        {
            if ( isdefined( var_1.soundent ) )
            {
                var_1.soundent stoploopsound( "iw8_cruise_missile_plr" );
                var_1.soundent delete();
            }

            var_1 scripts\cp_mp\utility\killstreak_utility::_setvisibiilityomnvarforkillstreak( var_9.streakname, "off" );
            var_1 setclientomnvar( "ui_predator_missile", 0 );
            var_19 = 1;
            var_20 = spawn( "script_model", var_7 );
            var_20 setmodel( "tag_player" );
            var_21 = getdvarint( "scr_cruise_detach_dist", 1000 );
            var_22 = getdvarint( "scr_cruise_detach_height", 0 );
            var_23 = anglestoforward( var_8 );
            var_24 = var_7 - var_23 * var_21;
            var_25 = ( 0, 0, var_22 );
            var_26 = var_24 + var_25;
            var_20.angles = vectortoangles( var_7 + ( 0, 0, 150 ) - var_26 );
            var_6 unlink();
            var_6 linkto( var_20, "tag_player", ( 0, 0, 0 ), ( 0, 0, 0 ) );

            if ( scripts\cp_mp\utility\game_utility::isnightmap() )
                var_1 scripts\cp_mp\utility\player_utility::setthermalvision( 0 );

            var_20.origin = var_26;
            var_1 cameralinkto( var_20, "tag_origin" );
            var_27 = "cruise_predator_static";

            if ( var_19 == 2 )
                var_27 = "cruise_predator_flash";

            var_1 thread cruisepredator_startfadecamtransition( 0.4, 0.6, 0.05, var_27 );
            var_28 = scripts\common\utility::playersinsphere( var_7, 2000 );

            foreach ( var_17 in var_28 )
            {
                if ( !isdefined( var_17 ) || !var_17 scripts\cp_mp\utility\player_utility::_isalive() || var_17 == var_1 )
                    continue;

                var_17 earthquakeforplayer( 0.3, 2, var_17.origin, 100 );
                var_17 setclientomnvar( "ui_hud_shake", 1 );
                var_17 playrumbleonpositionforclient( "artillery_rumble", var_17.origin );
            }

            var_1 earthquakeforplayer( 0.3, 3, var_1.origin, 100 );
            var_1 setclientomnvar( "ui_hud_shake", 1 );
            var_1 playrumbleonpositionforclient( "artillery_rumble", var_1.origin );
            wait 0.5;
            var_1 notify( "cruise_missile_finished" );
            var_1 cruisepredator_returnplayer( var_9, var_20 );
            var_1 scripts\cp_mp\utility\killstreak_utility::_id_11D86( var_9 );
        }
    }

    if ( isdefined( var_6 ) )
        var_6 delete();

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "cruise_predator", "removeItemFromSlot" ) )
        [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "cruise_predator", "removeItemFromSlot" ) ]]( var_1 );
}

cruisepredator_cameramove( var_0, var_1 )
{
    self moveto( var_0, 0.2, 0, 0.05 );
    wait 0.15;
    self moveto( var_0 + vectornormalize( var_1 - var_0 ) * 24, 2 );
}

cruisepredator_returnplayer( var_0, var_1 )
{
    if ( isdefined( level.killstreakfinishusefunc ) )
        level thread [[ level.killstreakfinishusefunc ]]( var_0 );

    scripts\cp_mp\utility\shellshock_utility::_stopshellshock();
    self cameraunlink();
    var_1 delete();
    self visionsetkillstreakforplayer( "" );
    scripts\common\utility::allow_fire( 1 );
    scripts\common\utility::allow_melee( 1 );
    scripts\common\utility::allow_weapon_switch( 1 );
    scripts\common\utility::allow_usability( 1 );
    scripts\common\utility::allow_shellshock( 1 );
    self painvisionon();
    scripts\cp_mp\utility\killstreak_utility::killstreak_restorenvgstate();
    level thread scripts\cp_mp\utility\killstreak_utility::_id_11F70( self );
    var_0 notify( "killstreak_finished_with_deploy_weapon" );
}

cruisepredator_watchtimer( var_0 )
{
    self endon( "death" );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 10.1 );
    self notify( "explode", self.origin );
}

cruisepredator_watchexplosiondistance( var_0, var_1 )
{
    self endon( "death" );
    var_0 endon( "disconnect" );
    level endon( "game_ended" );
    var_2 = [ self, var_1 ];
    var_3 = scripts\engine\trace::create_contents( 1, 1, 1, 1, 1, 1, 0, 0 );

    for (;;)
    {
        var_4 = anglestoforward( self.angles );
        var_5 = self gettagorigin( "tag_missile" );
        var_0.lastknownmissilepos = var_5;
        var_0.lastknownmissileangles = self.angles;
        var_6 = getdvarint( "scr_cruise_impact_dist", 50 );

        if ( isdefined( self.missilebooston ) )
            var_6 = getdvarint( "scr_cruise_impact_boost_dist", 150 );

        var_7 = var_5 + var_4 * var_6;
        var_8 = scripts\engine\trace::sphere_trace( var_5, var_7, 5, var_2, var_3 );

        if ( isdefined( var_8["hittype"] ) && var_8["hittype"] != "hittype_none" )
        {
            if ( isdefined( var_8["position"] ) )
            {
                var_0.lastknowntrace = var_8;
                self notify( "missile_close_explode", var_8["position"] );
                break;
            }
        }

        wait 0.05;
    }
}

cruisepredator_watchmissileboost( var_0 )
{
    var_0 endon( "disconnect" );
    self endon( "death" );
    level endon( "game_ended" );
    var_0 notifyonplayercommand( "missile_boost_on", "+attack" );

    for (;;)
    {
        var_0 waittill( "missile_boost_on" );
        self.missilebooston = 1;
        break;
    }
}

get_player_enemy( var_0 )
{
    self endon( "death" );
    self endon( "disowned" );
    level endon( "game_ended" );
    var_1 = self.owner;
    var_1 waittill( var_0 );
    self notify( "disowned" );
}

cruisepredator_startexplodecamtransition()
{
    self visionsetkillstreakforplayer( "cruise_predator_slamzoom", 0.05 );
    wait 0.1;
    self visionsetkillstreakforplayer( "", 0.05 );
}

cruisepredator_startfadecamtransition( var_0, var_1, var_2, var_3 )
{
    if ( !isdefined( var_0 ) )
        var_0 = 0.5;

    if ( !isdefined( var_1 ) )
        var_1 = 0.5;

    if ( !isdefined( var_2 ) )
        var_2 = 0.05;

    if ( isdefined( var_3 ) )
    {
        self visionsetkillstreakforplayer( var_3, var_0 );
        wait( var_1 );
        self visionsetkillstreakforplayer( "", var_2 );
    }
    else
    {
        level thread scripts\cp_mp\utility\game_utility::fadetoblackforplayer( self, 1, var_0 );
        wait( var_1 );
        level thread scripts\cp_mp\utility\game_utility::fadetoblackforplayer( self, 0, var_2 );
    }
}

cruisepredator_shakerider( var_0 )
{
    self endon( "disconnect" );
    var_1 = 0;

    while ( var_1 < var_0 )
    {
        self playrumbleonpositionforclient( "damage_light", self.origin );
        var_1 = var_1 + 0.05;
        wait 0.05;
    }
}

cruisepredator_waittillexplode( var_0, var_1, var_2, var_3, var_4, var_5 )
{
    self endon( "death" );
    var_6 = spawnstruct();

    if ( isdefined( var_0 ) )
        thread waittill_explodestring( var_0, var_6 );

    if ( isdefined( var_1 ) )
        thread waittill_explodestring( var_1, var_6 );

    if ( isdefined( var_2 ) )
        thread waittill_explodestring( var_2, var_6 );

    if ( isdefined( var_3 ) )
        thread waittill_explodestring( var_3, var_6 );

    if ( isdefined( var_4 ) )
        thread waittill_explodestring( var_4, var_6 );

    if ( isdefined( var_5 ) )
        thread waittill_explodestring( var_5, var_6 );

    var_6 waittill( "returned", var_7, var_8, var_9, var_10, var_11, var_12, var_13, var_14, var_15 );
    var_6 notify( "die" );
    self.owner notify( "cruise_missile_explode" );
    var_16 = spawnstruct();
    var_16.msg = var_7;
    var_16.param1 = var_8;
    var_16.param2 = var_9;
    var_16.param3 = var_10;
    var_16.param4 = var_11;
    var_16.param5 = var_12;
    var_16.param6 = var_13;
    var_16.param7 = var_14;
    var_16.param8 = var_15;
    return var_16;
}

waittill_explodestring( var_0, var_1 )
{
    self endon( "death" );
    var_1 endon( "die" );
    self waittill( var_0, var_2, var_3, var_4, var_5, var_6, var_7 );
    var_1 notify( "returned", var_0, var_2, var_3, var_4, var_5, var_6, var_7 );
}

cruisepredator_handlevfxstates( var_0 )
{
    self endon( "death" );
    self unlink();

    if ( !isdefined( var_0 ) || var_0.msg == "explode" || var_0.msg == "disowned" || var_0.msg == "emp_defused" || var_0.msg == "trophy_blocked" )
    {
        self setscriptablepartstate( "air_explosion", "on", 0 );
        scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 0.2 );
        self delete();
    }

    var_1 = ( 0, 0, 1 );
    var_2 = var_0.param6;
    self.angles = vectortoangles( var_2 );
    var_3 = vectordot( var_2, var_1 );

    if ( var_3 >= 0.7 )
        self setscriptablepartstate( "ground_explosion", "on", 0 );
    else
        self setscriptablepartstate( "air_explosion", "on", 0 );

    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 1 );
    self delete();
}

cruisepredator_watchkills( var_0 )
{
    self endon( "disconnect" );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( 1 );

    if ( isdefined( self ) && isdefined( self.recentkillcount ) )
    {
        if ( self.recentkillcount >= 1 )
            scripts\cp_mp\utility\killstreak_utility::playkillstreakoperatordialog( "cruise_kill", 1 );
        else
            scripts\cp_mp\utility\killstreak_utility::playkillstreakoperatordialog( "cruise_miss", 1 );
    }
}

cruisepredator_delayplayslamzoom( var_0, var_1 )
{
    self endon( "disconnect" );
    scripts\cp_mp\hostmigration::hostmigration_waitlongdurationwithpause( var_0 );

    if ( !istrue( var_1 ) )
    {
        self visionsetkillstreakforplayer( "cruise_predator_slamzoom", 0.1 );
        level thread scripts\cp_mp\utility\game_utility::fadetoblackforplayer( self, 1, 0.2 );
        wait 0.2;
        level thread scripts\cp_mp\utility\game_utility::fadetoblackforplayer( self, 0, 0 );
    }
}

cruisepredator_empapplied( var_0 )
{
    if ( isdefined( self ) )
        self notify( "emp_defused" );
}
