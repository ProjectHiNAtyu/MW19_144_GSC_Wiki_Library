// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    if ( !isdefined( level.helis_assault3_check_size ) )
        level.helis_assault3_check_size = getdvarint( "scr_game_disablespawncamera", 0 ) == 1;

    level.snaptospawncamera = getdvarint( "scr_game_spawncamera_snap", 1 ) == 1;
    level.evaluatefrontline = getdvarint( "scr_game_spawncamera_frontline", 0 ) == 1;
    level.evaluatespawnforcameraselection = getdvarint( "scr_game_spawncamera_spawnpoint", 1 ) == 1;
    level.updatedefaultcamera = ::blank_func;
    level.updategamemodecamera = ::blank_func;

    if ( !istrue( level.helis_assault3_check_size ) )
        initcameras();
}

blank_func()
{

}

initcameras()
{
    level.spawncameras = [];
    level.currentcamera = [];

    foreach ( var_1 in level.teamnamelist )
        level.currentcamera[var_1] = "default";

    var_3 = scripts\engine\utility::getstructarray( "spawn_selection_camera", "targetname" );

    if ( var_3.size == 0 || level.mapname == "mp_aniyah_tac" )
    {
        createdefaultcameras();
        return;
    }

    foreach ( var_5 in var_3 )
    {
        var_6 = var_5.script_label;

        if ( !isdefined( var_6 ) || var_6 == "spawn_selection_camera" )
            var_6 = var_5.script_noteworthy;

        if ( isdefined( scripts\cp_mp\utility\game_utility::getlocaleid() ) )
        {
            var_7 = var_5.script_noteworthy;

            if ( !isdefined( var_7 ) || isdefined( var_7 ) && var_7 != level.localeid )
                continue;
        }

        if ( !isdefined( level.spawncameras[var_6] ) )
            level.spawncameras[var_6] = [];

        var_8 = var_5.script_team;

        if ( var_8 == "all" )
        {
            foreach ( var_1 in level.teamnamelist )
                level.spawncameras[var_6][var_1] = var_5;

            continue;
        }

        if ( istrue( level.usestaticspawnselectioncamera ) )
        {
            var_11 = scripts\mp\spawnselection::getstaticcameraposition( var_8 );
            var_5.origin = var_11.origin;
            var_5.angles = var_11.angles;
        }

        level.spawncameras[var_6][var_8] = var_5;
    }

    createdefaultcameras();
}

createdefaultcameras()
{
    if ( isdefined( level.spawncameras["default"] ) )
    {
        var_0 = 1;

        foreach ( var_2 in level.teamnamelist )
        {
            if ( !isdefined( level.spawncameras["default"][var_2] ) )
            {
                var_0 = 0;
                break;
            }
        }

        if ( var_0 )
            return;
    }
    else
        level.spawncameras["default"] = [];

    var_4 = ( 0, 0, 0 );

    if ( isdefined( level.mapcorners ) && isdefined( level.mapcorners[0] ) && isdefined( level.mapcorners[1] ) )
    {
        level.mapcornervector = level.mapcorners[1].origin - level.mapcorners[0].origin;
        level.mapcornercenter = level.mapcorners[0].origin + level.mapcornervector * 0.5;
    }

    foreach ( var_2 in level.teamnamelist )
    {
        if ( isdefined( level.spawncameras["default"][var_2] ) )
        {
            level.spawncameras["default"][var_2].radiantplaced = 1;
            continue;
        }

        var_6 = spawnstruct();
        var_6.origin = ( 0, 0, 0 );
        var_6.angles = ( 0, 0, 0 );
        level.spawncameras["default"][var_2] = var_6;
    }

    level.spawncamerastartspawnallies = getstartspawnavg( "allies" );
    level.spawncamerastartspawnaxis = getstartspawnavg( "axis" );
    level.spawncamerastartspawnaxisang = scripts\engine\utility::ter_op( distancesquared( level.spawncamerastartspawnaxis, level.mapcorners[0].origin ) < distancesquared( level.spawncamerastartspawnaxis, level.mapcorners[1].origin ), level.mapcorners[0].angles, level.mapcorners[1].angles );
    var_8 = level.spawncamerastartspawnaxis - level.spawncamerastartspawnallies;
    var_9 = level.spawncamerastartspawnallies + var_8 * 0.5;

    if ( distancesquared( level.spawncamerastartspawnallies, level.mapcorners[0].origin ) < distancesquared( level.spawncamerastartspawnallies, level.mapcorners[1].origin ) )
    {
        var_10 = anglestoforward( level.mapcorners[0].angles );
        var_11 = anglestoright( level.mapcorners[0].angles );

        if ( abs( vectordot( var_8, var_10 ) ) > abs( vectordot( var_8, var_11 ) ) )
            level.spawncamerastartspawnalliesvec = var_10;
        else
            level.spawncamerastartspawnalliesvec = var_11;
    }
    else
    {
        var_10 = anglestoforward( level.mapcorners[1].angles );
        var_11 = anglestoright( level.mapcorners[1].angles );

        if ( abs( vectordot( var_8, var_10 ) ) > abs( vectordot( var_8, var_11 ) ) )
            level.spawncamerastartspawnalliesvec = var_10;
        else
            level.spawncamerastartspawnalliesvec = var_11;
    }

    if ( distancesquared( level.spawncamerastartspawnaxis, level.mapcorners[0].origin ) < distancesquared( level.spawncamerastartspawnaxis, level.mapcorners[1].origin ) )
    {
        var_10 = anglestoforward( level.mapcorners[0].angles );
        var_11 = anglestoright( level.mapcorners[0].angles );

        if ( abs( vectordot( var_8, var_10 ) ) > abs( vectordot( var_8, var_11 ) ) )
            level.spawncamerastartspawnaxisvec = var_10;
        else
            level.spawncamerastartspawnaxisvec = var_11;
    }
    else
    {
        var_10 = anglestoforward( level.mapcorners[1].angles );
        var_11 = anglestoright( level.mapcorners[1].angles );

        if ( abs( vectordot( var_8, var_10 ) ) > abs( vectordot( var_8, var_11 ) ) )
            level.spawncamerastartspawnaxisvec = var_10;
        else
            level.spawncamerastartspawnaxisvec = var_11;
    }

    var_12 = distance( level.spawncamerastartspawnallies, level.spawncamerastartspawnaxis );
    level.spawncameradistfactor = var_12;
    orientdefaulttomapcenterusingmapcorners();
}

