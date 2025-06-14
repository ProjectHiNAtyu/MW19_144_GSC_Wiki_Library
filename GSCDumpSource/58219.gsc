// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    scripts\mp\killstreaks\killstreaks::registerkillstreak( "explosive_bow", ::_id_12EF1, undefined, ::_id_12EDA );
    init_fx();
}

init_fx()
{
    level._effect["vfx_explosive_bow_explosion"] = loadfx( "vfx/iw8/weap/_explo/vfx_explo_explosive_bow.vfx" );
}

_id_12EF1( var_0 )
{
    var_1 = self;
    var_2 = var_1 _id_12EF2( var_0 );

    if ( !var_2 )
    {
        if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "hud", "showErrorMessage" ) )
            self [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "hud", "showErrorMessage" ) ]]( "KILLSTREAKS/CANNOT_BE_USED" );
    }

    return var_2;
}

_id_12EDA()
{
    var_0 = scripts\cp_mp\utility\killstreak_utility::createstreakinfo( "explosive_bow", self );
    var_0._id_125AA = 1;
    return _id_12EF2( var_0, 1 );
}

display_hint_for_all()
{
    if ( self hasweapon( "iw8_sn_t9explosivebow_mp" ) )
        return 0;

    if ( self isonladder() )
        return 0;

    if ( self ismantling() )
        return 0;

    if ( !scripts\common\utility::is_weapon_switch_allowed() )
        return 0;

    if ( scripts\cp_mp\utility\player_utility::isusingremote() )
        return 0;

    if ( istrue( self.usingascender ) )
        return 0;

    return 1;
}

_id_12EF2( var_0, var_1 )
{
    self endon( "disconnect" );
    level endon( "game_ended" );

    if ( !display_hint_for_all() )
        return 0;

    if ( isdefined( level.killstreaktriggeredfunc ) )
    {
        if ( !level [[ level.killstreaktriggeredfunc ]]( var_0 ) )
            return 0;
    }

    if ( isdefined( level.killstreakbeginusefunc ) )
    {
        if ( !level [[ level.killstreakbeginusefunc ]]( var_0 ) )
            return 0;
    }

    var_2 = handleheadshotkillrewardbullets();

    if ( !istrue( var_2 ) )
        return var_2;

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "killstreak", "logKillstreakEvent" ) )
        self [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "killstreak", "logKillstreakEvent" ) ]]( var_0.streakname, self.origin );

    if ( scripts\cp_mp\utility\script_utility::issharedfuncdefined( "hud", "teamPlayerCardSplash" ) )
        self thread [[ scripts\cp_mp\utility\script_utility::getsharedfunc( "hud", "teamPlayerCardSplash" ) ]]( "used_" + var_0.streakname, self );

    return 1;
}

handleheadshotkillrewardbullets()
{
    scripts\common\utility::blink_wheelson_chosen_spawn( 0, "explosive_bow" );
    thread initlocs_phones();
    var_0 = scripts\mp\utility\weapon::getweaponrootname( "iw8_sn_t9explosivebow_mp" );
    var_1 = scripts\mp\class::delay_show_balloon( var_0, undefined, undefined, -1, undefined, undefined, 0 );
    self.brtruck_initfeatures = 1;

    if ( self hasweapon( var_1 ) )
        scripts\cp_mp\utility\inventory_utility::_takeweapon( var_1 );

    self giveweapon( var_1 );

    if ( isdefined( self.power_checkifequipmentammofull ) && self.power_checkifequipmentammofull )
    {
        self setweaponammoclip( var_1, 1 );
        self setweaponammostock( var_1, self.power_checkifequipmentammofull - 1 );
        self.power_checkifequipmentammofull = undefined;
    }
    else
    {
        self setweaponammoclip( var_1, weaponclipsize( var_1 ) );
        self setweaponammostock( var_1, weaponstartammo( var_1, 0 ) );
    }

    scripts\cp_mp\utility\inventory_utility::_switchtoweaponimmediate( var_1 );
    scripts\mp\weapons::fixupplayerweapons( self, var_0 );
    self.power_checkifequipmentammofull = self getammocount( var_1 );
    self notify( "explosive_bow_equipped" );
    thread _id_13523( var_1, "weapon_taken" );
    thread _id_13523( var_1, "weapon_dropped" );
    thread _id_134D0( var_1 );
    thread _id_13525( var_1 );
    thread _id_1351C( var_1 );
    thread _id_134CB( var_1 );
    return 1;
}

initlocs_phones()
{
    self endon( "disconnect" );
    wait 0.3;

    if ( isdefined( self ) )
        scripts\common\utility::blink_wheelson_chosen_spawn( 1, "explosive_bow" );
}

