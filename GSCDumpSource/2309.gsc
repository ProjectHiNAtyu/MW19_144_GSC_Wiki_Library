// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

gas_used( var_0 )
{
    self endon( "disconnect" );
    var_0 endon( "death" );
    scripts\mp\utility\print::printgameaction( "gasGrenade spawn", var_0.owner );
    thread scripts\mp\weapons::monitordisownedgrenade( self, var_0 );
    var_0 waittill( "missile_stuck", var_1 );
    thread gas_watchexplode( var_0 );
    var_0 detonate();
}

gas_watchexplode( var_0 )
{
    var_0 thread scripts\mp\utility\script::notifyafterframeend( "death", "end_explode" );
    var_0 endon( "end_explode" );
    var_1 = var_0.owner;
    var_0 waittill( "explode", var_2 );
    thread gas_createtrigger( var_2, var_1 );
}

gas_onplayerdamaged( var_0 )
{
    if ( var_0.meansofdeath == "MOD_IMPACT" )
        return 1;

    if ( var_0.attacker == var_0.victim )
    {
        if ( distancesquared( var_0.point, var_0.victim.origin ) > 30625 )
            return 0;
    }
    else
    {
        var_0.attacker scripts\mp\damage::combatrecordtacticalstat( "equip_gas_grenade" );
        var_0.attacker scripts\mp\utility\stats::incpersstat( "gasHits", 1 );

        if ( var_0.victim scripts\mp\utility\perk::_hasperk( "specialty_gas_grenade_resist" ) )
            var_0.attacker scripts\mp\damagefeedback::updatedamagefeedback( "hittacresist", undefined, undefined, undefined, 1 );
    }

    var_0.victim thread gas_applycough( var_0.attacker, 1 );
    return 1;
}

gas_clear( var_0 )
{
    gas_clearspeedredux( var_0 );
    gas_clearblur( var_0 );
    gas_clearcough( var_0 );

    if ( isdefined( self.gastriggerstouching ) )
    {
        foreach ( var_2 in self.gastriggerstouching )
        {
            if ( !isdefined( var_2 ) )
                continue;

            var_2.playersintrigger[self getentitynumber()] = undefined;
        }
    }

    self.gastriggerstouching = undefined;
}

gas_createtrigger( var_0, var_1, var_2, var_3 )
{
    if ( !isdefined( var_2 ) )
        var_2 = 7;

    if ( !isdefined( var_3 ) )
        var_3 = 1;

    var_4 = spawn( "trigger_radius", var_0 + ( 0, 0, int( -57.75 * var_3 ) ), 0, int( 256 * var_3 ), int( 175 * var_3 ) );
    var_4 scripts\cp_mp\ent_manager::registerspawn( 1, ::sweepgas );
    var_5 = lootleadermarksontopteams( var_0, var_3 );

    if ( isdefined( var_5 ) )
        var_4 thread lootleadermarks( var_5, var_2 );

    var_4 endon( "death" );
    var_4.owner = var_1;

    if ( isdefined( var_1 ) )
        var_4.team = var_1.team;

    var_4.playersintrigger = [];
    var_4 thread gas_watchtriggerenter();
    var_4 thread gas_watchtriggerexit();
    wait( var_2 );
    var_4 thread gas_destroytrigger();
}

lootleadermarksontopteams( var_0, var_1 )
{
    if ( !scripts\mp\bots\bots_util::bot_bots_enabled_or_added() && !scripts\mp\utility\game::clip_ent() )
        return;

    var_2 = createnavbadplacebybounds( var_0, ( 256 * var_1, 256 * var_1, 175 * var_1 ), ( 0, 0, 0 ) );
    return var_2;
}

lootleadermarks( var_0, var_1 )
{
    scripts\engine\utility::waittill_notify_or_timeout( "entitydeleted", var_1 );
    destroynavobstacle( var_0 );
}

sweepgas()
{
    thread gas_destroytrigger();
}

gas_destroytrigger()
{
    foreach ( var_1 in self.playersintrigger )
    {
        if ( !isdefined( var_1 ) )
            continue;

        self.playersintrigger[var_1 getentitynumber()] = undefined;
        var_1 thread gas_onexittrigger( self getentitynumber() );
    }

    scripts\cp_mp\ent_manager::deregisterspawn();
    self delete();
}