get_next_spawn_index()
{
    if ( isdefined( level.updatedefaultcamera ) )
        [[ level.updatedefaultcamera ]]();

    if ( isdefined( level.updategamemodecamera ) )
        self [[ level.updategamemodecamera ]]();

    var_0 = self.origin + ( 0, 0, 60 );
    var_1 = self.angles;

    if ( isdefined( self.squadspectatepos ) )
    {
        self.deathspectatepos = self.squadspectatepos;
        self.deathspectateangles = self.squadspectateang;
    }
    else
    {
        self.deathspectatepos = var_0;
        self.deathspectateangles = var_1;
    }

    if ( !isdefined( self.spawncameraent ) )
    {
        var_2 = spawn( "script_model", self.deathspectatepos );
        var_2 scripts\cp_mp\ent_manager::registerspawncount( 1 );
        var_2 setmodel( "tag_origin" );
        var_2.angles = self.deathspectateangles;
        self.spawncameraent = var_2;
    }
    else
    {
        self.spawncameraent.origin = self.deathspectatepos;
        self.spawncameraent.angles = self.deathspectateangles;
    }
}

startspawncamera( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    scripts\mp\utility\player::_id_11B9C( "spawnCamera::startSpawnCamera() START" );
    scripts\mp\utility\player::hideminimap( 1 );
    get_next_spawn_index();

    if ( !isdefined( self.spawncameraent ) )
    {
        scripts\mp\utility\player::_id_11B9C( "spawnCamera::startSpawnCamera() UNDEFINED SPAWNCAMERAENT!!!" );
        thread playslamzoomflash( 0.0, getspawncamerawaittime(), 0.5 );
        return;
    }

    if ( istrue( level.helis_assault3_check_size ) && scripts\mp\utility\game::getgametype() != "arm" )
        return;

    if ( isai( self ) )
        return;

    if ( istrue( self.inspawncamera ) )
        return;

    if ( istrue( level.gameended ) )
        return;

    if ( isdefined( self.setspawnpoint ) )
        return;

    self.inspawncamera = 1;
    scripts\mp\utility\player::setdof_default();
    waitframe();
    scripts\mp\spectating::setdisabled();
    scripts\mp\utility\player::updatesessionstate( "spectator" );
    self setclientomnvar( "ui_in_spawn_camera", 1 );

    if ( !isdefined( var_0 ) )
        var_0 = 0.0;

    if ( !isdefined( var_1 ) )
        var_1 = 0.25;

    if ( !isdefined( var_2 ) )
        var_2 = 0.25;

    thread playslamzoomflash( var_0, var_1, var_2 );
    scripts\engine\utility::_id_13409( 0.1, "force_spawn" );
    thread removecameraondisconnect( self.spawncameraent );
    self cameralinkto( self.spawncameraent, "tag_origin", 1, 1 );
    scripts\mp\utility\player::_id_11B9C( "spawnCamera::startSpawnCamera() CameraLinkTo()" );
    self clearadditionalstreampos();
    thread snaptospawncamera();
}

getspawncamerawaittime()
{
    if ( isdefined( self.spawncameratime ) )
        return self.spawncameratime;
    else if ( istrue( self.squadspawnaborted ) || !istrue( level.snaptospawncamera ) && ( istrue( self.skippedkillcam ) || !isdefined( self.killcamwatchtime ) || self.killcamwatchtime < 2.0 ) )
        return 2.5;
    else
        return 1.5;
}

oncontractend()
{
    return 1.0;
}

