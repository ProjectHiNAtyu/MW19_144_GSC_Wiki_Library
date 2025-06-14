// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    if ( !isdefined( level.boxsettings ) )
        level.boxsettings = [];
}

begindeployableviamarker( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7 )
{
    thread cleanupdeployablemarkerondisconnect( var_3 );
    thread watchdeployablemarkerplacement( var_0, var_2, var_1, var_3, var_4, var_5, var_6, var_7 );
    return 1;
}

watchdeployablemarkerplacement( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7 )
{
    self endon( "spawned_player" );
    self endon( "disconnect" );

    if ( !isdefined( var_3 ) )
        return;

    if ( !isdefined( var_4 ) )
        return;

    if ( !scripts\mp\utility\player::isreallyalive( self ) )
        var_3 delete();

    var_3 makecollidewithitemclip( 1 );
    self notify( "deployable_deployed" );
    var_3.owner = self;
    var_3.weaponname = var_4;
    self.marker = var_3;

    if ( isgrenadedeployable( var_1 ) )
    {
        self thread [[ level.boxsettings[var_1].grenadeusefunc ]]( var_3 );
        return;
    }

    var_3 playsoundtoplayer( level.boxsettings[var_1].deployedsfx, self );
    var_3 thread markeractivate( var_0, var_2, var_1, ::box_setactive, var_5, var_6, var_7 );
}

cleanupdeployablemarkerondisconnect( var_0 )
{
    var_0 endon( "death" );
    var_0 endon( "late_missile_stuck" );
    var_0 thread scripts\mp\utility\script::notifyafterframeend( "missile_stuck", "late_missile_stuck" );
    self waittill( "disconnect" );
    var_0 delete();
}

override_box_moving_platform_death( var_0 )
{
    self.isdestroyed = 1;
    self notify( "death" );
}

markeractivate( var_0, var_1, var_2, var_3, var_4, var_5, var_6 )
{
    self notify( "markerActivate" );
    self endon( "markerActivate" );
    self waittill( "missile_stuck" );
    var_7 = self.owner;
    var_8 = self.origin;

    if ( !isdefined( var_7 ) )
        return;

    var_9 = createboxforplayer( var_2, var_8, var_7 );
    var_10 = spawnstruct();
    var_10.linkparent = self getlinkedparent();

    if ( isdefined( var_10.linkparent ) && isdefined( var_10.linkparent.model ) && var_10.linkparent.model != "" )
    {
        var_9.origin = var_10.linkparent.origin;
        var_11 = var_10.linkparent getlinkedparent();

        if ( isdefined( var_11 ) )
            var_10.linkparent = var_11;
        else
            var_10.linkparent = undefined;
    }

    var_10.deathoverridecallback = ::override_box_moving_platform_death;
    var_9 thread scripts\mp\movers::handle_moving_platforms( var_10 );
    var_9.moving_platform = var_10.linkparent;
    var_9 setotherent( var_7 );
    waitframe();
    var_9 thread [[ var_3 ]]( var_4, var_5, var_6 );

    if ( isdefined( level.killstreakfinishusefunc ) )
        level thread [[ level.killstreakfinishusefunc ]]( var_0 );

    self delete();

    if ( isdefined( var_9 ) && var_9 scripts\mp\utility\entity::touchingbadtrigger() )
    {
        self.isdestroyed = 1;
        var_9 notify( "death" );
    }
}

deployableexclusion( var_0 )
{
    if ( var_0 == "mp_satcom" )
        return 1;
    else if ( issubstr( var_0, "paris_catacombs_iron" ) )
        return 1;
    else if ( issubstr( var_0, "mp_warhawk_iron_gate" ) )
        return 1;

    return 0;
}

isholdingdeployablebox()
{
    var_0 = self getcurrentweapon();

    if ( isdefined( var_0 ) )
    {
        foreach ( var_2 in level.boxsettings )
        {
            if ( createheadicon( var_0 ) == var_2.weaponinfo )
                return 1;
        }
    }

    return 0;
}