gas_onentertrigger( var_0 )
{
    if ( !isdefined( self.gastriggerstouching ) )
        self.gastriggerstouching = [];

    var_1 = var_0 getentitynumber();
    self.gastriggerstouching[var_1] = var_0;
    self.lastgastouchtime = gettime();

    if ( self.gastriggerstouching.size >= 1 )
    {
        thread gas_applyspeedredux();
        thread gas_applyblur();
    }

    if ( self.gastriggerstouching.size == 1 )
    {
        thread gas_applycough( var_0.owner, 0 );
        scripts\cp_mp\killstreaks\white_phosphorus::enableloopingcoughaudio();
    }

    return var_1;
}

gas_onexittrigger( var_0 )
{
    if ( !isdefined( self.gastriggerstouching ) )
        return;

    self.gastriggerstouching[var_0] = undefined;
    self.lastgastouchtime = gettime();

    if ( self.gastriggerstouching.size == 0 )
    {
        thread gas_removespeedredux();
        thread gas_removeblur();
        scripts\cp_mp\killstreaks\white_phosphorus::disableloopingcoughaudio();
        self notify( "gas_exited" );
    }
}

gas_watchtriggerenter()
{
    self endon( "death" );

    for (;;)
    {
        self waittill( "trigger", var_0 );

        if ( !isplayer( var_0 ) )
            continue;

        if ( istrue( var_0.maderecentkill ) )
            continue;

        if ( var_0 scripts\mp\utility\killstreak::isjuggernaut() )
            continue;

        if ( !var_0 scripts\cp_mp\utility\player_utility::_isalive() )
            continue;

        if ( isdefined( self.playersintrigger[var_0 getentitynumber()] ) )
            continue;

        if ( level.teambased )
        {
            if ( isdefined( self.owner ) )
            {
                if ( var_0 != self.owner && !scripts\cp_mp\utility\player_utility::playersareenemies( var_0, self.owner ) )
                    continue;
            }
            else if ( isdefined( self.team ) && scripts\mp\utility\player::isfriendly( self.team, var_0 ) )
                continue;
        }

        self.playersintrigger[var_0 getentitynumber()] = var_0;
        var_0 thread gas_onentertrigger( self );
    }
}

gas_watchtriggerexit()
{
    self endon( "death" );

    for (;;)
    {
        foreach ( var_2, var_1 in self.playersintrigger )
        {
            if ( !isdefined( var_1 ) )
            {
                self.playersintrigger[var_2] = undefined;
                continue;
            }

            if ( !var_1 scripts\cp_mp\utility\player_utility::_isalive() )
                continue;

            if ( var_1 istouching( self ) )
                continue;

            self.playersintrigger[var_1 getentitynumber()] = undefined;
            var_1 thread gas_onexittrigger( self getentitynumber() );
        }

        waitframe();
    }
}

gas_applycough( var_0, var_1 )
{
    var_2 = scripts\mp\utility\perk::_hasperk( "specialty_gas_grenade_resist" );
    var_3 = isdefined( var_0 ) && self == var_0;

    if ( !var_3 && var_2 )
        return;

    if ( istrue( self.maderecentkill ) )
        return;

    var_4 = 0;

    if ( istrue( var_1 ) )
    {
        var_4 = 1;

        if ( var_3 )
            var_4 = 0;
    }

    if ( !istrue( self.gascoughinprogress ) || istrue( var_1 ) )
        thread gas_queuecough( var_4 );
}

gas_queuecough( var_0 )
{
    self endon( "death_or_disconnect" );
    self endon( "gas_clear_cough" );
    self endon( "gas_exited" );
    self notify( "gas_queue_cough" );
    self endon( "gas_queue_cough" );
    var_1 = gettime() + 1000;

    while ( gas_coughisblocked() )
        waitframe();

    if ( var_0 && gettime() > var_1 )
        var_0 = 0;

    var_2 = getdvarint( "scr_equipCoughInterruptsADS", 1 ) == 1;

    if ( var_2 )
        thread gas_begincoughing( var_0 );
    else
    {
        self endon( "gas_begin_coughing" );
        self.gascoughinprogress = 1;

        if ( var_0 )
        {
            self playgestureviewmodel( "iw8_ges_teargas_cough" );
            wait 3.33;
        }
        else
        {
            self playgestureviewmodel( "iw8_ges_teargas_cough_long" );
            wait 1.833;
        }

        self.gascoughinprogress = undefined;
    }
}