getspawncamera()
{
    var_0 = undefined;

    if ( scripts\mp\utility\game::rotateviptoplayer() )
        self.forcedspawncameraref = "default";

    if ( isdefined( self.forcedspawncameraref ) )
    {
        if ( isdefined( level.spawncameras[self.forcedspawncameraref] ) )
            var_0 = level.spawncameras[self.forcedspawncameraref][self.team];
        else if ( issubstr( self.forcedspawncameraref, "squad" ) )
        {
            var_1 = self.forcedspawncameraref;

            if ( var_1 == "squad_leader" )
                var_2 = level.squaddata[self.team][self.squadindex].squadleaderindex;
            else
                var_2 = int( getsubstr( var_1, var_1.size - 1, var_1.size ) );

            var_3 = undefined;

            if ( isdefined( level.squaddata[self.team] ) && isdefined( level.squaddata[self.team][self.squadindex] ) && isdefined( level.squaddata[self.team][self.squadindex].players[var_2] ) )
                var_3 = level.squaddata[self.team][self.squadindex].players[var_2];

            if ( isdefined( var_3 ) )
            {
                var_4 = level.spawnselectionteamforward[self.team];
                var_5 = var_3.origin + var_4 * -8500 + ( 0, 0, 7000 );
                var_6 = vectornormalize( var_3.origin - var_5 );
                var_7 = scripts\mp\utility\script::vectortoanglessafe( var_6, ( 0, 0, 1 ) );

                if ( istrue( level.useunifiedspawnselectioncameraheight ) )
                {
                    var_8 = scripts\mp\spawnselection::getunifedspawnselectioncameraheight();
                    var_5 = ( var_5[0], var_5[1], var_8 );
                }

                var_5 = var_5 + scripts\mp\gametypes\arm.gsc::calculatecameraoffset( self.team, var_3.origin );
                var_0 = spawnstruct();
                var_0.origin = var_5;
                var_0.angles = var_7;
            }
        }
        else if ( issubstr( self.forcedspawncameraref, "vehicle" ) )
        {
            var_1 = self.forcedspawncameraref;
            var_9 = undefined;

            if ( isdefined( level.spawnselectionlocations[var_1] ) && isdefined( level.spawnselectionlocations[var_1][self.team] ) )
                var_9 = level.spawnselectionlocations[var_1][self.team].dynamicent;

            var_4 = level.spawnselectionteamforward[self.team];

            if ( isdefined( var_9 ) && !istrue( var_9.isdestroyed ) )
            {
                var_5 = [];
                var_7 = [];

                if ( istrue( level.usestaticspawnselectioncamera ) )
                {
                    var_10 = scripts\mp\spawnselection::getstaticcameraposition( self.team );
                    var_5 = var_10.origin;
                    var_7 = var_10.angles;
                }
                else
                {
                    var_5 = var_9.origin + var_4 * -8500 + ( 0, 0, 7000 );

                    if ( istrue( level.useunifiedspawnselectioncameraheight ) )
                    {
                        var_8 = scripts\mp\spawnselection::getunifedspawnselectioncameraheight();
                        var_5 = ( var_5[0], var_5[1], var_8 );
                    }

                    var_11 = level.spawnselectionlocations[var_1][self.team].anchorentity.origin;
                    var_12 = var_11 + var_4 * -8500 + ( 0, 0, 7000 );
                    var_13 = vectornormalize( var_11 - var_12 );
                    var_7 = scripts\mp\utility\script::vectortoanglessafe( var_13, ( 0, 0, 1 ) );
                    var_5 = var_5 + scripts\mp\gametypes\arm.gsc::calculatecameraoffset( self.team, var_11 );
                }

                var_0 = spawnstruct();
                var_0.origin = var_5;
                var_0.angles = var_7;
            }
        }
    }
    else if ( istrue( level.evaluatespawnforcameraselection ) && isdefined( level.setplayerselfrevivingextrainfo ) && isdefined( level.setplayerselfrevivingextrainfo[self.team] ) )
    {
        var_14 = level.setplayerselfrevivingextrainfo[self.team];
        var_15 = undefined;
        var_16 = undefined;

        foreach ( var_20, var_18 in level.spawncameras[level.currentcamera[self.team]] )
        {
            var_19 = distancesquared( var_18.origin, var_14 );

            if ( !isdefined( var_16 ) || var_19 < var_15 )
            {
                var_16 = var_18;
                var_15 = var_19;
            }
        }

        var_0 = var_16;
    }
    else if ( istrue( level.evaluatefrontline ) )
    {
        var_21 = calulatefrontline();
        var_15 = undefined;
        var_16 = undefined;

        foreach ( var_20, var_18 in level.spawncameras[level.currentcamera[self.team]] )
        {
            var_23 = distancesquared( var_18.origin, var_21.teamavg[self.team] );
            var_24 = distancesquared( var_18.origin, var_21.origin );

            if ( !isdefined( var_16 ) || var_23 < var_24 )
            {
                var_16 = var_18;
                var_15 = var_23;
            }
        }

        var_0 = var_16;
    }
    else
    {
        if ( istrue( level.usec130spawn ) )
        {
            while ( !isdefined( level.currentcamera[self.team] ) )
                waitframe();
        }

        if ( !isstring( level.currentcamera[self.team] ) )
        {
            var_0 = spawnstruct();
            var_0.origin = level.currentcamera[self.team].origin;
            var_0.angles = level.currentcamera[self.team].angles;
            var_0.usingintermissionpos = 1;
        }
        else
            var_0 = level.spawncameras[level.currentcamera[self.team]][self.team];
    }

    if ( !isdefined( var_0 ) )
    {
        if ( isdefined( level.availablespawnlocations ) && isdefined( level.availablespawnlocations[self.team] ) )
        {
            level.currentcamera[self.team] = level.availablespawnlocations[self.team][0];
            var_0 = level.spawncameras[level.currentcamera[self.team]][self.team];
        }
        else
        {
            level.currentcamera[self.team] = "default";
            var_0 = level.spawncameras[level.currentcamera[self.team]][self.team];
        }
    }

    return var_0;
}

