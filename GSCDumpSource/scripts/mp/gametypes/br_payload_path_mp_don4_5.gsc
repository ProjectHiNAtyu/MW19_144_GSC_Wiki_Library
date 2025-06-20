// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

relic_amped_explosion_time( var_0, var_1, var_2 )
{
    if ( level.mapname != "mp_don4" )
        return;

    if ( level.completesmokinggunquest.vehicle_docollisiondamagetoplayer != var_1 && !isdefined( level.completesmokinggunquest.vehicle_collision_ignorefutureevent ) )
        return;

    if ( !isdefined( level.completesmokinggunquest.paths ) )
        level.completesmokinggunquest.paths = [];

    var_3 = spawnstruct();
    var_3.nodes = [];
    var_3.origin = ( -24301, -31649, -117.774 );
    var_3.script_index = var_0;
    var_3.get_player_who_most_recently_threw_grenade = var_2;
    var_3.nodes[0] = var_3;
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -23801.7, -31633.8, -81.6388 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -23304.9, -31603.2, -30.8847 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -22807.2, -31573, 10.7385 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -22310.9, -31520.4, 45.5008 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -21822.5, -31411.2, 66.2056 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -21363.3, -31210.6, 77.9 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -20919.7, -30976.4, 86.438 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -20495.9, -30708.9, 91.2883 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -20070.7, -30444.4, 92.8992 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -19656, -30163.9, 92.1523 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -19250.8, -29869.9, 89.9352 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -18844.1, -29577.3, 87.4804 );
    var_3.nodes[var_4].obstacle = spawnstruct();
    var_3.nodes[var_4].obstacle.origin = ( -18457.7, -29299.4, 87.1685 );
    var_3.nodes[var_4].obstacle.angles = ( 270.363, 35.7279, 0 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -18437.6, -29284.9, 84.7835 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -18020.4, -29009.2, 79.0471 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -17591.1, -28751.9, 66.9004 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -17162.4, -28494.5, 58.1464 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -16712.3, -28276.6, 56.7571 );
    var_3.nodes[var_4].checkpoint = 1;
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -16215.5, -28217.3, 58.0531 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -15717, -28260.8, 25.3084 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -15229.2, -28363.7, -14.6942 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -14767.2, -28556.1, -35.7584 );
    var_3.nodes[var_4].obstacle = spawnstruct();
    var_3.nodes[var_4].obstacle.origin = ( -14539.4, -28974, -36.0002 );
    var_3.nodes[var_4].obstacle.angles = ( 270, 298.59, 0 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -14647.3, -28776.1, -37.4164 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -14424.5, -29225.4, -38.377 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -14174.3, -29658.3, -38.3726 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -13859.4, -30047.7, -38.3961 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -13421.7, -30292.7, -38.5325 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -12922.4, -30322.2, -39.2306 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -12451.5, -30150.4, -39.3357 );
    var_3.nodes[var_4].obstacle = spawnstruct();
    var_3.nodes[var_4].obstacle.origin = ( -12047.2, -29899.2, -35.653 );
    var_3.nodes[var_4].obstacle.angles = ( 270, 31.8539, 0 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -12025.8, -29885.9, -37.9816 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -11610.8, -29604.8, -35.552 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -11193.1, -29328.2, -26.6858 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -10749.7, -29094.8, -27.4318 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -10301.8, -28870, -27.7628 );
    var_3.nodes[var_4].checkpoint = 1;
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -9818.94, -28735, -28.5679 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -9318.54, -28762.2, -20.9473 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -8822.49, -28823.3, 12.2011 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -8409.45, -29105.2, 27.3391 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -8065.91, -29470, 34.8898 );
    var_3.nodes[var_4].obstacle = spawnstruct();
    var_3.nodes[var_4].obstacle.origin = ( -7812.88, -29871, 79.9402 );
    var_3.nodes[var_4].obstacle.angles = ( 274.985, 302.255, 0 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -7799.98, -29891.4, 79.2458 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -7540.03, -30316.7, 121.631 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -7303.74, -30756.9, 160.383 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -6980.4, -31139, 182.297 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -6606.5, -31466.5, 241.518 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -6146.9, -31976.6, 290.029 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -5834.41, -31926.6, 289.127 );
    var_3.nodes[var_4].obstacle = spawnstruct();
    var_3.nodes[var_4].obstacle.origin = ( -5480.61, -31608.2, 286.793 );
    var_3.nodes[var_4].obstacle.angles = ( 271.012, 41.9856, 0 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -5509.38, -31634.1, 285.111 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -5081.94, -31371.8, 284.583 );
    var_4 = var_3.nodes.size;
    var_3.nodes[var_4] = spawnstruct();
    var_3.nodes[var_4].origin = ( -4722.89, -31122.2, 281.611 );
    scripts\mp\gametypes\br_gametype_payload.gsc::_id_123AD( var_0, var_2 );
    level.completesmokinggunquest.paths[level.completesmokinggunquest.paths.size] = var_3;
}