gas_begincoughing( var_0 )
{
    self endon( "death_or_disconnect" );
    self endon( "gas_clear_cough" );
    self notify( "gas_begin_coughing" );
    self endon( "gas_begin_coughing" );

    if ( !nullweapon( self getheldoffhand() ) )
        childthread gas_takeheldoffhand();

    self.gascoughinprogress = 1;

    if ( self hasweapon( getcompleteweaponname( "gas_cough_light_mp" ) ) )
        scripts\cp_mp\utility\inventory_utility::_takeweapon( "gas_cough_light_mp" );

    if ( self hasweapon( getcompleteweaponname( "gas_cough_heavy_mp" ) ) )
        scripts\cp_mp\utility\inventory_utility::_takeweapon( "gas_cough_heavy_mp" );

    var_1 = scripts\engine\utility::ter_op( istrue( var_0 ), getcompleteweaponname( "gas_cough_heavy_mp" ), getcompleteweaponname( "gas_cough_light_mp" ) );
    var_2 = scripts\engine\utility::ter_op( istrue( var_0 ), 3.33, 1.833 );
    self giveandfireoffhand( var_1 );
    childthread gas_monitorcoughweaponfired( var_1 );
    childthread gas_monitorcoughweapontaken( var_1 );
    childthread gas_monitorcoughduration( var_2 );
    scripts\engine\utility::_id_133F0( "gas_coughWeaponFired", "gas_coughWeaponTaken", "gas_coughDuration" );

    if ( self hasweapon( var_1 ) )
        scripts\cp_mp\utility\inventory_utility::_takeweapon( var_1 );

    self.gascoughinprogress = undefined;
}

gas_removecough( var_0 )
{
    self notify( "gas_queue_cough" );
    self notify( "gas_begin_coughing" );
    self.gascoughinprogress = undefined;

    if ( !istrue( var_0 ) )
    {
        if ( isdefined( self.gastakenweaponobj ) )
            gas_restoreheldoffhand();
    }
}

gas_clearcough( var_0 )
{
    self notify( "gas_queue_cough" );
    self notify( "gas_begin_coughing" );
    self.gascoughinprogress = undefined;

    if ( !istrue( var_0 ) )
    {
        var_1 = getdvarint( "scr_equipCoughInterruptsADS", 1 ) == 1;

        if ( var_1 )
        {
            if ( self hasweapon( getcompleteweaponname( "gas_cough_light_mp" ) ) )
                scripts\cp_mp\utility\inventory_utility::_takeweapon( "gas_cough_light_mp" );

            if ( self hasweapon( getcompleteweaponname( "gas_cough_heavy_mp" ) ) )
                scripts\cp_mp\utility\inventory_utility::_takeweapon( "gas_cough_heavy_mp" );

            if ( isdefined( self.gastakenweaponobj ) )
                gas_restoreheldoffhand();
        }
        else
        {
            self stopgestureviewmodel( "iw8_ges_teargas_cough" );
            self stopgestureviewmodel( "iw8_ges_teargas_cough_long" );
        }
    }
}

gas_monitorcoughweaponfired( var_0 )
{
    self endon( "gas_coughWeaponTaken" );
    self endon( "gas_coughDuration" );

    for (;;)
    {
        self waittill( "offhand_fired", var_1 );

        if ( isnullweapon( var_1, var_0 ) )
            break;
    }

    self notify( "gas_coughWeaponFired" );
}

gas_monitorcoughweapontaken( var_0 )
{
    self endon( "gas_coughWeaponFired" );
    self endon( "gas_coughDuration" );

    while ( self hasweapon( var_0 ) )
        waitframe();

    self notify( "gas_coughWeaponTaken" );
}

gas_monitorcoughduration( var_0 )
{
    self endon( "gas_coughWeaponTaken" );
    self endon( "gas_coughWeaponFired" );
    wait( var_0 );
    self notify( "gas_coughDuration" );
}

