// IW8 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool

init()
{
    var_0 = spawnstruct();
    var_0._id_13152 = ::_id_13152;
    var_0.allow_br_loot_to_br_marked = ::allow_br_loot_to_br_marked;
    var_0.weight = getdvarfloat( "scr_br_pe_bombardment_weight", 1.0 );
    scripts\mp\gametypes\br_publicevents.gsc::_id_11DFD( 5, var_0 );
}

_id_13152()
{
    return 0;
}

allow_br_loot_to_br_marked()
{

}
