CLASS lhc_Tournament DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations
      FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR Tournament RESULT result.
    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR Tournament RESULT result.
    METHODS create FOR MODIFY IMPORTING entities FOR CREATE Tournament.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Tournament.
    METHODS delete FOR MODIFY IMPORTING keys    FOR DELETE Tournament.
    METHODS read   FOR READ   IMPORTING keys    FOR READ   Tournament RESULT result.
    METHODS lock   FOR LOCK   IMPORTING keys    FOR LOCK   Tournament.
    METHODS rba_Match FOR READ
      IMPORTING keys_rba FOR READ Tournament\_Match
      FULL result_requested RESULT result LINK association_links.
    METHODS cba_Match FOR MODIFY
      IMPORTING entities_cba FOR CREATE Tournament\_Match.
ENDCLASS.

CLASS lhc_Tournament IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.   ENDMETHOD.
  METHOD lock.                        ENDMETHOD.

  METHOD create.
    DATA ls_tournament TYPE zcit_trmt_it023.
    LOOP AT entities INTO DATA(ls_entity).
      ls_tournament = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_tournament-tournamentid IS NOT INITIAL.
        SELECT FROM zcit_trmt_it023 FIELDS *
          WHERE tournamentid = @ls_tournament-tournamentid
          INTO TABLE @DATA(lt_existing).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_trm_it023_u=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_tournament = ls_tournament
            IMPORTING ex_created    = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( %cid = ls_entity-%cid
                            tournamentid = ls_tournament-tournamentid )
              TO mapped-tournament.
            APPEND VALUE #( %cid = ls_entity-%cid
                            tournamentid = ls_tournament-tournamentid
                            %msg = new_message( id = 'ZCIT_IT023_MSG'
                              number = 001 v1 = 'Tournament Created'
                              severity = if_abap_behv_message=>severity-success ) )
              TO reported-tournament.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entity-%cid
                          tournamentid = ls_tournament-tournamentid )
            TO failed-tournament.
          APPEND VALUE #( %cid = ls_entity-%cid
                          tournamentid = ls_tournament-tournamentid
                          %msg = new_message( id = 'ZCIT_IT023_MSG'
                            number = 002 v1 = 'Tournament Already Exists'
                            severity = if_abap_behv_message=>severity-error ) )
            TO reported-tournament.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA ls_tournament TYPE zcit_trmt_it023.
    LOOP AT entities INTO DATA(ls_entity).
      ls_tournament = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_tournament-tournamentid IS NOT INITIAL.
        SELECT FROM zcit_trmt_it023 FIELDS *
          WHERE tournamentid = @ls_tournament-tournamentid
          INTO TABLE @DATA(lt_existing).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_trm_it023_u=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_tournament = ls_tournament
            IMPORTING ex_created    = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( tournamentid = ls_tournament-tournamentid )
              TO mapped-tournament.
            APPEND VALUE #( %key = ls_entity-%key
                            %msg = new_message( id = 'ZCIT_IT023_MSG'
                              number = 001 v1 = 'Tournament Updated'
                              severity = if_abap_behv_message=>severity-success ) )
              TO reported-tournament.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
                          tournamentid = ls_tournament-tournamentid )
            TO failed-tournament.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
                          tournamentid = ls_tournament-tournamentid
                          %msg = new_message( id = 'ZCIT_IT023_MSG'
                            number = 003 v1 = 'Tournament Not Found'
                            severity = if_abap_behv_message=>severity-error ) )
            TO reported-tournament.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA ls_trn TYPE zcl_trm_it023_u=>ty_tournament.
    DATA(lo_util) = zcl_trm_it023_u=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_trn.
      ls_trn-tournamentid = ls_key-tournamentid.
      lo_util->set_hdr_t_deletion( im_tournament = ls_trn ).
      lo_util->set_hdr_deletion_flag( im_delete = abap_true ).
      APPEND VALUE #( %cid = ls_key-%cid_ref
                      tournamentid = ls_key-tournamentid
                      %msg = new_message( id = 'ZCIT_IT023_MSG'
                        number = 001 v1 = 'Tournament Deleted'
                        severity = if_abap_behv_message=>severity-success ) )
        TO reported-tournament.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zcit_trmt_it023 FIELDS *
        WHERE tournamentid = @ls_key-tournamentid
        INTO @DATA(ls_trn).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_trn ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Match.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zcit_mtch_it023 FIELDS *
        WHERE tournamentid = @ls_key-tournamentid
        INTO TABLE @DATA(lt_matches).
      LOOP AT lt_matches INTO DATA(ls_match).
        APPEND CORRESPONDING #( ls_match ) TO result.
        APPEND VALUE #(
          source-tournamentid = ls_key-tournamentid
          target-tournamentid = ls_match-tournamentid
          target-matchnumber  = ls_match-matchnumber )
          TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Match.
    DATA ls_match TYPE zcit_mtch_it023.
    LOOP AT entities_cba INTO DATA(ls_cba).
      ls_match = CORRESPONDING #( ls_cba-%target[ 1 ] ).
      IF ls_match-tournamentid IS NOT INITIAL AND ls_match-matchnumber IS NOT INITIAL.
        SELECT FROM zcit_mtch_it023 FIELDS *
          WHERE tournamentid = @ls_match-tournamentid
            AND matchnumber  = @ls_match-matchnumber
          INTO TABLE @DATA(lt_existing).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_trm_it023_u=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_match   = ls_match
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #(
              %cid         = ls_cba-%target[ 1 ]-%cid
              tournamentid = ls_match-tournamentid
              matchnumber  = ls_match-matchnumber )
              TO mapped-match.
            APPEND VALUE #(
              %cid         = ls_cba-%target[ 1 ]-%cid
              tournamentid = ls_match-tournamentid
              %msg = new_message( id = 'ZCIT_IT023_MSG' number = 001
                v1 = 'Match Created'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-match.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid         = ls_cba-%target[ 1 ]-%cid
            tournamentid = ls_match-tournamentid
            matchnumber  = ls_match-matchnumber )
            TO failed-match.
          APPEND VALUE #(
            %cid         = ls_cba-%target[ 1 ]-%cid
            tournamentid = ls_match-tournamentid
            %msg = new_message( id = 'ZCIT_IT023_MSG' number = 002
              v1 = 'Duplicate Match Number'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-match.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
