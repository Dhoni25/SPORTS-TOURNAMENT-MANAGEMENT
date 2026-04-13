CLASS lhc_Match DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Match.
    METHODS delete FOR MODIFY IMPORTING keys    FOR DELETE Match.
    METHODS read   FOR READ   IMPORTING keys    FOR READ   Match RESULT result.
    METHODS rba_Tournament FOR READ
      IMPORTING keys_rba FOR READ Match\_Tournament
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_Match IMPLEMENTATION.
  METHOD update.
    DATA ls_match TYPE zcit_mtch_it023.
    LOOP AT entities INTO DATA(ls_entity).
      ls_match = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_match-tournamentid IS NOT INITIAL.
        SELECT FROM zcit_mtch_it023 FIELDS *
          WHERE tournamentid = @ls_match-tournamentid
            AND matchnumber  = @ls_match-matchnumber
          INTO TABLE @DATA(lt_existing).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_trm_it023_u=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_match   = ls_match
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #(
              tournamentid = ls_match-tournamentid
              matchnumber  = ls_match-matchnumber )
              TO mapped-match.
            APPEND VALUE #( %key = ls_entity-%key
                            %msg = new_message( id = 'ZCIT_IT023_MSG'
                              number = 001 v1 = 'Match Updated'
                              severity = if_abap_behv_message=>severity-success ) )
              TO reported-match.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
                          tournamentid = ls_match-tournamentid
                          matchnumber  = ls_match-matchnumber )
            TO failed-match.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
                          tournamentid = ls_match-tournamentid
                          %msg = new_message( id = 'ZCIT_IT023_MSG'
                            number = 003 v1 = 'Match Not Found'
                            severity = if_abap_behv_message=>severity-error ) )
            TO reported-match.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA ls_match_info TYPE zcl_trm_it023_u=>ty_match.
    DATA(lo_util) = zcl_trm_it023_u=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_match_info.
      ls_match_info-tournamentid = ls_key-tournamentid.
      ls_match_info-matchnumber  = ls_key-matchnumber.
      lo_util->set_itm_t_deletion( im_match_info = ls_match_info ).
      APPEND VALUE #( %cid = ls_key-%cid_ref
                      tournamentid = ls_key-tournamentid
                      matchnumber  = ls_key-matchnumber
                      %msg = new_message( id = 'ZCIT_IT023_MSG'
                        number = 001 v1 = 'Match Deleted'
                        severity = if_abap_behv_message=>severity-success ) )
        TO reported-match.
    ENDLOOP.
  ENDMETHOD.

  METHOD read. ENDMETHOD.
  METHOD rba_Tournament. ENDMETHOD.
ENDCLASS.