movetospawncamerainitial()
{
    self endon( "disconnect" );
    self notify( "newMoveToSpawnCameraInitiated" );
    self endon( "newMoveToSpawnCameraInitiated" );
    self endon( "tac_ops_spawn_focus_changed" );
    self endon( "slamZoomInitiated" );
    var_0 = getspawncamera();
    var_1 = var_0.origin;
    var_2 = var_0.angles;
    var_3 = self.spawncameraent.origin;
    var_4 = vectornormalize( var_3 - var_0.origin );
    var_5 = scripts\mp\utility\script::vectortoanglessafe( var_4, ( 0, 0, 1 ) );
    self.spawncameraent.angles = var_5;
    var_6 = distance( var_3, var_1 );
    var_7 = var_6 / 3520;
    var_7 = clamp( var_7, 1.5, 3.0 );
    self.spawncameratargetpos = var_1;
    self.spawncameratargetang = var_2;
    self.spawncameratime = var_7;
    self.spawncameraendtime = gettime() + var_7 * 1000;

    if ( !istrue( var_0.usingintermissionpos ) )
    {
        self.spawncameraent moveto( var_1, var_7, var_7 * 0.3, var_7 * 0.4 );
        self.spawncameraent rotateto( var_2, var_7, var_7 * 0.3, var_7 * 0.4 );
        wait 1.0;
    }
    else
    {
        self.spawncameraent.origin = var_1;
        self.spawncameraent.angles = var_2;
        self.deathspectatepos = var_1;
    }

    applythermal();
    thread startoperatorsound();

    if ( isdefined( self ) && isdefined( self.spawncameraent ) && !istrue( self.inspawnselection ) )
    {
        var_8 = anglestoforward( var_2 ) * 300;
        var_8 = var_8 * ( 1, 1, 0 );
        self earthquakeforplayer( 0.03, 15.0, var_1, 1000 );
    }

    self notify( "spawn_camera_idle" );
}

movetospawncamera( var_0 )
{
    self endon( "disconnect" );
    self notify( "newMoveToSpawnCameraInitiated" );
    self endon( "newMoveToSpawnCameraInitiated" );
    self endon( "tac_ops_map_selection_valid" );
    self endon( "tac_ops_spawn_focus_changed" );
    self endon( "slamZoomInitiated" );
    var_1 = getspawncamera();
    var_2 = var_1.origin;
    var_3 = var_1.angles;

    if ( isdefined( self.spawncameratargetpos ) && isdefined( self.spawncameratargetang ) && self.spawncameratargetpos == var_2 && self.spawncameratargetang == var_3 )
        return;

    var_4 = self.spawncameraent.origin;
    var_5 = vectornormalize( var_4 - var_1.origin );
    self.spawncameratargetpos = var_2;
    self.spawncameratargetang = var_3;
    self.spawncameraent moveto( var_2, 1.0, 0.25, 0.75 );
    self.spawncameraent rotateto( var_3, 1.0, 0.25, 0.75 );
    wait 1.0;

    if ( isdefined( self ) && isdefined( self.spawncameraent ) && !istrue( self.inspawnselection ) )
    {
        var_6 = anglestoforward( var_3 ) * 300;
        var_6 = var_6 * ( 1, 1, 0 );
        self.spawncameraent moveto( var_2 + var_6, 15.0, 1.0, 1.0 );
        self earthquakeforplayer( 0.03, 15.0, var_2, 1000 );
    }

    self notify( "spawn_camera_idle" );
}

snaptospawncamera()
{
    self endon( "disconnect" );

    while ( !istrue( self.distort_fx ) )
        waitframe();

    var_0 = getspawncamera();
    self.spawncameraent dontinterpolate();
    self.spawncameraent.origin = var_0.origin;
    self.spawncameraent.angles = var_0.angles;
    scripts\mp\utility\player::_id_11B9C( "spawnCamera::snapToSpawnCamera()" );

    if ( !istrue( level.nukedetonated ) )
        self visionsetnakedforplayer( "", 0 );

    applythermal();
    thread startoperatorsound();

    if ( isdefined( self ) && isdefined( self.spawncameraent ) && !istrue( self.inspawnselection ) )
    {
        var_1 = anglestoforward( self.spawncameraent.angles ) * 300;
        var_1 = var_1 * ( 1, 1, 0 );
        self.spawncameraent moveto( self.spawncameraent.origin + var_1, 15.0, 1.0, 1.0 );
        self earthquakeforplayer( 0.03, 15.0, self.spawncameraent.origin, 1000 );
    }

    self notify( "spawn_camera_idle" );
}