createboxforplayer( var_0, var_1, var_2 )
{
    var_3 = level.boxsettings[var_0];
    var_4 = spawn( "script_model", var_1 - ( 0, 0, 1 ) );
    var_4 setmodel( var_3.modelbase );
    var_4.health = 999999;
    var_4.maxhealth = var_3.maxhealth;
    var_4.angles = var_2.angles;
    var_4.boxtype = var_0;
    var_4.owner = var_2;
    var_4.team = var_2.team;
    var_4.id = var_3.id;

    if ( isdefined( var_3.dpadname ) )
        var_4.dpadname = var_3.dpadname;

    if ( isdefined( var_3.maxuses ) )
        var_4.usesremaining = var_3.maxuses;

    var_4 box_setinactive();
    var_4 thread box_handleownerdisconnect();
    var_4 addboxtolevelarray();
    return var_4;
}

box_setactive( var_0, var_1, var_2 )
{
    self setcursorhint( "HINT_NOICON" );
    var_3 = level.boxsettings[self.boxtype];
    self sethintstring( var_3.hintstring );
    self setusehideprogressbar( 1 );
    self.inuse = 0;
    var_4 = scripts\mp\objidpoolmanager::requestobjectiveid( 1 );

    if ( var_4 == -1 )
        return;

    scripts\mp\objidpoolmanager::objective_add_objective( var_4, "invisible", ( 0, 0, 0 ) );

    if ( !isdefined( self getlinkedparent() ) )
        scripts\mp\objidpoolmanager::update_objective_position( var_4, self.origin );
    else
        scripts\mp\objidpoolmanager::update_objective_onentity( var_4, self );

    scripts\mp\objidpoolmanager::update_objective_state( var_4, "active" );
    scripts\mp\objidpoolmanager::update_objective_icon( var_4, var_3.shadername );
    scripts\mp\objidpoolmanager::update_objective_setbackground( var_4, 1 );
    self.objidfriendly = var_4;

    if ( level.teambased )
    {
        if ( var_4 != -1 )
            scripts\mp\objidpoolmanager::objective_teammask_single( var_4, self.team );

        box_seticon( self.team, var_3.streakname, var_3.headiconoffset );

        foreach ( var_6 in level.players )
        {
            if ( self.team != var_6.team )
                continue;

            if ( isdefined( var_3.canusecallback ) && !var_6 [[ var_3.canusecallback ]]( self ) )
            {
                if ( isdefined( self.boxiconid ) )
                    scripts\cp_mp\entityheadicons::_id_12385( self.boxiconid, var_6 );
            }
        }
    }
    else
    {
        if ( var_4 != -1 )
            scripts\mp\objidpoolmanager::objective_playermask_single( var_4, self.owner );

        if ( !isdefined( var_3.canusecallback ) || self.owner [[ var_3.canusecallback ]]( self ) )
            box_seticon( self.owner, var_3.streakname, var_3.headiconoffset );
    }

    self makeusable();
    self.isusable = 1;
    self setcandamage( 1 );

    if ( isdefined( var_0 ) )
        self thread [[ var_0 ]]();
    else
        thread box_handledamage();

    if ( isdefined( var_1 ) )
        self thread [[ var_1 ]]();
    else
        thread box_handledeath();

    if ( isdefined( var_2 ) )
        self thread [[ var_2 ]]();
    else
        thread box_timeout();

    scripts\mp\sentientpoolmanager::registersentient( "Tactical_Ground", self.owner );

    if ( isdefined( self.owner ) )
        self.owner notify( "new_deployable_box", self );

    if ( level.teambased )
    {
        foreach ( var_6 in level.participants )
        {
            if ( istrue( var_3.isteamless ) )
                _box_setactivehelper( var_6, 1, var_3.canusecallback );
            else
                _box_setactivehelper( var_6, self.team == var_6.team, var_3.canusecallback );

            if ( !isai( var_6 ) )
                thread box_playerjoinedteam( var_6 );
        }
    }
    else
    {
        foreach ( var_6 in level.participants )
            _box_setactivehelper( var_6, isdefined( self.owner ) && self.owner == var_6, var_3.canusecallback );
    }

    thread box_playerconnected();
    thread box_agentconnected();

    if ( isdefined( var_3.ondeploycallback ) )
        self [[ var_3.ondeploycallback ]]( var_3 );
}

_box_setactivehelper( var_0, var_1, var_2 )
{
    if ( var_1 )
    {
        if ( !isdefined( var_2 ) || var_0 [[ var_2 ]]( self ) )
            box_enableplayeruse( var_0 );
        else
        {
            box_disableplayeruse( var_0 );
            thread doubledip( var_0 );
        }

        thread boxthink( var_0 );
    }
    else
        box_disableplayeruse( var_0 );
}

