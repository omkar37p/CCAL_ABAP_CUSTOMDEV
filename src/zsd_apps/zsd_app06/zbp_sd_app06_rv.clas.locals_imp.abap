CLASS lhc_zsd_app06_rv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS getout FOR MODIFY
      IMPORTING keys FOR ACTION header~getout RESULT result.

ENDCLASS.

CLASS lhc_zsd_app06_rv IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zsd_app06_rv IN LOCAL MODE
      ENTITY header
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(it_header)
      ENTITY header BY \_delv
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(it_item1)
      ENTITY header BY \_delv2
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(it_item2).

    DATA(ls_hdr) = it_header[ 1 ].

    result = VALUE #( FOR ls_data IN it_item1
      ( delvnum = ls_data-deliverydocument
        %features-%action-getout = COND #( WHEN ls_data-overallsdprocessstatus <> 'C'
                                             OR ls_hdr-Godate IS NOT INITIAL
                                           THEN if_abap_behv=>fc-o-disabled
                                           ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD getout.

    DATA: lt_hrdcrt TYPE TABLE OF zsd_app02_tb3,
          ls_hrdcrt TYPE zsd_app02_tb3,

          ts TYPE timestamp,
          lv_date TYPE sy-datum,
          lv_time TYPE sy-uzeit.
  READ ENTITIES OF zsd_app06_rv IN LOCAL MODE
    ENTITY header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_header)
    ENTITY header BY \_delv
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_item1)
    ENTITY header BY \_delv2
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_item2).

    READ ENTITIES OF zsd_app06_rv IN LOCAL MODE
      ENTITY header
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_hdrdata).


    GET TIME STAMP FIELD ts.
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

    LOOP AT lt_hdrdata INTO data(ls_hdrdata).

      " Prepare data for update
      CLEAR ls_hrdcrt.
      ls_hrdcrt-uuid         = ls_hdrdata-uuid.
      ls_hrdcrt-tokennum     = ls_hdrdata-tokennum.
      ls_hrdcrt-batch        = ls_hdrdata-batch.
      ls_hrdcrt-division     = ls_hdrdata-division.
      ls_hrdcrt-divmark      = ls_hdrdata-divmark.
      ls_hrdcrt-divname      = ls_hdrdata-divname.
      ls_hrdcrt-drivername   = ls_hdrdata-drivername.
      ls_hrdcrt-gidate       = ls_hdrdata-gidate.
      ls_hrdcrt-gitime       = ls_hdrdata-gitime.
      ls_hrdcrt-godate       = lv_date.
      ls_hrdcrt-gotime       = lv_time.
      ls_hrdcrt-lastchangedat = ls_hdrdata-lastchangedat.
      ls_hrdcrt-lastchangedby = ls_hdrdata-lastchangedby.
      ls_hrdcrt-lrnumber     = ls_hdrdata-lrnumber.
      ls_hrdcrt-createdat    = ls_hdrdata-createdat.
      ls_hrdcrt-createdby    = ls_hdrdata-createdby.
      ls_hrdcrt-mark         = ls_hdrdata-mark.
      ls_hrdcrt-matdesc      = ls_hdrdata-matdesc.
      ls_hrdcrt-material     = ls_hdrdata-material.
      ls_hrdcrt-plant        = ls_hdrdata-plant.
      ls_hrdcrt-plantname    = ls_hdrdata-plantname.
      ls_hrdcrt-sloc         = ls_hdrdata-sloc.
      ls_hrdcrt-status       = ls_hdrdata-status.
      ls_hrdcrt-tarewgt      = ls_hdrdata-tarewgt.
      ls_hrdcrt-trspmode     = ls_hdrdata-trspmode.
      ls_hrdcrt-trspname     = ls_hdrdata-trspname.
      ls_hrdcrt-trucktyp     = ls_hdrdata-trucktyp.
      ls_hrdcrt-trwdate      = ls_hdrdata-trwdate.
      ls_hrdcrt-trwtime      = ls_hdrdata-trwtime.
      ls_hrdcrt-vehicleno    = ls_hdrdata-vehicleno.
      ls_hrdcrt-wgtunit      = ls_hdrdata-wgtunit.

      APPEND ls_hrdcrt TO lt_hrdcrt.



    ENDLOOP.


    zbp_sd_app06_rv=>gt_salesgateout = lt_hrdcrt.

       result = VALUE #( FOR ls_ord IN it_header
                       ( %tky = ls_ord-%tky
                         %param = ls_ord ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zsd_app06_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsd_app06_rv IMPLEMENTATION.

  METHOD save_modified.

    DATA: lt_update TYPE STANDARD TABLE OF zsd_app02_tb3,
          ls_exist  TYPE zsd_app02_tb3,
          ts        TYPE timestamp,
          lv_date   TYPE sy-datum,
          lv_time   TYPE sy-uzeit.

    GET TIME STAMP FIELD ts.
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

    LOOP AT zbp_sd_app06_rv=>gt_salesgateout INTO DATA(ls_data).

      SELECT SINGLE * FROM zsd_app02_tb3
        WHERE tokennum = @ls_data-tokennum INTO @ls_exist.

      IF sy-subrc = 0.
        ls_exist-godate = lv_date.
        ls_exist-gotime = lv_time.
        APPEND ls_exist TO lt_update.
      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY zsd_app02_tb3 FROM TABLE @lt_update.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.

  ENDMETHOD.

ENDCLASS.