gas_takeheldoffhand()
{
    if ( isdefined( self.gastakenweaponobj ) )
        gas_restoreheldoffhand();

    self endon( "gas_restoreHeldOffhand" );
    self.gastakenweaponobj = self getheldoffhand();
    var_0 = scripts\mp\equipment::getequipmentreffromweapon( self.gastakenweaponobj );

    if ( isdefined( var_0 ) && scripts\mp\equipment::hasequipment( var_0 ) )
    {
        self.gastakenweaponammo = scripts\mp\equipment::getequipmentammo( var_0 );
        scripts\cp_mp\utility\inventory_utility::_takeweapon( self.gastakenweaponobj );
        waitframe();
        thread gas_restoreheldoffhand();
    }

    var_1 = scripts\mp\supers::getsuperrefforsuperoffhand( self.gastakenweaponobj );

    if ( isdefined( var_1 ) )
    {
        var_2 = scripts\mp\supers::getcurrentsuperref();

        if ( isdefined( var_2 ) && var_2 == var_1 )
        {
            self.gastakenweaponammo = self getammocount( self.gastakenweaponobj );
            scripts\cp_mp\utility\inventory_utility::_takeweapon( self.gastakenweaponobj );
            waitframe();
            thread gas_restoreheldoffhand();
        }
    }

    var_3 = scripts\mp\utility\weapon::isgesture( self.gastakenweaponobj );

    if ( var_3 )
    {
        scripts\cp_mp\utility\inventory_utility::_takeweapon( self.gastakenweaponobj );
        waitframe();
        thread gas_restoreheldoffhand();
    }

    self.gastakenweaponammo = self getammocount( self.gastakenweaponobj );
    scripts\cp_mp\utility\inventory_utility::_takeweapon( self.gastakenweaponobj );
    waitframe();
    thread gas_restoreheldoffhand();
}

gas_restoreheldoffhand()
{
    self notify( "gas_restoreHeldOffhand" );
    var_0 = scripts\mp\equipment::getequipmentreffromweapon( self.gastakenweaponobj );

    if ( isdefined( var_0 ) && scripts\mp\equipment::hasequipment( var_0 ) )
    {
        if ( scripts\mp\equipment::hasequipment( var_0 ) )
        {
            scripts\cp_mp\utility\inventory_utility::_giveweapon( self.gastakenweaponobj );
            var_1 = scripts\mp\equipment::findequipmentslot( var_0 );

            if ( var_1 == "primary" )
                self assignweaponoffhandprimary( self.gastakenweaponobj );
            else if ( var_1 == "secondary" )
                self assignweaponoffhandsecondary( self.gastakenweaponobj );

            scripts\mp\equipment::setequipmentammo( var_0, self.gastakenweaponammo );
            self.gastakenweaponobj = undefined;
            self.gastakenweaponammo = undefined;
        }

        return;
    }

    var_2 = scripts\mp\supers::getsuperrefforsuperoffhand( self.gastakenweaponobj );

    if ( isdefined( var_2 ) )
    {
        var_3 = scripts\mp\supers::getcurrentsuperref();

        if ( isdefined( var_3 ) && var_3 == var_2 )
        {
            scripts\cp_mp\utility\inventory_utility::_giveweapon( self.gastakenweaponobj );
            self assignweaponoffhandspecial( self.gastakenweaponobj );
            self setweaponammoclip( self.gastakenweaponobj, self.gastakenweaponammo );
            self.gastakenweaponobj = undefined;
            self.gastakenweaponammo = undefined;
        }

        return;
    }

    var_4 = scripts\mp\utility\weapon::isgesture( self.gastakenweaponobj );

    if ( var_4 )
    {
        if ( isdefined( self.gestureweapon ) && self.gestureweapon == self.gastakenweaponobj.basename )
        {
            scripts\cp_mp\utility\inventory_utility::_giveweapon( self.gastakenweaponobj );
            self.gastakenweaponobj = undefined;
        }

        return;
    }

    scripts\cp_mp\utility\inventory_utility::_giveweapon( self.gastakenweaponobj );
    self setweaponammoclip( self.gastakenweaponobj, self.gastakenweaponammo );
    self.gastakenweaponobj = undefined;
    self.gastakenweaponammo = undefined;
}