box_playerconnected()
{
    self endon( "death" );

    for (;;)
    {
        level waittill( "connected", var_0 );
        childthread box_waittill_player_spawn_and_add_box( var_0 );
    }
}

box_agentconnected()
{
    self endon( "death" );

    for (;;)
    {
        level waittill( "spawned_agent_player", var_0 );
        box_addboxforplayer( var_0 );
    }
}

box_waittill_player_spawn_and_add_box( var_0 )
{
    var_0 waittill( "spawned_player" );

    if ( level.teambased )
    {
        box_addboxforplayer( var_0 );
        thread box_playerjoinedteam( var_0 );
    }
}

box_playerjoinedteam( var_0 )
{
    self endon( "death" );
    var_0 endon( "disconnect" );

    for (;;)
    {
        var_0 waittill( "joined_team" );

        if ( level.teambased )
            box_addboxforplayer( var_0 );
    }
}

box_addboxforplayer( var_0 )
{
    if ( self.team == var_0.team || istrue( level.boxsettings[self.boxtype].isteamless ) )
    {
        box_enableplayeruse( var_0 );
        thread boxthink( var_0 );
    }
    else
    {
        box_disableplayeruse( var_0 );

        if ( isdefined( self.boxiconid ) )
            scripts\cp_mp\entityheadicons::_id_12385( self.boxiconid, var_0 );
    }
}

box_seticon( var_0, var_1, var_2 )
{
    var_3 = level.boxsettings[self.boxtype];
    var_4 = scripts\mp\utility\killstreak::getkillstreakoverheadicon( var_1 );

    if ( isdefined( var_3.headicon ) )
        var_4 = var_3.headicon;

    if ( !scripts\cp_mp\utility\game_utility::isrealismenabled() )
        self.boxiconid = thread scripts\cp_mp\entityheadicons::setheadicon_singleimage( var_0, var_4, var_2, 1 );
}

box_enableplayeruse( var_0 )
{
    if ( isplayer( var_0 ) )
        self enableplayeruse( var_0 );

    self.disabled_use_for[var_0 getentitynumber()] = 0;
}

box_disableplayeruse( var_0 )
{
    if ( isplayer( var_0 ) )
        self disableplayeruse( var_0 );

    self.disabled_use_for[var_0 getentitynumber()] = 1;
}

box_setinactive()
{
    self makeunusable();
    self.isusable = 0;

    if ( isdefined( self.objidfriendly ) )
        scripts\mp\objidpoolmanager::returnobjectiveid( self.objidfriendly );
}

box_handledamage()
{
    var_0 = level.boxsettings[self.boxtype];
    scripts\mp\damage::monitordamage( var_0.maxhealth, var_0.damagefeedback, ::box_handledeathdamage, ::box_modifydamage, 1 );
}

box_modifydamage( var_0 )
{
    var_1 = var_0.attacker;
    var_2 = var_0.objweapon;
    var_3 = var_0.meansofdeath;
    var_4 = var_0.damage;
    var_5 = var_0.idflags;
    var_6 = var_4;
    var_7 = level.boxsettings[self.boxtype];

    if ( var_7.allowmeleedamage )
        var_6 = scripts\mp\damage::handlemeleedamage( var_2, var_3, var_6 );

    var_6 = scripts\mp\damage::handlemissiledamage( var_2, var_3, var_6 );
    var_6 = scripts\mp\damage::handlegrenadedamage( var_2, var_3, var_6 );
    var_6 = scripts\mp\damage::handleapdamage( var_2, var_3, var_6 );
    return var_6;
}

box_handledeathdamage( var_0 )
{
    var_1 = var_0.attacker;
    var_2 = var_0.objweapon;
    var_3 = var_0.meansofdeath;
    var_4 = var_0.damage;
    self.destroyedbydamage = 1;
    var_5 = level.boxsettings[self.boxtype];
    var_6 = scripts\mp\damage::onkillstreakkilled( "deployable_ammo", var_1, var_2, var_3, var_4, var_5.scorepopup, var_5.vodestroyed );

    if ( var_6 )
        var_1 notify( "destroyed_equipment" );
}

