CLASS zcl_trm_it023_u DEFINITION
  PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_tournament,
        tournamentid TYPE zcit_tourn_id,
      END OF ty_tournament,
      BEGIN OF ty_match,
        tournamentid TYPE zcit_tourn_id,
        matchnumber  TYPE int2, " Fixed: Changed from abap.int2 to int2
      END OF ty_match,
      tt_tournament TYPE STANDARD TABLE OF ty_tournament,
      tt_match      TYPE STANDARD TABLE OF ty_match.

    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_trm_it023_u.

    METHODS:
      set_hdr_value
        IMPORTING im_tournament TYPE zcit_trmt_it023
        EXPORTING ex_created    TYPE abap_boolean,
      get_hdr_value
        EXPORTING ex_tournament TYPE zcit_trmt_it023,
      set_itm_value
        IMPORTING im_match   TYPE zcit_mtch_it023
        EXPORTING ex_created TYPE abap_boolean,
      get_itm_value
        EXPORTING ex_match TYPE zcit_mtch_it023,
      set_hdr_t_deletion
        IMPORTING im_tournament TYPE ty_tournament,
      set_itm_t_deletion
        IMPORTING im_match_info TYPE ty_match,
      get_hdr_t_deletion
        EXPORTING ex_tournaments TYPE tt_tournament,
      get_itm_t_deletion
        EXPORTING ex_matches TYPE tt_match,
      set_hdr_deletion_flag
        IMPORTING im_delete TYPE abap_boolean,
      get_deletion_flags
        EXPORTING ex_hdr_del TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA:
      gs_tournament_buff TYPE zcit_trmt_it023,
      gs_match_buff      TYPE zcit_mtch_it023,
      gt_hdr_del_buff    TYPE tt_tournament,
      gt_itm_del_buff    TYPE tt_match,
      gv_hdr_delete      TYPE abap_boolean.
    CLASS-DATA mo_instance TYPE REF TO zcl_trm_it023_u.
ENDCLASS.

CLASS zcl_trm_it023_u IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF im_tournament-tournamentid IS NOT INITIAL.
      gs_tournament_buff = im_tournament.
      ex_created = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value.
    ex_tournament = gs_tournament_buff.
  ENDMETHOD.

  METHOD set_itm_value.
    IF im_match IS NOT INITIAL.
      gs_match_buff = im_match.
      ex_created = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_itm_value.
    ex_match = gs_match_buff.
  ENDMETHOD.

  METHOD set_hdr_t_deletion.
    APPEND im_tournament TO gt_hdr_del_buff.
  ENDMETHOD.

  METHOD set_itm_t_deletion.
    APPEND im_match_info TO gt_itm_del_buff.
  ENDMETHOD.

  METHOD get_hdr_t_deletion.
    ex_tournaments = gt_hdr_del_buff.
  ENDMETHOD.

  METHOD get_itm_t_deletion.
    ex_matches = gt_itm_del_buff.
  ENDMETHOD.

  METHOD set_hdr_deletion_flag.
    gv_hdr_delete = im_delete.
  ENDMETHOD.

  METHOD get_deletion_flags.
    ex_hdr_del = gv_hdr_delete.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_tournament_buff, gs_match_buff,
           gt_hdr_del_buff, gt_itm_del_buff, gv_hdr_delete.
  ENDMETHOD.
ENDCLASS.
