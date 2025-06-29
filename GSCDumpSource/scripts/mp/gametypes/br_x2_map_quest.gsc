// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    var_0 = scripts\mp\gametypes\br_quest_util.gsc::registerquestcategory( "x2_map", 0 );

    if ( !var_0 )
        return;

    scripts\mp\gametypes\br_quest_util.gsc::registerremovequestinstance( "x2_map", ::_id_13669 );
    scripts\mp\gametypes\br_quest_util.gsc::_id_11DF6( "x2_map", ::_id_13668 );
    scripts\mp\gametypes\br_quest_util.gsc::_id_11DF8( "x2_map", ::_id_1366A );
    scripts\mp\gametypes\br_quest_util.gsc::registerquestthink( "x2_map", ::_id_1366B, 0.05 );
    get_evade_start_structs_in_front();
}

get_evade_start_structs_in_front()
{
    var_0 = [];

    if ( level.mapname == "mp_br_mechanics" )
        var_0[0] = ( -483, -2260, 30 );
    else
    {
        var_0[0] = ( 4695, 306, -215 );
        var_0[1] = ( -31298, 3614, -284 );
    }

    foreach ( var_4, var_2 in var_0 )
    {
        var_0[var_4] = getdvarvector( "scr_br_x2_amb" + var_4 + "_destination", var_0[var_4] );
        var_3 = spawnstruct();
        var_3.origin = scripts\mp\gametypes\br_public.gsc::init_rpg_spawns( var_0[var_4], 0, -200 ) + ( 0, 0, 20 );
        var_3.gameobject = spawn( "script_model", var_3.origin );
        var_3.gameobject hide();
        scripts\mp\gametypes\br_quest_util.gsc::getquestdata( "x2_map" ).destination[var_4] = var_3;
    }
}

parachuteoverheadwarningheight( var_0, var_1, var_2, var_3, var_4 )
{
    var_5 = scripts\mp\gametypes\br_gametype_x2.gsc::debug_printcode( "x2_map", var_0, var_1, var_4 );
    var_5.get_station_controller_struct = level._id_1363E;
    var_5._id_11C65 = scripts\mp\gametypes\br_quest_util.gsc::getquestdata( "x2_map" ).destination[var_5.get_station_controller_struct].origin;
    scripts\mp\gametypes\br_quest_util.gsc::uiobjectiveshowtoteam( "x2_map", self.team );
    scripts\mp\gametypes\br_quest_util.gsc::addquestinstance( "x2_map", var_5 );
    scripts\mp\gametypes\br_quest_util.gsc::_id_129E2( "x2_map", self, self.team );
    var_6 = spawnstruct();
    var_6._id_11AEF = scripts\mp\gametypes\br_quest_util.gsc::objective_hide_for_mlg_spectator( "x2_map", scripts\mp\gametypes\br_quest_util.gsc::objectiveids( self.team ) );
    scripts\mp\gametypes\br_quest_util.gsc::displayteamsplash( self.team, "br_x2_attack_quest_start_team_notify", var_6 );
    var_7 = scripts\mp\gametypes\br_quest_util.gsc::getquestdata( "x2_map" ).destination.size;

    if ( !scripts\mp\flags::gameflag( "x2_ambush" + var_7 + "_starting" ) && istrue( level._id_12577 ) )
        var_5 thread _id_1366C();

    return var_5;
}

_id_13665()
{
    var_0 = spawnstruct();
    var_1 = scripts\mp\gametypes\br_quest_util.gsc::objectiveids( self.team );
    var_2 = scripts\mp\gametypes\br_quest_util.gsc::getquestindex( "x2_map" );
    var_3 = scripts\mp\gametypes\br_quest_util.gsc::objective_origin( scripts\mp\gametypes\br_quest_util.gsc::objective_minimapupdate( "x2_map" ) );
    var_0.usingobject = scripts\mp\gametypes\br_quest_util.gsc::v_start_pos( var_2, var_1, var_3 );
    self._id_11FD6 = self.playerlist[0].origin;
    self._id_11FD3 = self.playerlist[0].angles;
    self.result = "success";
    self.trap_toggle_logic = 1;
    scripts\mp\gametypes\br_quest_util.gsc::removequestinstance();
}

_id_13669()
{
    foreach ( var_1 in self.playerlist )
    {
        if ( isdefined( var_1 ) )
            var_1 scripts\mp\gametypes\br_quest_util.gsc::uiobjectivehide();
    }
}

_id_13668( var_0 )
{
    if ( var_0.team == self.team )
    {
        if ( !scripts\mp\gametypes\br_quest_util.gsc::isteamvalid( var_0.team ) )
        {
            self.result = "fail";
            scripts\mp\gametypes\br_quest_util.gsc::removequestinstance();
        }
    }
}

_id_1366A( var_0 )
{
    if ( !enablesplitscreen( var_0 ) )
        return;

    var_0 scripts\mp\gametypes\br_quest_util.gsc::uiobjectiveshow( "x2_map" );
    scripts\mp\gametypes\br_quest_util.gsc::_id_12552( var_0 );
}

bot_koth_think()
{
    return scripts\mp\gametypes\br_gametype_x2.gsc::currlocation( "x2_map", ::parachuteoverheadwarningheight );
}

_id_1366C()
{
    level endon( "game_ended" );
    var_0 = level._id_135FD._id_12D76[0];
    var_1 = scripts\mp\gametypes\br_quest_util.gsc::getquestdata( "x2_map" ).destination.size;
    var_2 = 20000;

    if ( self.get_station_controller_struct == var_1 - 1 )
        var_2 = 20000;

    _id_13444( var_0, self._id_11C65, var_2 );
    _id_13665();
}

_id_13444( var_0, var_1, var_2 )
{
    var_3 = var_2 * var_2;

    while ( length2dsquared( var_0.origin - var_1 ) > var_3 )
        waitframe();
}

_id_1366B()
{
    if ( scripts\mp\flags::gameflag( "x2_train_destroyed" ) )
        _id_13665();
}

enablesplitscreen( var_0 )
{
    return scripts\mp\gametypes\br_gametype_x2.gsc::debug_pre_start_coop_escape( var_0 );
}