endspawncamera()
{
    if ( isdefined( self.updateexpiredlootleader ) )
    {
        self clearsoundsubmix( "iw8_mp_spawn_camera" );
        self.updateexpiredlootleader stoploopsound( self.updatefobindanger );
        self.updateexpiredlootleader delete();
        self.updateexpiredlootleader = undefined;
        self.updatefobindanger = undefined;
    }

    if ( !isdefined( self.spawncameraent ) )
        return;

    if ( istrue( level.gameended ) )
        return;

    scripts\mp\utility\player::hideminimap( 1 );
    thread _id_12A73();
    runslamzoomonspawn();
}

deletespawncamera()
{
    self cameraunlink();
    self.spawncameraent scripts\cp_mp\ent_manager::deregisterspawn();
    self.spawncameraent delete();
    self.spawncameraent = undefined;
    self.isusingspawnmapcamera = undefined;
    self.inspawncamera = 0;
    self notify( "spawn_camera_deleted" );
}

removecameraondisconnect( var_0 )
{
    self endon( "spawn_camera_deleted" );
    self waittill( "disconnect" );

    if ( isdefined( var_0 ) )
    {
        var_0 scripts\cp_mp\ent_manager::deregisterspawn();
        var_0 delete();
    }
}

_id_12A73()
{
    self endon( "disconnect" );
    self waittill( "spawncamera_start" );
    self predictstreampos( self geteye() );
    self waittill( "spawn_camera_complete" );
    self clearpredictedstreampos();
}

runslamzoomonspawn( var_0 )
{
    self endon( "disconnect" );
    scripts\mp\utility\player::_id_11B9C( "spawnCamera::runSlamZoomOnSpawn() START" );
    self waittill( "spawncamera_start" );
    scripts\mp\utility\player::_id_11B9C( "spawnCamera::runSlamZoomOnSpawn() spawncamera_start PASSED" );
    self notify( "slamZoomInitiated" );
    scripts\mp\utility\player::_freezecontrols( 1, undefined, "slamZoom" );
    self playerhide();
    self useinvisibleplayerduringspawnselection( 1 );
    self.plotarmor = 1;
    scripts\common\utility::allow_vehicle_use( 0 );
    scripts\mp\spectating::setdisabled();
    scripts\mp\utility\player::updatesessionstate( "spectator" );
    self cameralinkto( self.spawncameraent, "tag_origin", 1 );
    scripts\mp\utility\player::_id_11B9C( "spawnCamera::runSlamZoomOnSpawn() CameraLinkTo()" );
    handlemovetoblended();
    deletespawncamera();

    if ( self.team == "spectator" )
    {
        scripts\mp\playerlogic::removefromalivecount();
        self setclientomnvar( "ui_in_spawn_camera", 0 );

        if ( !istrue( level.nukedetonated ) )
            self visionsetnakedforplayer( "", 0.5 );

        scripts\mp\utility\player::_freezecontrols( 0, undefined, "slamZoom" );
        self useinvisibleplayerduringspawnselection( 0 );
        self.plotarmor = 0;
        thread scripts\mp\spectating::setspectatepermissions();
        return;
    }

    scripts\mp\utility\player::updatesessionstate( "playing" );

    if ( istrue( self._id_124F3 ) )
    {
        var_1 = scripts\mp\playerlogic::getspawnpoint();
        self setorigin( var_1.spawnorigin );
        self setplayerangles( var_1.spawnangles );
        scripts\mp\spawnlogic::finalizespawnpointchoice( var_1.spawnpoint );
        self._id_124F3 = undefined;
        self.selectedspawnarea = undefined;
    }

    self setclientomnvar( "ui_in_spawn_camera", 0 );

    if ( !istrue( level.nukedetonated ) )
        self visionsetnakedforplayer( "", 0.5 );

    scripts\mp\utility\player::_freezecontrols( 0, undefined, "slamZoom" );
    self playershow();
    self useinvisibleplayerduringspawnselection( 0 );
    self.plotarmor = 0;
    scripts\common\utility::allow_vehicle_use( 1 );
    self notify( "spawned_player" );
    level notify( "player_spawned", self, self.wasrevivespawn );
    thread scripts\mp\playerlogic::setspawnnotifyomnvar();
    self.wasrevivespawn = undefined;
    self.delayedspawnedplayernotify = undefined;
    self.spawndata = undefined;
    scripts\mp\utility\player::_id_11B9C( "spawnCamera::runSlamZoomOnSpawn() COMPLETE" );
}

handlemoveto( var_0 )
{
    self endon( "disconnect" );
    var_1 = self geteye();
    var_2 = self.angles;
    var_3 = ( var_1[0], var_1[1], self.spawncameraent.origin[2] );
    var_3 = var_3 + anglestoforward( var_2 ) * -480;
    self.spawncameraent moveto( var_3, 0.75, 0.25, 0.25 );
    var_4 = vectornormalize( var_1 - var_3 );
    var_5 = scripts\mp\utility\script::vectortoanglessafe( var_4, ( 0, 0, 1 ) );
    self.spawncameraent rotateto( var_5, 0.75, 0.25, 0.25 );
    wait 0.75;
    self visionsetnakedforplayer( "tac_ops_slamzoom", 0.2 );
    var_6 = var_1 + anglestoforward( var_2 ) * -60;
    self.spawncameraent moveto( var_6, 0.5, 0.1, 0.4 );
    self.spawncameraent rotateto( var_2, 0.7, 0.45, 0.05 );
    wait 0.5;
    thread playslamzoomflash();
    self.spawncameraent moveto( var_1, 0.6, 0.1, 0.1 );
    wait 0.2;
    self visionsetnakedforplayer( "", 0 );
}

