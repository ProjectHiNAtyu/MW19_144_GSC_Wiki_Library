// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

uniquepoolid( var_0, var_1 )
{
    if ( !isdefined( var_0 ) || !isdefined( var_1 ) )
        return;

    foreach ( var_3 in level.mines )
    {
        if ( !isdefined( var_3.equipmentref ) || var_3.equipmentref != "equip_claymore" )
            continue;

        if ( !isdefined( var_3.owner ) || !scripts\cp_mp\utility\player_utility::playersareenemies( var_0, var_3.owner ) )
            continue;

        if ( distancesquared( var_1, var_3.origin ) < 262144 )
            var_3 thread scripts\mp\equipment\claymore::extractplunderhelihealth( var_0 );
    }
}

onplayerdamaged( var_0 )
{
    var_1 = var_0.victim;
    var_2 = var_0.attacker;
    var_3 = var_0.point;

    if ( var_0.meansofdeath == "MOD_IMPACT" )
        return 1;

    if ( var_2 == var_1 && distancesquared( var_3, var_1.origin ) > 65536 )
        return 0;

    if ( !isdefined( var_0.inflictor ) )
        return 0;

    var_1 thread applyconcussion( var_0.inflictor, var_2 );
    var_2 scripts\mp\damage::combatrecordtacticalstat( "equip_concussion" );
    var_2 scripts\mp\utility\stats::incpersstat( "stunHits", 1 );
    return 1;
}

applyconcussion( var_0, var_1 )
{
    if ( scripts\mp\utility\player::isusingremote() )
        return;

    if ( istrue( self.friendly_hvi_vehicle_extra_riders_intro_scene ) )
        return;

    if ( scripts\mp\utility\game::getgametype() == "arena" || level.gametype == "br" && var_1 scripts\mp\gametypes\br_public.gsc::isplayeringulag() )
    {
        var_2 = level.tacticaltimemod;
        var_3 = level.tacticaltimemod;
    }
    else
    {
        var_2 = 3;
        var_3 = 3;
    }

    var_4 = self == var_1;

    if ( var_4 )
    {
        if ( scripts\mp\utility\game::getgametype() == "arena" || level.gametype == "br" && var_1 scripts\mp\gametypes\br_public.gsc::isplayeringulag() )
        {
            var_2 = max( level.tacticaltimemod - 1, 0.5 );
            var_3 = max( level.tacticaltimemod - 1, 0.5 );
        }
        else
        {
            var_2 = 2;
            var_3 = 2;
        }
    }

    var_5 = 1 - distance( self.origin, var_0.origin ) / 512;

    if ( var_5 < 0 )
        var_5 = 0;

    if ( scripts\mp\utility\game::getgametype() == "arena" )
        var_6 = var_2;
    else
        var_6 = var_2 + var_3 * var_5;

    if ( getdvar( "scr_br_gametype" ) == "dbd" )
        var_6 = var_6 * getdvarfloat( "scr_br_stunscalar", 0.5 );

    var_6 = scripts\mp\perks\perkfunctions::applystunresistence( var_1, self, var_6 );
    var_1 scripts\cp\helicopter\chopper_boss::unstable_gauge_timer_active( "equip_concussion" );
    thread scripts\mp\gamescore::trackdebuffassistfortime( var_1, self, "concussion_grenade_mp", var_6 );
    var_1 notify( "stun_hit" );
    self notify( "concussed", var_1 );
    scripts\mp\weapons::setplayerstunned();
    thread scripts\mp\weapons::cleanupconcussionstun( var_6 );
    scripts\cp_mp\utility\shellshock_utility::_shellshock( "concussion_grenade_mp", "stun", var_6, 1 );
}

calculateinterruptdelay( var_0 )
{
    return max( 0, var_0 - 2.6 ) * 1000;
}
