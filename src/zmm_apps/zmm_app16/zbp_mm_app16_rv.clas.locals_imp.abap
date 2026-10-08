CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS statusc FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~statusc RESULT result.

    METHODS getdata1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~getdata1.

    METHODS getdata2 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~getdata2.
    METHODS gateout FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~gateout RESULT result.

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_features.

  READ ENTITIES OF zmm_app16_rv IN LOCAL MODE
  ENTITY _hdr
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_status).
  data(ls_hdr) = lt_status[ 1 ].


  result = VALUE #( FOR ls_key IN keys
  ( %tky =  ls_key-%tky
        %delete = COND #(  WHEN ls_hdr-Mark = 'O' or ls_hdr-Mark is INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
    %update = COND #(  WHEN ls_hdr-Mark = 'O' or ls_hdr-Mark is INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
    %action = VALUE #( Statusc = COND #(  WHEN ls_hdr-Mark = 'O' or  ls_hdr-Mark is INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                       Edit =   COND #(  WHEN ls_hdr-Mark = 'O' or  ls_hdr-Mark is INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                       Gateout =   COND #(  WHEN ls_hdr-Delmark = 'C' and ls_hdr-Gotdat is INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                                    ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD statusc.
  DATA : lt_gphentry TYPE TABLE OF zmm_app12_tb1,
         ls_gphentry TYPE zmm_app12_tb1.
   READ ENTITIES OF zmm_app16_rv IN LOCAL MODE
  ENTITY _hdr
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_header).
  DATA(ls_header)  = lt_header[ 1 ].

  MOVE-CORRESPONDING ls_header to ls_gphentry.
  GET TIME STAMP FIELD DATA(ts).
      CONVERT TIME STAMP ts TIME ZONE 'INDIA'
              INTO DATE DATA(lv_date) TIME DATA(lv_time).
     ls_gphentry-gitdat = lv_date.
     ls_gphentry-gittim = lv_time.
  ls_gphentry-Mark = 'C'.
  ls_gphentry-statustext = 'Security Checked ✅'.

  APPEND ls_gphentry to lt_gphentry.
  zbp_mm_app16_rv=>gt_secdat = lt_gphentry.

    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).



  ENDMETHOD.

  METHOD getdata1.
  DATA : lt_gphentry TYPE TABLE OF zmm_app12_tb1,
           ls_gphentry TYPE zmm_app12_tb1.

  READ ENTITIES OF zmm_app16_rv IN LOCAL MODE
  ENTITY _hdr
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_header).
  DATA(ls_header)  = lt_header[ 1 ].

**********************************************************************
*  IF ls_header-plant IS NOT INITIAL OR ls_header-Vehicleno IS NOT INITIAL.
*      SELECT SINGLE MAX( Gateno ) FROM zmm_app12_tb1 INTO @DATA(lv_gateno).
*      IF sy-subrc = 0 AND lv_gateno IS NOT INITIAL.
*        ls_gphentry-Gateno = lv_gateno + 1.
*
*      ELSE.
*        ls_gphentry-Gateno = '6000000000'.
**        ls_gphentry-gateno =  ls_header-Gateno .
*      ENDIF.
*  ENDIF.
       SELECT * FROM zmm_app12_tb1 WHERE uuid IS NOT INITIAL and mark2 <> 'X'
           AND gptype = @ls_header-gptype and plant = @ls_header-Plant
    INTO TABLE @DATA(lt_gpentry).
    IF lt_gpentry IS INITIAL.
      IF ls_header-gptype = 'RGP'.
        ls_gphentry-gpnum = '8000000000'.
      ELSE.
        ls_gphentry-gpnum = '9000000000'.
      ENDIF.
    ELSE.
      SORT lt_gpentry BY gpnum DESCENDING.
      DATA(ls_gpentry)  = lt_gpentry[ 1 ].
      ls_gphentry-gpnum = ls_gpentry-gpnum + 1.
    ENDIF.