box_handledeath()
{
    self waittill( "death" );

    if ( !isdefined( self ) )
        return;

    box_setinactive();
    removeboxfromlevelarray();
    var_0 = level.boxsettings[self.boxtype];

    if ( !istrue( self.destroyedbydamage ) )
    {
        playfx( var_0.deathvfx, self.origin );
        self playsound( "mp_killstreak_disappear" );
    }
    else
    {
        var_1 = self.origin + ( 0, 0, var_0.headiconoffset );

        if ( isdefined( var_0.deathdamagemax ) )
        {
            var_2 = undefined;

            if ( isdefined( self.owner ) )
                var_2 = self.owner;

            if ( isdefined( var_0.explodevfx ) )
            {
                playfx( var_0.explodevfx, self.origin );
                self playsound( "c4_expl_trans" );
            }

            radiusdamage( var_1, var_0.deathdamageradius, var_0.deathdamagemax, var_0.deathdamagemin, var_2, "MOD_EXPLOSIVE", "support_box_mp" );
            thread scripts\mp\shellshock::grenade_earthquakeatposition( self.origin, 1.0 );
        }
    }

    self notify( "deleting" );
    self delete();
}

box_handleownerdisconnect()
{
    self endon( "death" );
    level endon( "game_ended" );
    self notify( "box_handleOwner" );
    self endon( "box_handleOwner" );
    childthread box_watchownerstatus( "disconnect" );
    childthread box_watchownerstatus( "joined_team" );
    childthread box_watchownerstatus( "joined_spectators" );
}

box_watchownerstatus( var_0 )
{
    self.owner waittill( var_0 );
    self.isdestroyed = 1;
    self notify( "death" );
}

boxthink( var_0 )
{
    self endon( "death" );
    thread boxcapturethink( var_0 );

    if ( !isdefined( var_0.boxes ) )
        var_0.boxes = [];

    var_0.boxes[var_0.boxes.size] = self;
    var_1 = level.boxsettings[self.boxtype];

    for (;;)
    {
        self waittill( "captured", var_2 );

        if ( var_2 == var_0 )
        {
            var_0 playlocalsound( var_1.onusesfx );

            if ( isdefined( var_1.onusecallback ) )
                var_0 [[ var_1.onusecallback ]]( self );

            if ( isdefined( self.owner ) && var_0 != self.owner && !scripts\cp_mp\utility\player_utility::playersareenemies( self.owner, var_0 ) )
                self.owner thread scripts\mp\utility\points::giveunifiedpoints( "support", undefined, var_1.usexp );

            if ( isdefined( self.usesremaining ) )
            {
                self.usesremaining--;

                if ( self.usesremaining == 0 )
                {
                    box_leave();
                    break;
                }
            }

            if ( isdefined( var_1.canuseotherboxes ) && var_1.canuseotherboxes )
            {
                foreach ( var_4 in level.deployable_box[var_1.streakname] )
                {
                    var_4 box_disableplayeruse( var_0 );

                    if ( isdefined( var_4.boxiconid ) )
                        scripts\cp_mp\entityheadicons::_id_12385( var_4.boxiconid, var_0 );

                    var_4 thread doubledip( var_0 );
                }

                continue;
            }

            if ( istrue( var_1.canreusebox ) )
                continue;

            if ( isdefined( self.boxiconid ) )
                scripts\cp_mp\entityheadicons::_id_12385( self.boxiconid, var_0 );

            box_disableplayeruse( var_0 );
            thread doubledip( var_0 );
        }
    }
}

doubledip( var_0 )
{
    self endon( "death" );
    var_0 endon( "disconnect" );
    var_0 waittill( "death" );

    if ( level.teambased )
    {
        if ( self.team == var_0.team )
        {
            if ( isdefined( self.boxiconid ) )
                scripts\cp_mp\entityheadicons::_id_12384( self.boxiconid, var_0 );

            box_enableplayeruse( var_0 );
        }
    }
    else if ( isdefined( self.owner ) && self.owner == var_0 )
    {
        if ( isdefined( self.boxiconid ) )
            scripts\cp_mp\entityheadicons::_id_12384( self.boxiconid, var_0 );

        box_enableplayeruse( var_0 );
    }
}