handlemovetoblended( var_0 )
{
    self endon( "disconnect" );
    self endon( "kill_handle_move_to_blended" );
    scripts\mp\utility\player::_id_11B9C( "spawnCamera::handleMoveTo() START" );
    var_1 = self.spawndata.spawnorigin + ( 0, 0, 60 );
    var_2 = self.spawndata.spawnangles;

    if ( isdefined( self.forcespawncameraorg ) )
    {
        var_1 = self.forcespawncameraorg;
        var_2 = self.forcespawncameraang;
        self.forcespawncameraorg = undefined;
        self.forcespawncameraang = undefined;
    }

    var_3 = angle_diff( self.spawncameraent.angles[1], var_2[1] ) < 45;
    var_4 = distance2dsquared( self.spawncameraent.origin, var_1 ) > 1000000;
    thread fadeblackforgeo( var_1 );

    if ( !var_3 || !var_4 )
    {
        if ( !istrue( level.nukedetonated ) )
        {
            if ( !scripts\cp_mp\utility\game_utility::isnightmap() )
            {
                removethermal();
                self visionsetnakedforplayer( "", 0 );
            }
            else
                self visionsetnakedforplayer( "respawn_camera_night", 0 );
        }

        wait 0.05;
        self.spawncameraent moveto( var_1, 1.0, 0.1, 0.9 );
        self.spawncameraent rotateto( var_2, 1.0, 0.9, 0.1 );
        scripts\mp\utility\player::_id_11B9C( "spawnCamera::handleMoveTo() FULL Blend Set" );

        if ( !istrue( level.nukedetonated ) )
        {
            if ( !scripts\cp_mp\utility\game_utility::isnightmap() )
                self visionsetnakedforplayer( "tac_ops_slamzoom", 0.8 );
        }

        wait 0.8;
        wait 0.2;
    }
    else
    {
        var_5 = vectornormalize( var_1 - self.spawncameraent.origin );
        var_6 = scripts\mp\utility\script::vectortoanglessafe( var_5, ( 0, 0, 1 ) );
        self.spawncameraent rotateto( var_6, 0.7, 0.2, 0.2 );
        scripts\mp\utility\player::_id_11B9C( "spawnCamera::handleMoveTo() FIRST HALF Blend Set" );

        if ( !istrue( level.nukedetonated ) )
        {
            if ( !scripts\cp_mp\utility\game_utility::isnightmap() )
            {
                removethermal();
                self visionsetnakedforplayer( "", 0 );
            }
            else
                self visionsetnakedforplayer( "respawn_camera_night", 0 );
        }

        wait 0.05;
        self.spawncameraent moveto( var_1, 1.0, 0.1, 0.9 );

        if ( !istrue( level.nukedetonated ) )
        {
            if ( !scripts\cp_mp\utility\game_utility::isnightmap() )
                self visionsetnakedforplayer( "tac_ops_slamzoom", 0.8 );
        }

        wait 0.5;
        self.spawncameraent rotateto( var_2, 0.5, 0.2, 0.1 );
        scripts\mp\utility\player::_id_11B9C( "spawnCamera::handleMoveTo() SECOND HALF Blend Set" );
        wait 0.3;
        wait 0.2;
    }

    scripts\mp\utility\player::_id_11B9C( "spawnCamera::handleMoveTo() COMPLETE" );
    self notify( "spawn_camera_complete" );
}

fadeblackforgeo( var_0 )
{
    var_1 = [ "physicscontents_clipshot", "physicscontents_missileclip", "physicscontents_solid", "physicscontents_vehicle", "physicscontents_player", "physicscontents_actor", "physicscontents_glass", "physicscontents_itemclip" ];
    var_2 = physics_createcontents( var_1 );
    var_3 = scripts\engine\trace::ray_trace( self.spawncameraent.origin, var_0, undefined, var_2 );
    var_4 = scripts\engine\trace::ray_trace( var_0, self.spawncameraent.origin, undefined, var_2 );
    var_5 = var_3["fraction"];
    var_6 = var_4["fraction"];
    var_7 = 0.11;

    if ( istrue( self.spawningintovehicle ) )
    {
        self setsoundsubmix( "iw8_mp_vehicle_spawn", 0.1 );
        thread clear_plr_vehicle_submix();
    }

    if ( istrue( self.spawningintovehicle ) || scripts\cp_mp\utility\game_utility::isnightmap() )
    {
        self.spawningintovehicle = undefined;

        if ( isdefined( self._id_132CD ) && self._id_132CD == "light_tank" )
        {
            var_5 = min( var_5, 0.95 );
            var_6 = 0.0;
            var_7 = 0.75;
        }
        else
        {
            var_5 = min( var_5, 0.95 );
            var_6 = 0.0;
        }
    }

    if ( istrue( self._id_124F3 ) )
    {
        var_5 = min( var_5, 0.5 );
        var_6 = 0.0;
        thread _id_133AF();
    }

    if ( var_5 < 1.0 )
    {
        var_5 = clamp( var_5 - 0.1, 0.0, 0.95 );

        if ( var_5 - 0.22 > 0.0 )
            wait( var_5 - 0.22 );

        thread playslamzoomflash( 0.1, 1.0 - var_5 - var_6 + var_7, 0.25 );
    }
}

