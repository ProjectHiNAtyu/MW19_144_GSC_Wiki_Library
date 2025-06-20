// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    if ( !getdvarint( "scr_br_safe_zones_enabled", 0 ) )
        return;

    rear_minigun_angles_offset();
    level._id_120E5 = spawnstruct();
    level._id_120E5._id_13733 = [];
    level._id_120E5.zones = [];
    level._id_120E5._id_120E1 = [];
    level thread tv_model();
}

tv_model()
{
    level waittill( "prematch_done" );
    wait 5;
    _id_12759();
    level thread _id_120E6();
}

reset_recharge_after_respawn( var_0 )
{
    if ( level.completesmokinggunquest.safezoneenabled != 1 )
        return 0;

    if ( !isdefined( level._id_120E5 ) )
        return 0;

    if ( !isarray( level._id_120E5.zones ) )
        return 0;

    return scripts\engine\utility::array_contains( level._id_120E5._id_120E1, var_0 );
}

mine_caves_turret_op()
{
    switch ( level.mapname )
    {
        case "mp_br_mechanics":
            return ::_id_1240E;
        case "mp_don4_pm":
        case "mp_don4":
            return ::_id_1240F;
    }

    return undefined;
}

ammobox_canweaponacceptmoreattachments( var_0, var_1, var_2, var_3, var_4 )
{
    var_3 = _id_1314A( var_3 );

    if ( !var_3 )
        return;

    var_5 = spawnstruct();
    var_5.origin = var_0;
    var_5.angles = var_1;
    var_5.radius = var_3;
    var_5.height = var_4;
    var_6 = level._id_120E5._id_13733.size;
    var_5.id = "safe_zone_" + var_2;
    level._id_120E5._id_13733[var_6] = var_5;
}

_id_1240E()
{
    ammobox_canweaponacceptmoreattachments( ( -250, -4000, 0 ), ( 0, 0, 0 ), 0, 400, 512 );
    ammobox_canweaponacceptmoreattachments( ( -1500, -4000, 0 ), ( 0, 180, 0 ), 1, 800, 256 );
    ammobox_canweaponacceptmoreattachments( ( -3350, -4000, 0 ), ( 0, 210, 0 ), 2, 1000, 128 );
}

_id_1240F()
{
    ammobox_canweaponacceptmoreattachments( ( 38394, -26884, -564 ), ( 0, 0, 0 ), 0, 600, 128 );
    ammobox_canweaponacceptmoreattachments( ( 22180, -32193, -440 ), ( 0, 0, 0 ), 1, 600, 128 );
    ammobox_canweaponacceptmoreattachments( ( 27591, 8805, -475 ), ( 0, 0, 0 ), 2, 400, 200 );
    ammobox_canweaponacceptmoreattachments( ( 27915, 37519, 714 ), ( 0, 0, 0 ), 3, 700, 250 );
    ammobox_canweaponacceptmoreattachments( ( 4470, 49274, 1036 ), ( 0, 0, 0 ), 4, 700, 128 );
    ammobox_canweaponacceptmoreattachments( ( 6754, 17467, -681 ), ( 0, 0, 0 ), 6, 600, 350 );
    ammobox_canweaponacceptmoreattachments( ( 30407, -8705, -412 ), ( 0, 0, 0 ), 7, 800, 400 );
    ammobox_canweaponacceptmoreattachments( ( -20524, 22013, -448 ), ( 0, 0, 0 ), 8, 800, 600 );
    ammobox_canweaponacceptmoreattachments( ( -26038, -10377, -38 ), ( 0, 0, 0 ), 11, 800, 250 );
    ammobox_canweaponacceptmoreattachments( ( -7972, -11756, 348 ), ( 0, 0, 0 ), 12, 800, 150 );
    ammobox_canweaponacceptmoreattachments( ( -20746, -28231, -145 ), ( 0, 0, 0 ), 13, 700, 300 );
    ammobox_canweaponacceptmoreattachments( ( 9247, -23349, -224 ), ( 0, 0, 0 ), 14, 700, 250 );
    ammobox_canweaponacceptmoreattachments( ( 50830, 3161, 31 ), ( 0, 0, 0 ), 15, 700, 128 );
    ammobox_canweaponacceptmoreattachments( ( 51432, -17940, -392 ), ( 0, 0, 0 ), 16, 400, 128 );
    ammobox_canweaponacceptmoreattachments( ( -4093, -30507, 318 ), ( 0, 0, 0 ), 17, 1000, 128 );
    ammobox_canweaponacceptmoreattachments( ( -20758, 7765, -226 ), ( 0, 0, 0 ), 18, 600, 250 );
}

