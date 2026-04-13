
CLASS lsc_zcii_trmt_it023 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
    METHODS cleanup_finalize  REDEFINITION.
ENDCLASS.

CLASS lsc_zcii_trmt_it023 IMPLEMENTATION.
  METHOD finalize.          ENDMETHOD.
  METHOD check_before_save. ENDMETHOD.

  METHOD save.
    DATA(lo_util) = zcl_trm_it023_u=>get_instance( ).
    lo_util->get_hdr_value( IMPORTING ex_tournament = DATA(ls_tournament) ).
    lo_util->get_itm_value( IMPORTING ex_match      = DATA(ls_match) ).
    lo_util->get_hdr_t_deletion( IMPORTING ex_tournaments = DATA(lt_del_trn) ).
    lo_util->get_itm_t_deletion( IMPORTING ex_matches     = DATA(lt_del_mtch) ).
    lo_util->get_deletion_flags( IMPORTING ex_hdr_del     = DATA(lv_hdr_del) ).

    " 1. Save / Update Tournament Header
    IF ls_tournament IS NOT INITIAL.
      MODIFY zcit_trmt_it023 FROM @ls_tournament.
    ENDIF.

    " 2. Save / Update Match Item
    IF ls_match IS NOT INITIAL.
      MODIFY zcit_mtch_it023 FROM @ls_match.
    ENDIF.

    " 3. Handle Deletions
    IF lv_hdr_del = abap_true.
      " Cascade delete header + all its matches
      LOOP AT lt_del_trn INTO DATA(ls_del_trn).
        DELETE FROM zcit_trmt_it023
          WHERE tournamentid = @ls_del_trn-tournamentid.
        DELETE FROM zcit_mtch_it023
          WHERE tournamentid = @ls_del_trn-tournamentid.
      ENDLOOP.
    ELSE.
      LOOP AT lt_del_trn INTO ls_del_trn.
        DELETE FROM zcit_trmt_it023
          WHERE tournamentid = @ls_del_trn-tournamentid.
      ENDLOOP.
      LOOP AT lt_del_mtch INTO DATA(ls_del_mtch).
        DELETE FROM zcit_mtch_it023
          WHERE tournamentid = @ls_del_mtch-tournamentid
            AND matchnumber  = @ls_del_mtch-matchnumber.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    zcl_trm_it023_u=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.

  METHOD cleanup_finalize. ENDMETHOD.
ENDCLASS.