_id_133AF()
{
    self endon( "disconnect" );
    self waittill( "fadeUp_start" );
    self notify( "kill_handle_move_to_blended" );
}

clear_plr_vehicle_submix()
{
    wait 2.5;
    self clearsoundsubmix( "iw8_mp_vehicle_spawn", 1 );
}

playslamzoomflash( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    self.distort_fx = 0;

    if ( !isdefined( var_2 ) )
        var_2 = 0.5;

    self notify( "fadeDown_start" );

    if ( isdefined( var_0 ) && var_0 > 0 )
    {
        var_3 = 0.0;
        var_4 = var_0 / level.framedurationseconds;
        var_5 = 1.0 / var_4;
        var_6 = 0;

        while ( var_6 < var_4 )
        {
            var_6++;
            var_3 = var_3 + var_5;
            var_3 = clamp( var_3, 0.0, 1.0 );
            self setclientomnvar( "ui_world_fade", var_3 );
            waitframe();
        }
    }
    else
        self setclientomnvar( "ui_world_fade", 1.0 );

    self notify( "fadeDown_complete" );
    self.distort_fx = 1;

    if ( isdefined( var_1 ) && var_1 > 0 )
        wait( var_1 );

    self notify( "fadeUp_start" );

    if ( isdefined( var_2 ) && var_2 > 0 )
    {
        var_3 = 1.0;
        var_4 = var_2 / level.framedurationseconds;
        var_5 = 1.0 / var_4;
        var_6 = 0;

        while ( var_6 < var_4 )
        {
            var_6++;
            var_3 = var_3 - var_5;
            var_3 = clamp( var_3, 0.0, 1.0 );
            self setclientomnvar( "ui_world_fade", var_3 );
            waitframe();
        }
    }
    else
        self setclientomnvar( "ui_world_fade", 0.0 );

    self notify( "fadeUp_complete" );
}

movecameratomappos( var_0, var_1, var_2 )
{
    self moveto( var_1, 1.0, 0.5, 0.5 );
    self rotateto( var_2, 1.0, 0.5, 0.5 );
    var_0 thread startoperatorsound();
    wait 1.1;
}

applythermal()
{
    if ( istrue( self.spawncameraskipthermalonce ) )
    {
        self.spawncameraskipthermalonce = 0;
        return;
    }

    if ( istrue( self.spawncameraskipthermal ) )
        return;

    if ( !istrue( level.nukedetonated ) )
    {
        if ( scripts\cp_mp\utility\game_utility::isnightmap() )
            self visionsetnakedforplayer( "respawn_camera_night", 0 );
        else
            self visionsetnakedforplayer( "respawn_camera", 0 );
    }
}

removethermal()
{

}

startoperatorsound()
{
    self endon( "disconnect" );
    self endon( "game_ended" );

    if ( isdefined( self.updateexpiredlootleader ) )
        return;

    if ( istrue( level.nukeincoming ) )
        return;

    self.updateexpiredlootleader = spawn( "script_origin", ( 0, 0, 0 ) );
    self.updateexpiredlootleader showonlytoplayer( self );
    self setsoundsubmix( "iw8_mp_spawn_camera" );
    var_0 = scripts\mp\utility\teams::getteamvoiceinfix( self.team );
    var_1 = "dx_mpo_" + var_0 + "op_drone_deathchatter";

    if ( !soundexists( var_1 ) )
        var_1 = "dx_mpo_usop_drone_deathchatter";

    self.updatefobindanger = var_1;
    self.updateexpiredlootleader playloopsound( var_1 );
    thread invalid_for_teleport();
}

invalid_for_teleport()
{
    self endon( "spawned_player" );
    var_0 = self.updateexpiredlootleader;
    var_1 = self.updatefobindanger;
    self waittill( "disconnect" );

    if ( isdefined( var_0 ) )
    {
        var_0 stoploopsound( var_1 );
        var_0 delete();
    }
}

setgamemodecamera( var_0, var_1 )
{
    level.spawncameras["gamemode"][var_0] = var_1;
    setspawncamera( var_0, "gamemode" );
}

setspawncamera( var_0, var_1 )
{
    level.currentcamera[var_0] = var_1;
}

