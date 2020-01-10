# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Thu Jan 9 20:39:36 2020
# Designs open: 1
#   Sim: /home/kaifengx/anycore/build/manycore/rel-0.1/simv
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.dispatch.ldVioPred
#   Group count = 2
#   Group g_anycore_core.anycore_decoder signal count = 44
#   Group g_anycore_core.l15_anycoreencoder signal count = 52
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


# Create and position top-level window: TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{8 35} {1916 1036}}

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
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 451]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 451
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 450} {height 737} {dock_state left} {dock_on_new_line true} {child_hier_colhier 417} {child_hier_coltype 100} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 438]
catch { set Data.1 [gui_share_window -id ${DLPane.1} -type Data] }
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 438
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 737
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 437} {height 737} {dock_state left} {dock_on_new_line true} {child_data_colvariable 228} {child_data_colvalue 114} {child_data_coltype 96} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 166]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1860
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 166
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 1908} {height 165} {dock_state bottom} {dock_on_new_line true}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}

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

gui_sg_addsignal -group "$_session_group_1" { cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.LOAD_ACTIVE cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.LOAD_IDLE cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.STORE_ACTIVE cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.STORE_IDLE cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_ldaddr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_ldvalid cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_staddr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_stdata cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_stsize cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_dc2mem_stvalid cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_ic2mem_reqaddr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_ic2mem_reqvalid cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_imiss_full_addr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_load_full_addr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycore_store_full_addr cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_address cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_address_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_blockinitstore cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_blockstore cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_csm_data cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_data cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_data_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_data_next_entry cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_invalidate_cacheline cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_l1rplway cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_nc cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_prefetch cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_rqtype cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_rqtype_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_size cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_size_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_threadid cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.anycoredecoder_l15_val cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.clk cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.current_val cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.l15_transducer_ack cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.load_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.load_reg cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.new_load cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.new_store cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.prev_val cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.rst_n cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.store_next cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.store_reg }
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.LOAD_ACTIVE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.LOAD_IDLE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.STORE_ACTIVE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.anycore_decoder.STORE_IDLE}

set _session_group_2 g_anycore_core.l15_anycoreencoder
gui_sg_create "$_session_group_2"
set g_anycore_core.l15_anycoreencoder "$_session_group_2"

gui_sg_addsignal -group "$_session_group_2" { cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.LOAD_ACTIVE cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.LOAD_IDLE cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.STORE_ACTIVE cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.STORE_IDLE cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_dc2mem_stvalid cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_int cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_lddata cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_ldindex cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_ldtag cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_ldvalid cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_stcomplete cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2dc_ststall cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2ic_data cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2ic_index cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2ic_respvalid cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycore_mem2ic_tag cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.anycoreencoder_l15_req_ack cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.clk cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.int_recv cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_address cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_address_sext cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_atomic cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_blockinitstore cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_cross_invalidate cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_cross_invalidate_way cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_0 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_0_swap cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_1 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_1_swap cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_2 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_2_swap cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_3 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_data_3_swap cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_error cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_f4b cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_address_15_4 cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_dcache_all_way cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_dcache_inval cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_icache_all_way cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_icache_inval cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_inval_way cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_l2miss cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_noncacheable cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_prefetch cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_returntype cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_threadid cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.l15_anycoreencoder_val }
gui_sg_addsignal -group "$_session_group_2" { cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.load_next cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.load_reg cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.rst_n cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.store_next cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.store_reg }
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.LOAD_ACTIVE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.LOAD_IDLE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.STORE_ACTIVE}
gui_set_radix -radix {strength} -signals {Sim:cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder.STORE_IDLE}

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 6682500



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


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design Sim
catch {gui_list_expand -id ${Hier.1} cmp_top}
catch {gui_list_expand -id ${Hier.1} cmp_top.system}
catch {gui_list_expand -id ${Hier.1} cmp_top.system.chip}
catch {gui_list_expand -id ${Hier.1} cmp_top.system.chip.tile0}
catch {gui_list_select -id ${Hier.1} {cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder}}
gui_view_scroll -id ${Hier.1} -vertical -set 273
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {cmp_top.system.chip.tile0.g_anycore_core.l15_anycoreencoder}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 273
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active cmp_top.system.chip.tile0.g_anycore_core.core.coreTop.dispatch.ldVioPred /home/kaifengx/anycore/piton/design/chip/tile/anycore/dispatch/ldViolationPred.sv
gui_view_scroll -id ${Source.1} -vertical -set 1575
gui_src_set_reusable -id ${Source.1}
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
	gui_set_active_window -window ${HSPane.1}
}
#</Session>