_id_13523( var_0, var_1 )
{
    self endon( "disconnect" );
    self endon( "exit_bow" );

    for (;;)
    {
        self waittill( var_1, var_2 );

        if ( var_2 == var_0 )
            _id_12A5B( var_0 );

        waitframe();
    }
}

_id_134D0( var_0 )
{
    self endon( "disconnect" );
    self endon( "stop_explosive_bow_cancel_watcher" );
    self waittill( "cancel_all_killstreak_deployments" );
    self notify( "exit_bow" );
    thread failhistoryquest();
    scripts\cp_mp\utility\inventory_utility::getridofweapon( var_0 );
    thread init_relic_damage_from_above();
}

_id_13525( var_0 )
{
    self endon( "disconnect" );
    self endon( "exit_bow" );

    for (;;)
    {
        self waittill( "weapon_change", var_1 );

        if ( self hasweapon( var_0 ) && var_1 != var_0 )
        {
            if ( var_1.basename == "armor_plate_deploy_mp" )
            {
                self.chopperexfil_skip_ascend1 = self.lastdroppableweaponobj;
                scripts\mp\weapons::_id_12391( var_0 );
            }
            else if ( !self isonladder() && !( var_1.ismelee && self ismeleeing() ) )
                _id_12A5B( var_0 );

            continue;
        }

        if ( var_1 == var_0 && isdefined( self.chopperexfil_skip_ascend1 ) )
        {
            scripts\mp\weapons::_id_12391( self.chopperexfil_skip_ascend1 );
            self.chopperexfil_skip_ascend1 = undefined;
        }
    }
}

_id_1351C( var_0 )
{
    self endon( "disconnect" );
    self endon( "exit_bow" );

    for (;;)
    {
        self waittill( "weapon_fired" );

        if ( !self hasweapon( var_0 ) )
        {
            self notify( "stop_explosive_bow_cancel_watcher" );
            thread failhistoryquest();
            return;
        }

        self.power_checkifequipmentammofull = self getammocount( var_0 );

        if ( self.power_checkifequipmentammofull == 0 )
        {
            self.power_checkifequipmentammofull = undefined;
            thread failhistoryquest();
            thread _id_13518( var_0 );
            self notify( "stop_explosive_bow_cancel_watcher" );
            self notify( "exit_bow" );
        }

        waitframe();
    }
}

_id_13518( var_0 )
{
    self endon( "disconnect" );
    self waittill( "weapon_change", var_1 );
    self takeweapon( var_0 );
}

_id_134CB( var_0 )
{
    self endon( "disconnect" );
    self endon( "cleanup_explosive_bow" );

    for (;;)
    {
        self waittill( "bullet_first_impact", var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8 );

        if ( var_5 == var_0 )
        {
            var_9 = vectortoangles( var_3 );
            var_10 = anglestoforward( var_9 );
            var_11 = anglestoright( var_9 );
            var_12 = anglestoup( var_9 );
            var_13 = playfx( scripts\engine\utility::getfx( "vfx_explosive_bow_explosion" ), var_7, var_10, var_12 );
            var_13 forcenetfieldhighlod( 1 );
            playsoundatpos( var_7, "frag_grenade_expl_trans" );
            earthquake( 0.45, 0.7, var_7, 800 );
            playrumbleonposition( "grenade_rumble", var_7 );
            physicsexplosionsphere( var_7, 800, 0, 1 );
        }
    }
}

failhistoryquest()
{
    self endon( "disconnect" );
    self endon( "explosive_bow_equipped" );
    self endon( "cleanup_explosive_bow" );
    self.brtruck_initfeatures = 0;
    wait 6;
    self notify( "cleanup_explosive_bow" );
}

_id_12A5B( var_0 )
{
    self takeweapon( var_0 );

    if ( isdefined( self.power_checkifequipmentammofull ) && self.power_checkifequipmentammofull != 0 )
    {
        self notify( "stop_explosive_bow_cancel_watcher" );
        little_bird_mg_enterend();
    }

    thread failhistoryquest();
    self notify( "exit_bow" );
}

init_relic_damage_from_above()
{
    var_0 = scripts\mp\gametypes\br_pickups.gsc::register_respawn_functions();
    var_1 = scripts\mp\gametypes\br_pickups.gsc::getitemdroporiginandangles( var_0, self.origin, self.angles, self );
    scripts\mp\gametypes\br_pickups.gsc::spawnpickup( "brloot_killstreak_explosive_bow", var_1 );
}

little_bird_mg_enterend()
{
    var_0 = level.gametype == "br";

    if ( var_0 )
        scripts\mp\gametypes\br_pickups.gsc::little_bird_mg_enterendinternal( "explosive_bow", 1, 0 );
    else
    {
        scripts\mp\killstreaks\killstreaks::clearkillstreaks();
        scripts\mp\killstreaks\killstreaks::awardkillstreak( "explosive_bow", "other" );
    }
}
