// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

thermite_used( var_0, var_1 )
{
    if ( isdefined( var_1 ) )
    {
        var_2 = var_0;
        var_0 = scripts\mp\utility\weapon::_launchgrenade( "thermite_mp", var_2.origin, ( 0, 0, 0 ) );
        scripts\mp\weapons::grenadeinitialize( var_0, getcompleteweaponname( "thermite_mp" ) );
        var_0.patch_self_check = var_2;
        var_0.angles = var_2.angles;
        var_0.patch_weapons_on_rack_cleararea = self getcurrentweapon();
        var_0 linkto( var_2 );
        var_0.exploding = 1;
        var_0 setscriptablepartstate( "visibility", "hide", 0 );
    }

    if ( isdefined( level.lootchopper_getspawnlocations ) )
        [[ level.lootchopper_getspawnlocations ]]( var_0, self );

    var_0 thread thermite_watchdisowned();
    var_0 thread _id_12C3C();
    var_0 thread thermite_watchstuck( var_1 );
}

thermite_watchstuck( var_0 )
{
    self endon( "death" );
    var_1 = undefined;

    if ( istrue( var_0 ) )
    {
        var_2 = _id_12C3B();

        if ( !istrue( var_2 ) )
        {
            thread thermite_delete();
            return;
        }

        if ( isdefined( self.patch_self_check ) )
            self.patch_self_check delete();
    }
    else
        self waittill( "missile_stuck", var_1 );

    if ( isdefined( level._id_1249F ) && [[ level._id_1249F.hudextractnum ]]( self ) )
    {
        thread scripts\mp\weapons::_id_125E9( self.origin );
        thread scripts\mp\weapons::smokegrenadeexplode( self.origin );
        thread scripts\mp\weapons::sfx_smoke_grenade_smoke( self.origin );
        self delete();
        return;
    }

    self.owner endon( "disconnect" );
    self.owner endon( "joined_team" );
    self.owner endon( "joined_spectators" );

    if ( !istrue( var_0 ) )
    {
        if ( isdefined( var_1 ) && isplayer( var_1 ) )
            thread scripts\mp\weapons::grenadestuckto( self, var_1 );
    }

    var_3 = self.weapon_object;

    if ( isdefined( self.patch_weapons_on_rack_cleararea ) )
        var_3.vandalize_attack_max_cooldown = self.patch_weapons_on_rack_cleararea;

    thread _id_12C3D();
    self setscriptablepartstate( "effects", "impact", 0 );
    _id_12C38( var_3 );

    if ( !istrue( level.getfullweaponobjforscriptablepartname ) )
        self.dangerzoneid = scripts\mp\spawnlogic::addspawndangerzone( self.origin, 175, 175, self.owner.team, 100, self.owner, 1, self, 1 );

    wait 0.5;
    var_4 = getcompleteweaponname( "thermite_av_mp" );
    var_5 = getcompleteweaponname( "thermite_ap_mp" );

    if ( isdefined( self.patch_weapons_on_rack_cleararea ) )
    {
        var_4.vandalize_attack_max_cooldown = self.patch_weapons_on_rack_cleararea;
        var_5.vandalize_attack_max_cooldown = self.patch_weapons_on_rack_cleararea;
    }

    var_6 = 1;

    while ( var_6 <= 10 )
    {
        var_7 = var_6 + 1;

        if ( scripts\engine\utility::mod( var_7, 2 ) > 0 )
            _id_12C38( var_4 );
        else
            _id_12C38( var_5 );

        var_6 = var_7;
        wait 0.5;
    }

    thread thermite_destroy();
}