gas_applyspeedredux()
{
    self endon( "death_or_disconnect" );
    self notify( "gas_modify_speed" );
    self endon( "gas_modify_speed" );

    if ( isdefined( self.gasspeedmod ) )
    {
        if ( self.gasspeedmod < -0.15 )
        {
            if ( scripts\mp\utility\perk::_hasperk( "specialty_gas_grenade_resist" ) )
            {
                self.gasspeedmod = -0.15;
                scripts\mp\weapons::updatemovespeedscale();
                return;
            }

            if ( isdefined( self.gastriggerstouching ) )
            {
                foreach ( var_1 in self.gastriggerstouching )
                {
                    if ( isdefined( var_1 ) && isdefined( var_1.owner ) && var_1.owner == self )
                    {
                        self.gasspeedmod = -0.15;
                        scripts\mp\weapons::updatemovespeedscale();
                        return;
                    }
                }
            }
        }
    }
    else
        self.gasspeedmod = 0;

    var_3 = -0.35;

    if ( scripts\mp\utility\perk::_hasperk( "specialty_gas_grenade_resist" ) )
        var_3 = -0.15;
    else if ( isdefined( self.gastriggerstouching ) )
    {
        foreach ( var_1 in self.gastriggerstouching )
        {
            if ( isdefined( var_1 ) && isdefined( var_1.owner ) && var_1.owner == self )
                var_3 = -0.15;
        }
    }

    gas_modifyspeed( var_3 );
    self.gasspeedmod = var_3;
    scripts\mp\weapons::updatemovespeedscale();
}

gas_removespeedredux()
{
    self endon( "death_or_disconnect" );
    self notify( "gas_modify_speed" );
    self endon( "gas_modify_speed" );

    if ( !isdefined( self.gasspeedmod ) )
        return;

    gas_modifyspeed( 0 );
    self.gasspeedmod = undefined;
    scripts\mp\weapons::updatemovespeedscale();
}

gas_modifyspeed( var_0 )
{
    var_1 = 0;

    while ( var_1 <= 0.65 )
    {
        var_1 = var_1 + 0.05;
        self.gasspeedmod = scripts\engine\math::lerp( self.gasspeedmod, var_0, min( 1, var_1 / 0.65 ) );
        scripts\mp\weapons::updatemovespeedscale();
        wait 0.05;
    }
}

gas_clearspeedredux( var_0 )
{
    self notify( "gas_modify_speed" );
    self.gasspeedmod = undefined;

    if ( !istrue( var_0 ) )
        scripts\mp\weapons::updatemovespeedscale();
}

gas_applyblur()
{
    self endon( "death_or_disconnect" );
    self notify( "gas_modify_blur" );
    self endon( "gas_modify_blur" );
    var_0 = "gas_grenade_heavy_mp";

    if ( scripts\mp\utility\perk::_hasperk( "specialty_gas_grenade_resist" ) )
        var_0 = "gas_grenade_light_mp";
    else if ( isdefined( self.gastriggerstouching ) )
    {
        foreach ( var_2 in self.gastriggerstouching )
        {
            if ( isdefined( var_2 ) && isdefined( var_2.owner ) && var_2.owner == self )
                var_0 = "gas_grenade_light_mp";
        }
    }

    for (;;)
    {
        scripts\cp_mp\utility\shellshock_utility::_shellshock( var_0, "gas", 0.5, 0 );
        wait 0.2;
    }
}

gas_removeblur()
{
    self notify( "gas_modify_blur" );
}

gas_clearblur( var_0 )
{
    self notify( "gas_modify_blur" );

    if ( !istrue( var_0 ) )
        scripts\cp_mp\utility\shellshock_utility::_stopshellshock();
}

gas_shouldtakeheldoffhand()
{
    switch ( self getheldoffhand().basename )
    {
        case "super_delay_mp":
            return 0;
        default:
            return 1;
    }

    return 0;
}

gas_coughisblocked()
{
    if ( !scripts\common\utility::is_cough_gesture_allowed() )
        return 1;

    if ( !scripts\common\utility::is_offhand_weapons_allowed() )
        return 1;

    if ( !nullweapon( self getheldoffhand() ) && !gas_shouldtakeheldoffhand() )
        return 1;

    return 0;
}

gas_isintrigger()
{
    if ( !isdefined( self.gastriggerstouching ) )
        return 0;

    if ( self.gastriggerstouching.size == 0 )
        return 0;

    return 1;
}

gas_updateplayereffects()
{
    if ( scripts\mp\utility\killstreak::isjuggernaut() )
    {
        gas_clear();
        return;
    }

    if ( gas_isintrigger() )
    {
        thread gas_applyspeedredux();
        thread gas_applyblur();
    }
}

gas_getblurinterruptdelayms( var_0 )
{
    return 200.0;
}

lootleadermarkweakvalue( var_0, var_1 )
{
    if ( isdefined( var_1.gastriggerstouching ) && var_1.gastriggerstouching.size > 0 )
    {
        foreach ( var_3 in var_1.gastriggerstouching )
        {
            if ( isdefined( var_3.owner ) && var_3.owner == var_0 )
                return 1;
        }
    }

    return 0;
}
