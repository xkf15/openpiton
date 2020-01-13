# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Sun Jan 12 01:48:31 2020
# Designs open: 1
#   Sim: /home/kaifengx/anycore/build/manycore/rel-0.1/simv
# Toplevel windows open: 1
# 	TopLevel.2
#   Wave.1: 167 signals
#   Group count = 4
#   Group g_anycore_core.anycore_decoder signal count = 45
#   Group g_anycore_core.l15_anycoreencoder signal count = 53
#   Group Group1 signal count = 2
#   Group fs1 signal count = 67
# End_DVE_Session_Save_Info

# DVE version: O-2018.09-SP2_Full64
# DVE build date: Feb 28 2019 23:39:41


#<Session mode="Full" path="/home/kaifengx/anycore/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state normal -rect {{28 51} {1866 1029}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.2}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 533} {child_wave_right 1300} {child_wave_colname 264} {child_wave_colvalue 264} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) none
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) none
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.2}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { [llength [lindex [gui_get_db -design Sim] 0]] == 0 } {
gui_set_env SIMSETUP::SIMARGS {{+wait_cycle_to_kill=10 +dowarningfinish +doerrorfinish +spc_pipe=0 +vcs+dumpvarsoff +TIMEOUT=50000 +tg_seed=0 +asm_diag_name=rv64-helloworld.S +dv_root=/home/kaifengx/anycore/piton}}
gui_set_env SIMSETUP::SIMEXE {/home/kaifengx/anycore/build/manycore/rel-0.1/simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {/home/kaifengx/anycore/build/manycore/rel-0.1/simv}] } {
gui_sim_run Ucli -exe simv -args { +wait_cycle_to_kill=10 +dowarningfinish +doerrorfinish +spc_pipe=0 +vcs+dumpvarsoff +TIMEOUT=50000 +tg_seed=0 +asm_diag_name=rv64-helloworld.S +dv_root=/home/kaifengx/anycore/piton -ucligui} -dir /home/kaifengx/anycore/build/manycore/rel-0.1 -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 1ps
gui_set_time_units 1ps
#</Database>

# DVE Global setting session: 


# Global: Breakpoints

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups


set _session_group_1 g_anycore_core.anycore_decoder
gui_sg_create "$_session_group_1"
set g_anycore_core.anycore_decoder "$_session_group_1"

gui_sg_addsignal -group "$_session_group_1" { cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.STORE_IDLE cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.load_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.store_reg cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_ic2mem_reqvalid cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_ic2mem_reqaddr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.LOAD_IDLE cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.l15_transducer_ack cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_stdata_flipped cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_load_full_addr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_blockstore cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_stdata cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_address_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.new_load cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_data_next_entry cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_blockinitstore cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_stsize cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.prev_val cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_staddr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.current_val cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_data cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_csm_data cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_l1rplway cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_prefetch cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_size cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_rqtype_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_rqtype cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_size_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_address cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_data_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.new_store cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_stvalid cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.STORE_ACTIVE cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_imiss_full_addr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_val cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.clk cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.LOAD_ACTIVE cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_threadid cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.rst_n cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_ldvalid cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.load_reg cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.store_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_invalidate_cacheline cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_ldaddr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_store_full_addr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_nc }
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.STORE_IDLE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.LOAD_IDLE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.STORE_ACTIVE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.LOAD_ACTIVE}

set _session_group_2 g_anycore_core.l15_anycoreencoder
gui_sg_create "$_session_group_2"
set g_anycore_core.l15_anycoreencoder "$_session_group_2"

gui_sg_addsignal -group "$_session_group_2" { cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2ic_respvalid cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.LOAD_IDLE cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycoreencoder_l15_req_ack cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2ic_data cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_l2miss cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_dc2mem_ldvalid cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_cross_invalidate cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_f4b cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_dcache_inval cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.LOAD_ACTIVE cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.clk cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_0 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_1 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_2 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_3 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_1_swap cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.store_next cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_blockinitstore cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_stcomplete cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_address_sext cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_3_swap cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_icache_all_way cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.rst_n cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_int cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.STORE_ACTIVE cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_dcache_all_way cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.STORE_IDLE cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_ldvalid cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.int_recv cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_cross_invalidate_way cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.store_reg cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_ststall cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_atomic cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_prefetch cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_0_swap cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_address cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_way cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_noncacheable cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_ldindex cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_address_15_4 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_icache_inval cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_2_swap cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.load_next cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2ic_tag cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_lddata cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_dc2mem_stvalid cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2ic_index cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_ldtag }
gui_sg_addsignal -group "$_session_group_2" { cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.load_reg cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_val cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_error cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_returntype cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_threadid }
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.LOAD_IDLE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.LOAD_ACTIVE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.STORE_ACTIVE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.STORE_IDLE}

set _session_group_3 Group1
gui_sg_create "$_session_group_3"
set Group1 "$_session_group_3"

gui_sg_addsignal -group "$_session_group_3" { cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.activeList.commitPC cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.activeList.commitReady }

set _session_group_4 fs1
gui_sg_create "$_session_group_4"
set fs1 "$_session_group_4"

gui_sg_addsignal -group "$_session_group_4" { cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.PC cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.addrRAS cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.addrRAS_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.bpRamReady_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.btbPacket cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.btbRamReady_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.clk cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.exceptionFlag_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.exceptionPC_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fetchReq cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fetchReq_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fs1Ready_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fs2CallPC_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fs2MissedCall_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fs2MissedReturn_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fs2Packet_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fs2RecoverFlag_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fs2RecoverPC_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.ic2memReqAddr_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.ic2memReqValid_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.icMiss_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.icScratchModeEn_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.icScratchRdData_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.icScratchWrAddr_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.icScratchWrData_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.icScratchWrEn_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.instException cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.instException_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.instPC cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.instPC_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.instValid cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.instValid_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.inst cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.inst_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.mem2icData_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.mem2icIndex_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.mem2icRespValid_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.mem2icTag_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.nextPC cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.nextSeqNo cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.numFetchLaneActive cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.numValidInsts cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.popRAS cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.predCounter_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.predDir cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.predNPC cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.predTaken cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.pushAddr cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.pushRAS cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.rasRamReady_o cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.recoverFlag_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.recoverPC_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.reset cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.resetFetch_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.resetRams_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.seqNo cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.stall_i }
gui_sg_addsignal -group "$_session_group_4" { cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.startPC_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.takenVect cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.updateBPB cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.updateBTB cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.updateBrType_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.updateCounter_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.updateDir_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.updateEn_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.updateNPC_i cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.updatePC_i }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 6417500



# Save global setting...

# Wave/List view global setting
gui_list_create_group_when_add -wave -enable
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 6395205 6452615
gui_list_add_group -id ${Wave.1} -after {New Group} {g_anycore_core.anycore_decoder}
gui_list_add_group -id ${Wave.1} -after {New Group} {g_anycore_core.l15_anycoreencoder}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group1}
gui_list_add_group -id ${Wave.1} -after {New Group} {fs1}
gui_list_collapse -id ${Wave.1} g_anycore_core.anycore_decoder
gui_list_collapse -id ${Wave.1} g_anycore_core.l15_anycoreencoder
gui_list_expand -id ${Wave.1} cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.activeList.commitPC
gui_list_select -id ${Wave.1} {cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.fs1.fetchReq }
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group fs1  -position in

gui_marker_move -id ${Wave.1} {C1} 6417500
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