**********************************************************************

    ls_gphentry-uuid = ls_header-uuid.
    ls_gphentry-createdat = ls_header-createdat.
    ls_gphentry-createdby = ls_header-createdby.
    ls_gphentry-curky = ls_header-curky.
    ls_gphentry-dispby = ls_header-dispby.
    ls_gphentry-frghtscope = ls_header-frghtscope.
    ls_gphentry-gptype = ls_header-gptype.
    ls_gphentry-vendnum = ls_header-vendnum.
    ls_gphentry-vendname = ls_header-vendname.
    ls_gphentry-vehicleno = ls_header-vehicleno.
    ls_gphentry-transporter = ls_header-transporter.
    ls_gphentry-rsngp = ls_header-rsngp.
    ls_gphentry-remarks = ls_header-remarks.
    ls_gphentry-plnrtndate = ls_header-plnrtndate.
    ls_gphentry-pcklist = ls_header-pcklist.
    ls_gphentry-plant = ls_header-plant.
    ls_gphentry-plantname = ls_header-plantname.
    ls_gphentry-lastchangedby = ls_header-lastchangedby.
    ls_gphentry-lastchangedat = ls_header-lastchangedat.
    ls_gphentry-issuedby = ls_header-issuedby.
    ls_gphentry-issuedate  = ls_header-issuedate.
    ls_gphentry-zattachment = ls_header-Zattachment.
    ls_gphentry-filename = ls_header-Filename.
    ls_gphentry-minetype = ls_header-Minetype.
    ls_gphentry-ebeln = ls_header-Ebeln.
    ls_gphentry-grosswgt = ls_header-Grosswgt.
    ls_gphentry-netwgt = ls_header-Netwgt.
    ls_gphentry-tarewgt = ls_header-Tarewgt.
    ls_gphentry-insurno = ls_header-Insurno.
    ls_gphentry-Ewabillno = ls_header-Ewabillno.
    ls_gphentry-mark = 'O'.
     GET TIME STAMP FIELD DATA(ts).
      CONVERT TIME STAMP ts TIME ZONE 'INDIA'
              INTO DATE DATA(lv_date) TIME DATA(lv_time).
     ls_gphentry-gitdat = lv_date.
     ls_gphentry-gittim = lv_time.
     APPEND ls_gphentry TO lt_gphentry.
     zbp_mm_app16_rv=>gt_gphdr = lt_gphentry.




  ENDMETHOD.

  METHOD getdata2.
    DATA : lt_gphentry TYPE TABLE OF zmm_app12_tb1,
           ls_gphentry TYPE zmm_app12_tb1.

  READ ENTITIES OF zmm_app16_rv IN LOCAL MODE
  ENTITY _hdr
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_header).
  DATA(ls_header)  = lt_header[ 1 ].

   MOVE-CORRESPONDING ls_header TO ls_gphentry.
   APPEND ls_gphentry TO lt_gphentry.
     zbp_mm_app16_rv=>gt_uphdr = lt_gphentry.

  ENDMETHOD.

  METHOD Gateout.
   DATA : lt_gphentry TYPE TABLE OF zmm_app12_tb1,
         ls_gphentry TYPE zmm_app12_tb1.
   READ ENTITIES OF zmm_app16_rv IN LOCAL MODE
  ENTITY _hdr
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_header).
  DATA(ls_header)  = lt_header[ 1 ].

  MOVE-CORRESPONDING ls_header to ls_gphentry.
  GET TIME STAMP FIELD DATA(ts).
      CONVERT TIME STAMP ts TIME ZONE 'INDIA'
              INTO DATE DATA(lv_date) TIME DATA(lv_time).
     ls_gphentry-gotdat = lv_date.
     ls_gphentry-gottim = lv_time.
      APPEND ls_gphentry to lt_gphentry.

  zbp_mm_app16_rv=>gt_gatot = lt_gphentry.

    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app16_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app16_rv IMPLEMENTATION.

  METHOD save_modified.
  IF create-_hdr IS NOT INITIAL.
      IF zbp_mm_app16_rv=>gt_gphdr IS NOT INITIAL.
        DATA(lt_gpentry) = zbp_mm_app16_rv=>gt_gphdr.
        MODIFY zmm_app12_tb1 FROM TABLE @lt_gpentry.
      ENDIF.
      endif.

      if zbp_mm_app16_rv=>gt_secdat is not INITIAL.
      DATA(lt_gsecdat) = zbp_mm_app16_rv=>gt_secdat.
      MODIFY zmm_app12_tb1 FROM TABLE @lt_gsecdat.
      endif.

     if zbp_mm_app16_rv=>gt_gatot is not INITIAL.
     DATA(lt_gatout) = zbp_mm_app16_rv=>gt_gatot.
      MODIFY zmm_app12_tb1 FROM TABLE @lt_gatout.
     endif.

     IF update-_hdr IS NOT INITIAL.
     IF zbp_mm_app16_rv=>gt_uphdr IS NOT INITIAL.
     DATA(IT_GTUPDT) = zbp_mm_app16_rv=>gt_uphdr.
     MODIFY zmm_app12_tb1 FROM TABLE @IT_GTUPDT.
     ENDIF.
     ENDIF.

          IF delete-_hdr IS NOT INITIAL.
      LOOP AT delete-_hdr INTO DATA(ls_gpentry).
        DELETE FROM zmm_app12_tb2 WHERE uuid = @ls_gpentry-uuid.
        DELETE FROM zmm_app12_tb1 WHERE uuid = @ls_gpentry-uuid.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