boxcapturethink( var_0 )
{
    level endon( "game_ended" );

    while ( isdefined( self ) )
    {
        self waittill( "trigger", var_1 );

        if ( isdefined( level.boxsettings[self.boxtype].nousekillstreak ) && level.boxsettings[self.boxtype].nousekillstreak && scripts\mp\utility\weapon::iskillstreakweapon( var_0 getcurrentweapon() ) )
            continue;

        if ( var_1 == var_0 && useholdthink( var_0, level.boxsettings[self.boxtype].usetime ) )
            self notify( "captured", var_0 );
    }
}

isfriendlytobox( var_0 )
{
    return level.teambased && self.team == var_0.team;
}

box_timeout()
{
    self endon( "death" );
    level endon( "game_ended" );
    var_0 = level.boxsettings[self.boxtype];
    var_1 = var_0.lifespan;
    scripts\mp\hostmigration::waitlongdurationwithhostmigrationpause( var_1 );

    if ( isdefined( var_0.vogone ) )
        self.owner thread scripts\mp\utility\dialog::leaderdialogonplayer( var_0.vogone );

    box_leave();
}

box_leave()
{
    waitframe();
    self.isdestroyed = 1;
    self notify( "death" );
}

deleteonownerdeath( var_0 )
{
    wait 0.25;
    self linkto( var_0, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
    var_0 waittill( "death" );
    box_leave();
}

box_modelteamupdater( var_0 )
{
    self endon( "death" );
    self hide();

    foreach ( var_2 in level.players )
    {
        if ( var_2.team == var_0 )
            self showtoplayer( var_2 );
    }

    for (;;)
    {
        level waittill( "joined_team" );
        self hide();

        foreach ( var_2 in level.players )
        {
            if ( var_2.team == var_0 )
                self showtoplayer( var_2 );
        }
    }
}

useholdthink( var_0, var_1 )
{
    scripts\mp\movers::script_mover_link_to_use_object( var_0 );
    var_0 scripts\common\utility::allow_weapon( 0 );
    var_0.boxparams = spawnstruct();
    var_0.boxparams.curprogress = 0;
    var_0.boxparams.inuse = 1;
    var_0.boxparams.userate = 0;
    var_0.boxparams.id = self.id;

    if ( isdefined( var_1 ) )
        var_0.boxparams.usetime = var_1;
    else
        var_0.boxparams.usetime = 3000;

    var_2 = useholdthinkloop( var_0 );

    if ( isalive( var_0 ) )
    {
        var_0 scripts\common\utility::allow_weapon( 1 );
        scripts\mp\movers::script_mover_unlink_from_use_object( var_0 );
    }

    if ( !isdefined( self ) )
        return 0;

    var_0.boxparams.inuse = 0;
    var_0.boxparams.curprogress = 0;
    return var_2;
}

useholdthinkloop( var_0 )
{
    var_1 = var_0.boxparams;

    while ( var_0 isplayerusingbox( var_1 ) )
    {
        if ( !var_0 scripts\mp\movers::script_mover_use_can_link( self ) )
        {
            var_0 scripts\mp\gameobjects::updateuiprogress( var_1, 0 );
            return 0;
        }

        var_1.curprogress = var_1.curprogress + level.frameduration * var_1.userate;

        if ( isdefined( var_0.objectivescaler ) )
            var_1.userate = 1 * var_0.objectivescaler;
        else
            var_1.userate = 1;

        var_0 scripts\mp\gameobjects::updateuiprogress( var_1, 1 );

        if ( var_1.curprogress >= var_1.usetime )
        {
            var_0 scripts\mp\gameobjects::updateuiprogress( var_1, 0 );
            return scripts\mp\utility\player::isreallyalive( var_0 );
        }

        waitframe();
    }

    var_0 scripts\mp\gameobjects::updateuiprogress( var_1, 0 );
    return 0;
}

addboxtolevelarray()
{
    level.deployable_box[self.boxtype][self getentitynumber()] = self;
}

removeboxfromlevelarray()
{
    level.deployable_box[self.boxtype][self getentitynumber()] = undefined;
}

isplayerusingbox( var_0 )
{
    return !level.gameended && isdefined( var_0 ) && scripts\mp\utility\player::isreallyalive( self ) && self usebuttonpressed() && !self isonladder() && !self meleebuttonpressed() && var_0.curprogress < var_0.usetime && ( !isdefined( self.teleporting ) || !self.teleporting );
}

isgrenadedeployable( var_0 )
{
    var_1 = 0;

    switch ( var_0 )
    {
        default:
            var_1 = 0;
            break;
    }

    return var_1;
}