orientdefaulttomapcenterusingmapcorners()
{
    if ( !istrue( level.spawncameras["default"]["allies"].radiantplaced ) )
    {
        var_0 = level.mapcornercenter + level.spawncamerastartspawnalliesvec * level.spawncameradistfactor * -0.85 + ( 0, 0, 1 ) * level.spawncameradistfactor * 0.45;
        var_1 = vectornormalize( level.mapcornercenter - var_0 );
        var_2 = scripts\mp\utility\script::vectortoanglessafe( var_1, ( 0, 0, 1 ) );
        level.spawncameras["default"]["allies"].origin = var_0;
        level.spawncameras["default"]["allies"].angles = var_2;
    }

    if ( !istrue( level.spawncameras["default"]["axis"].radiantplaced ) )
    {
        var_3 = level.mapcornercenter + level.spawncamerastartspawnaxisvec * level.spawncameradistfactor * -0.85 + ( 0, 0, 1 ) * level.spawncameradistfactor * 0.45;
        var_1 = vectornormalize( level.mapcornercenter - var_3 );
        var_4 = scripts\mp\utility\script::vectortoanglessafe( var_1, ( 0, 0, 1 ) );
        level.spawncameras["default"]["axis"].origin = var_3;
        level.spawncameras["default"]["axis"].angles = var_4;
    }
}

orientdefaulttofrontline()
{
    var_0 = scripts\mp\utility\teams::getfriendlyplayers( "allies", 1 );
    var_1 = level.spawncamerastartspawnallies;

    if ( var_0.size > 0 )
    {
        var_1 = ( 0, 0, 0 );

        foreach ( var_3 in var_0 )
            var_1 = var_1 + var_3.origin;

        var_1 = var_1 / var_0.size;
    }

    var_5 = scripts\mp\utility\teams::getfriendlyplayers( "axis", 1 );
    var_6 = level.spawncamerastartspawnaxis;

    if ( var_5.size > 0 )
    {
        var_6 = ( 0, 0, 0 );

        foreach ( var_3 in var_5 )
            var_6 = var_6 + var_3.origin;

        var_6 = var_6 / var_5.size;
    }

    var_9 = var_6 - var_1;
    var_10 = vectornormalize( var_9 );
    var_11 = vectordot( var_9, var_9 );

    if ( var_11 < 1048576 )
        return;

    var_12 = level.mapcornercenter + var_10 * level.spawncameradistfactor * -0.5 + ( 0, 0, 1 ) * level.spawncameradistfactor * 0.2;
    var_13 = vectornormalize( level.mapcornercenter - var_12 );
    var_14 = scripts\mp\utility\script::vectortoanglessafe( var_13, ( 0, 0, 1 ) );
    level.spawncameras["default"]["allies"].origin = var_12;
    level.spawncameras["default"]["allies"].angles = var_14;
    var_15 = level.mapcornercenter + var_10 * level.spawncameradistfactor * 0.5 + ( 0, 0, 1 ) * level.spawncameradistfactor * 0.2;
    var_13 = vectornormalize( level.mapcornercenter - var_15 );
    var_16 = scripts\mp\utility\script::vectortoanglessafe( var_13, ( 0, 0, 1 ) );
    level.spawncameras["default"]["axis"].origin = var_15;
    level.spawncameras["default"]["axis"].angles = var_16;
    thread scripts\mp\utility\debug::drawline( var_12, level.mapcornercenter, 60.0, ( 0, 0, 1 ) );
    thread scripts\mp\utility\debug::drawline( var_15, level.mapcornercenter, 60.0, ( 1, 0, 0 ) );
}

calulatefrontline()
{
    var_0 = scripts\mp\utility\teams::getfriendlyplayers( "allies", 1 );
    var_1 = getstartspawnavg( "allies" );

    if ( var_0.size > 0 )
    {
        var_1 = ( 0, 0, 0 );

        foreach ( var_3 in var_0 )
            var_1 = var_1 + var_3.origin;

        var_1 = var_1 / var_0.size;
    }

    var_5 = scripts\mp\utility\teams::getfriendlyplayers( "axis", 1 );
    var_6 = getstartspawnavg( "axis" );

    if ( var_5.size > 0 )
    {
        var_6 = ( 0, 0, 0 );

        foreach ( var_3 in var_5 )
            var_6 = var_6 + var_3.origin;

        var_6 = var_6 / var_5.size;
    }

    var_9 = var_6 - var_1;
    var_10 = vectornormalize( var_9 );
    var_11 = spawnstruct();
    var_11.origin = ( var_1 + var_6 ) * 0.5;
    var_11.angles = vectorcross( var_10, ( 0, 0, 1 ) );
    var_11.teamavg = [];
    var_11.teamavg["allies"] = var_1;
    var_11.teamavg["axis"] = var_6;
    return var_11;
}

getstartspawnavg( var_0 )
{
    if ( isdefined( level.startspawnavg ) && isdefined( level.startspawnavg[var_0] ) )
        return level.startspawnavg[var_0];

    if ( !isdefined( level.startspawnavg ) )
        level.startspawnavg = [];

    level.startspawnavg[var_0] = ( 0, 0, 0 );
    var_1 = scripts\mp\spawnlogic::getspawnpointarray( "mp_tdm_spawn_" + var_0 + "_start" );
    var_2 = ( 0, 0, 0 );

    foreach ( var_4 in var_1 )
        var_2 = var_2 + var_4.origin;

    if ( var_1.size > 0 )
        var_2 = var_2 / var_1.size;

    level.startspawnavg[var_0] = var_2;
    return level.startspawnavg[var_0];
}

angle_diff( var_0, var_1 )
{
    return 180 - abs( abs( var_0 - var_1 ) - 180 );
}