_id_12759()
{
    var_0 = mine_caves_turret_op();

    if ( isdefined( var_0 ) )
        level thread [[ var_0 ]]();

    foreach ( var_2 in level._id_120E5._id_13733 )
    {
        var_3 = _id_12758( var_2.origin, var_2.angles, var_2.radius, var_2.height );
        var_3.id = var_2.id;
        level._id_120E5.zones[level._id_120E5.zones.size] = var_3;
    }
}

rear_minigun_angles_offset()
{
    level.completesmokinggunquest._id_120E4 = [ 400, 500, 600, 700, 750, 800, 900, 1000 ];
    level._effect["gxp_safe_zone_400"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1000" );
    level._effect["gxp_safe_zone_400_destroy"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1000_destroy" );
    level._effect["gxp_safe_zone_400_orange"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1000_orange" );
    level._effect["gxp_safe_zone_400_yellow"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1000_yellow" );
    level._effect["gxp_safe_zone_500"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1000" );
    level._effect["gxp_safe_zone_500_destroy"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1000_destroy" );
    level._effect["gxp_safe_zone_500_orange"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1000_orange" );
    level._effect["gxp_safe_zone_500_yellow"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1000_yellow" );
    level._effect["gxp_safe_zone_600"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1200" );
    level._effect["gxp_safe_zone_600_destroy"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1200_destroy" );
    level._effect["gxp_safe_zone_600_orange"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1200_orange" );
    level._effect["gxp_safe_zone_600_yellow"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1200_yellow" );
    level._effect["gxp_safe_zone_700"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1400" );
    level._effect["gxp_safe_zone_700_destroy"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1400_destroy" );
    level._effect["gxp_safe_zone_700_orange"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1400_orange" );
    level._effect["gxp_safe_zone_700_yellow"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1400_yellow" );
    level._effect["gxp_safe_zone_750"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1500" );
    level._effect["gxp_safe_zone_750_destroy"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1500" );
    level._effect["gxp_safe_zone_750_orange"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1500" );
    level._effect["gxp_safe_zone_750_yellow"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1500" );
    level._effect["gxp_safe_zone_800"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1600" );
    level._effect["gxp_safe_zone_800_destroy"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1600_destroy" );
    level._effect["gxp_safe_zone_800_orange"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1600_orange" );
    level._effect["gxp_safe_zone_800_yellow"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1600_yellow" );
    level._effect["gxp_safe_zone_900"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_1800" );
    level._effect["gxp_safe_zone_900_destroy"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1800_destroy" );
    level._effect["gxp_safe_zone_900_orange"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1800_orange" );
    level._effect["gxp_safe_zone_900_yellow"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_1800_yellow" );
    level._effect["gxp_safe_zone_1000"] = loadfx( "vfx/iw8_br/gameplay/vfx_safe_zone_verdansk_circle_2000" );
    level._effect["gxp_safe_zone_1000_destroy"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_2000_destroy" );
    level._effect["gxp_safe_zone_1000_orange"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_2000_orange" );
    level._effect["gxp_safe_zone_1000_yellow"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_safe_zone_verdansk_circle_2000_yellow" );
    level._effect["gxp_safe_zone_player_eye"] = loadfx( "vfx/iw8_br/gameplay/hween2/vfx_gxp_safespace_01.vfx" );
}

mortar_start( var_0, var_1 )
{
    var_2 = "gxp_safe_zone_" + var_0;

    if ( isdefined( var_1 ) )
        var_2 = var_2 + "_" + var_1;

    return var_2;
}

_id_1314A( var_0 )
{
    if ( !scripts\engine\utility::array_contains( level.completesmokinggunquest._id_120E4, var_0 ) )
    {
        var_1 = 0;
        var_2 = var_0;

        foreach ( var_4 in level.completesmokinggunquest._id_120E4 )
        {
            var_5 = abs( var_0 - var_4 );

            if ( var_5 < var_2 )
            {
                var_2 = var_5;
                var_1 = var_4;
            }
        }

        return var_1;
    }

    return var_0;
}

dangercircletick( var_0, var_1 )
{
    if ( level.completesmokinggunquest.safezoneenabled != 1 )
        return;

    if ( level.completesmokinggunquest.safezonecircledestroy != 1 )
        return;

    if ( !isdefined( level._id_120E5.zones ) )
        return;

    foreach ( var_3 in level._id_120E5.zones )
    {
        if ( !isdefined( var_3 ) )
            continue;

        var_4 = var_1 - var_3.radius + level.completesmokinggunquest.safezonecircledestroypadding;
        var_5 = var_4 * var_4;

        if ( isdefined( var_3 ) && distance2dsquared( var_3.origin, var_0 ) >= var_5 )
            var_3 destroy_safe_zone();
    }
}

_id_12758( var_0, var_1, var_2, var_3 )
{
    var_4 = spawn( "trigger_radius", var_0, 0, var_2, var_3 );
    var_4.angles = var_1;
    var_4.radius = var_2;
    var_4.height = var_3;
    var_4.health = level.completesmokinggunquest.safezonehealth;
    var_5 = mortar_start( var_2 );
    var_4._id_1372F = spawnfx( scripts\engine\utility::getfx( var_5 ), var_0, ( 1, 0, 0 ), ( 0, 0, 1 ) );
    triggerfx( var_4._id_1372F );
    var_6 = ( 0, 0, 50 );
    var_7 = scripts\engine\trace::ray_trace( var_0 + var_6, var_0 - var_6 );
    var_4.cacheentity = spawn( "script_model", var_7["position"] );
    var_4.cacheentity setmodel( "p9_ver_soldier_gear" );
    var_4.cacheentity.angles = ( var_7["normal"][0], var_1[1], var_7["normal"][2] );
    var_4.objid = scripts\mp\objidpoolmanager::requestobjectiveid( 99 );
    scripts\mp\objidpoolmanager::objective_add_objective( var_4.objid, "active", var_0 );
    getbnetigrbattlepassxpmultiplier( var_4.objid, 4500, 5000 );
    objective_setbackground( var_4.objid, 1 );
    objective_icon( var_4.objid, "ui_mp_br_mapmenu_legend_sacredground_gxp" );
    _func_421( var_4.objid, 1 );
    scripts\mp\utility\trigger::makeenterexittrigger( var_4, ::weapon_xp_iw8_sh_romeo870, ::weapon_xp_iw8_sm_uzulu );

    if ( level.completesmokinggunquest.original_health )
        var_4 thread tag_to_shoot_from();

    return var_4;
}

tag_to_shoot_from()
{
    self endon( "death" );
    level endon( "game_ended" );

    for (;;)
    {
        self waittill( "trigger", var_0 );

        if ( var_0 scripts\mp\gametypes\br_public.gsc::zombie() )
        {
            _id_12C01( var_0 );
            ghost_teleport_damage( var_0 );

            if ( self.health <= 0 )
                destroy_safe_zone();
        }
    }
}

ghost_teleport_damage( var_0 )
{
    var_1 = gettime();

    if ( isdefined( self.nextsafezonedamagetime ) && self.nextsafezonedamagetime > var_1 )
        return;

    var_0 dodamage( level.completesmokinggunquest.safezoneghostdamage, self.origin, var_0 );
    self.health = self.health - level.completesmokinggunquest.safezoneghostteleportdamage;
    self.nextsafezonedamagetime = gettime() + level.completesmokinggunquest.safezoneghostdamagecooldown * 1000;
    var_2 = undefined;

    if ( self.health <= level.completesmokinggunquest.safezonehealth * level.completesmokinggunquest.safezonehealthyellowpercentage )
        var_2 = "yellow";

    if ( self.health <= level.completesmokinggunquest.safezonehealth * level.completesmokinggunquest.safezonehealthorangepercentage )
        var_2 = "orange";

    if ( isdefined( var_2 ) )
    {
        if ( !isdefined( self.damagecolor ) || isdefined( self.damagecolor ) && self.damagecolor != var_2 )
        {
            if ( var_2 == "yellow" )
                playsoundatpos( self.origin, "br_gov_safespace_transition_low" );
            else if ( var_2 == "orange" )
                playsoundatpos( self.origin, "br_gov_safespace_transition_med" );

            if ( isdefined( self._id_1372F ) )
            {
                self._id_1372F delete();
                self._id_1372F = undefined;
            }

            self.damagecolor = var_2;
            var_3 = mortar_start( self.radius, var_2 );
            self._id_1372F = spawnfx( scripts\engine\utility::getfx( var_3 ), self.origin, ( 1, 0, 0 ), ( 0, 0, 1 ) );
            triggerfx( self._id_1372F );
        }
    }
}

destroy_safe_zone()
{
    if ( isdefined( self._id_1372F ) )
    {
        self._id_1372F delete();
        self._id_1372F = undefined;
    }

    objective_delete( self.objid );

    if ( isdefined( self.cacheentity ) )
        self.cacheentity delete();

    var_0 = getarraykeys( self.triggerenterents );

    for ( var_1 = 0; var_1 < var_0.size; var_1++ )
    {
        var_2 = var_0[var_1];
        var_3 = self.triggerenterents[var_2];
        weapon_xp_iw8_sm_uzulu( var_3, self );
    }

    var_4 = mortar_start( self.radius, "destroy" );
    playfx( scripts\engine\utility::getfx( var_4 ), self.origin, ( 1, 0, 0 ), ( 0, 0, 1 ) );
    playsoundatpos( self.origin, "br_gov_safespace_exp" );
    self delete();
}

_id_12C01( var_0 )
{
    if ( level.completesmokinggunquest.original_health )
    {
        playsoundatpos( var_0.origin, "br_gov_safespace_dmg" );
        var_1 = var_0.origin - self.origin;
        var_2 = self.radius + 400 - length2d( var_1 );
        var_1 = vectornormalize( ( var_1[0], var_1[1], 0 ) );
        var_3 = var_1 * var_2;
        var_4 = var_0 geteye();
        var_5 = var_4 + var_3;
        var_6 = var_5;
        var_7 = var_0 scripts\mp\gametypes\br_gametype_gxp_ghost.gsc::brjugg_initpostmain( var_5, var_4, var_1, undefined, undefined, 1 );

        if ( isdefined( var_7 ) )
        {
            var_8 = checksufficientteleportdistancefromsafezone( var_7 );

            if ( !var_8 )
                var_7 = undefined;
        }

        if ( isdefined( var_7 ) )
            return;

        var_9 = 45;
        var_10 = 1;
        var_11 = vectortoangles( var_1 );

        for ( var_12 = 1; !isdefined( var_7 ) && var_12 <= level.completesmokinggunquest.safezonebackupteleportattempts; var_12++ )
        {
            var_11 = ( var_11[0], var_11[1] + var_9 * var_10, 0 );
            var_13 = anglestoforward( var_11 );
            var_5 = var_4 + var_13 * var_2;
            var_7 = var_0 scripts\mp\gametypes\br_gametype_gxp_ghost.gsc::brjugg_initpostmain( var_5, var_4, var_13, undefined, undefined, 1 );

            if ( isdefined( var_7 ) )
            {
                var_8 = checksufficientteleportdistancefromsafezone( var_7 );

                if ( !var_8 )
                    var_7 = undefined;
            }

            var_9 = var_9 + 45;
            var_10 = var_10 * -1;
        }

        if ( isdefined( var_7 ) )
            return;

        var_12 = 1;
        var_3 = ( 0, 0, 1000 );

        for ( var_4 = var_0 geteye(); !isdefined( var_7 ) && var_12 < level.completesmokinggunquest.safezonebackupteleportattempts; var_12++ )
        {
            var_5 = var_5 + var_3;
            var_1 = vectornormalize( var_5 - var_4 );
            var_7 = var_0 scripts\mp\gametypes\br_gametype_gxp_ghost.gsc::brjugg_initpostmain( var_5, var_4, var_1, undefined, undefined, 1 );
        }
    }
}

checksufficientteleportdistancefromsafezone( var_0 )
{
    var_1 = 40;
    var_2 = length2dsquared( var_0 - self.origin );
    var_3 = ( self.radius + var_1 ) * ( self.radius + var_1 );
    return var_2 > var_3;
}

weapon_xp_iw8_sh_romeo870( var_0, var_1 )
{
    if ( !isplayer( var_0 ) )
        return;

    if ( !var_0 scripts\mp\gametypes\br_public.gsc::zombie() )
    {
        level._id_120E5._id_120E1 = scripts\engine\utility::array_add( level._id_120E5._id_120E1, var_0 );
        var_0 visionsetnakedforplayer( "mp_gxp_safespace", 0.2 );
        playfxontagforclients( scripts\engine\utility::getfx( "gxp_safe_zone_player_eye" ), var_0, "tag_eye", var_0 );
        var_0.play_approach_building_two = isdefined( level.completesmokinggunquest.safezonehallucinations ) && level.completesmokinggunquest.safezonehallucinations <= 0;
        scripts\mp\gametypes\br_gametype_gxp_challenges.gsc::on_player_entered_safe_zone( var_0, var_1 );
        var_0 playsoundtoplayer( "br_gov_safespace_enter", var_0 );

        if ( isdefined( var_0.safespaceloopsound ) )
        {
            var_0.safespaceloopsound stoploopsound();
            var_0.safespaceloopsound delete();
        }

        var_0.safespaceloopsound = spawn( "script_origin", self.origin );
        var_0.safespaceloopsound linkto( var_0 );
        var_0.safespaceloopsound hide();
        var_0.safespaceloopsound showtoplayer( var_0 );
        var_0.safespaceloopsound playloopsound( "br_gov_safespace_lp" );
    }
    else
    {
        var_2 = gettime();

        if ( !isdefined( var_0.safezoneghostvotime ) || var_0.safezoneghostvotime < var_2 )
        {
            var_3 = getdvarint( "scr_br_safe_zones_ghost_vo_min", 45 );
            var_4 = getdvarint( "scr_br_safe_zones_ghost_vo_max", 60 );
            var_5 = var_3 * 1000;
            var_6 = var_4 * 1000;
            scripts\mp\gametypes\br_public.gsc::cpcpammoarmorcratecapturecallback( "safe_zone_ghost_vo", var_0 );
            var_0.safezoneghostvotime = var_2 + randomintrange( var_5, var_6 );
        }
    }
}

playerexitsafezonestopfx( var_0 )
{
    stopfxontagforclients( scripts\engine\utility::getfx( "gxp_safe_zone_player_eye" ), var_0, "tag_eye", var_0 );
    wait 0.5;

    if ( isdefined( var_0 ) )
        stopfxontagforclients( scripts\engine\utility::getfx( "gxp_safe_zone_player_eye" ), var_0, "tag_eye", var_0 );
}

weapon_xp_iw8_sm_uzulu( var_0, var_1 )
{
    if ( !isplayer( var_0 ) )
        return;

    if ( !var_0 scripts\mp\gametypes\br_public.gsc::zombie() || isdefined( var_0.safespaceloopsound ) )
    {
        var_0 visionsetnakedforplayer( "", 0.2 );
        var_0 thread playerexitsafezonestopfx( var_0 );
        var_0.play_approach_building_two = 0;
        level._id_120E5._id_120E1 = scripts\engine\utility::array_remove( level._id_120E5._id_120E1, var_0 );
        var_0 playsoundtoplayer( "br_gov_safespace_exit", var_0 );

        if ( isdefined( var_0.safespaceloopsound ) )
        {
            var_0.safespaceloopsound stoploopsound();
            var_0.safespaceloopsound delete();
            var_0.safespaceloopsound = undefined;
        }
    }
}

_id_120E6()
{
    level endon( "game_ended" );
    var_0 = getdvarint( "scr_br_safe_zones_human_vo_min", 45 );
    var_1 = getdvarint( "scr_br_safe_zones_human_vo_max", 60 );
    var_2 = var_0 * 1000;
    var_3 = var_1 * 1000;

    for (;;)
    {
        var_4 = gettime();
        var_5 = [];

        foreach ( var_7 in level._id_120E5._id_120E1 )
        {
            if ( !isdefined( var_7 ) )
                continue;

            if ( !isalive( var_7 ) )
                continue;

            if ( var_7 scripts\mp\gametypes\br_public.gsc::zombie() )
                continue;

            if ( !isdefined( var_7._id_120E7 ) || var_7._id_120E7 < var_4 )
            {
                scripts\mp\gametypes\br_public.gsc::cpcpammoarmorcratecapturecallback( "safe_zone_human_vo", var_7 );
                var_7._id_120E7 = var_4 + randomintrange( var_2, var_3 );
            }

            var_5[var_5.size] = var_7;
        }

        level._id_120E5._id_120E1 = var_5;
        waitframe();
    }
}