_id_12C3B()
{
    self.patch_self_check endon( "death" );
    self.owner endon( "disconnect" );
    self.owner endon( "joined_team" );
    self.owner endon( "joined_spectators" );
    self.patch_self_check waittill( "missile_stuck", var_0, var_1, var_2, var_3, var_4, var_5 );

    if ( isdefined( var_0 ) )
    {
        if ( isplayer( var_0 ) || isagent( var_0 ) )
        {
            if ( var_0 scripts\cp_mp\utility\player_utility::_isalive() )
            {
                if ( isplayer( var_0 ) )
                    thread scripts\mp\weapons::grenadestuckto( self, var_0 );

                if ( isdefined( var_1 ) )
                    self linkto( var_0, var_1 );
                else
                    self linkto( var_0, "j_spine4", ( 0, 0, 0 ) );
            }
        }
        else if ( isdefined( var_1 ) )
            self linkto( var_0, var_1 );
        else
            self linkto( var_0 );
    }

    return 1;
}

_id_12C3D()
{
    self endon( "death" );
    var_0 = self getlinkedparent();

    while ( isdefined( var_0 ) )
        self waittill( "missile_stuck", var_0 );

    self.badplace = createnavbadplacebybounds( self.origin, ( 125, 125, 125 ), ( 0, 0, 0 ) );
}

_id_12C38( var_0 )
{
    var_1 = 125;
    var_2 = 25;
    var_3 = 10;
    var_4 = "MOD_FIRE";

    if ( var_0.basename == "thermite_mp" )
    {
        var_1 = 125;
        var_2 = 30;
        var_3 = 30;
    }

    var_5 = self.stuckenemyentity;

    if ( isdefined( var_5 ) )
    {
        if ( isplayer( var_5 ) && var_5 scripts\cp_mp\utility\player_utility::_isalive() )
        {
            if ( isdefined( level._id_1249F ) && [[ level._id_1249F.enabledminimapdisable ]]( var_5 ) )
            {
                thread thermite_destroy();
                return;
            }

            var_5 dodamage( var_2, self.origin, self.owner, self, var_4, var_0 );
            var_5 scripts\cp_mp\utility\damage_utility::adddamagemodifier( "thermiteStuck", 0, 0, ::_id_12C37 );
        }
        else
            var_5 = undefined;
    }

    self radiusdamage( self.origin, var_1, var_2, var_3, self.owner, var_4, var_0 );

    if ( isdefined( var_5 ) )
        var_5 scripts\cp_mp\utility\damage_utility::removedamagemodifier( "thermiteStuck", 0 );
}

_id_12C37( var_0, var_1, var_2, var_3, var_4, var_5, var_6 )
{
    if ( !isdefined( var_0 ) )
        return 1;

    if ( !isdefined( var_0.weapon_name ) || var_0.weapon_name != "thermite_mp" )
        return 1;

    if ( !isdefined( var_0.stuckenemyentity ) || var_0.stuckenemyentity != var_2 )
        return 1;

    return 0;
}

thermite_watchdisowned()
{
    self endon( "death" );
    self.owner scripts\engine\utility::_id_133F0( "joined_team", "joined_spectators", "disconnect" );
    thread thermite_destroy();
}

_id_12C3C()
{
    self endon( "death" );
    level waittill( "br_prematchEnded" );
    thread thermite_destroy();
}

thermite_destroy()
{
    thread thermite_delete( 5 );
    self setscriptablepartstate( "effects", "burnEnd", 0 );
}

thermite_delete( var_0 )
{
    self notify( "death" );
    self.exploding = 1;

    if ( isdefined( self.dangerzoneid ) )
    {
        scripts\mp\spawnlogic::removespawndangerzone( self.dangerzoneid );
        self.dangerzoneid = undefined;
    }

    if ( isdefined( self.badplace ) )
    {
        destroynavobstacle( self.badplace );
        self.badplace = undefined;
    }

    self forcehidegrenadehudwarning( 1 );

    if ( isdefined( var_0 ) )
        wait( var_0 );

    if ( isdefined( self ) )
        self delete();
}

thermite_onplayerdamaged( var_0 )
{
    if ( var_0.meansofdeath == "MOD_IMPACT" )
        return 1;

    var_0.victim.lastburntime = gettime();
    var_0.victim thread scripts\mp\weapons::enableburnfxfortime( 0.6 );
    return 1;
}
