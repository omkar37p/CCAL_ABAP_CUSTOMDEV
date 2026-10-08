CLASS lhc_gpline DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR gpline RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR gpline RESULT result.

ENDCLASS.

CLASS lhc_gpline IMPLEMENTATION.

  METHOD get_instance_features.
   READ ENTITIES OF zmm_app15_rv IN LOCAL MODE
  ENTITY GPline
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_status).
  data(ls_hdr) = lt_status[ 1 ].


  result = VALUE #( FOR ls_key IN lt_status
  ( %tky =  ls_key-%tky
       %action-Edit = COND #(  WHEN ls_key-Quantity - ls_key-Totrcvqty > 0
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_gplsno DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR gplsno RESULT result.

    METHODS crtitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR gplsno~crtitem.
    METHODS upditem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR gplsno~upditem.
    METHODS valirecqty FOR VALIDATE ON SAVE
      IMPORTING keys FOR gplsno~valirecqty.

ENDCLASS.

CLASS lhc_gplsno IMPLEMENTATION.

  METHOD get_instance_features.




  ENDMETHOD.

  METHOD crtitem.
**********************************************************************
    DATA : lt_citem TYPE TABLE OF zmm_app15_tb1,
           ls_citem TYPE zmm_app15_tb1.

**********************************************************************
    READ ENTITIES OF zmm_app15_rv IN LOCAL MODE
     ENTITY gpline
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_header)
     ENTITY gpline BY \_item
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_gplsno).
    DATA(ls_header) = lt_header[ 1 ].
    DATA(ls_gplsno) = lt_gplsno[ 1 ].
**********************************************************************
**********************************************************************
    ls_citem-uuid = ls_header-uuid.
    ls_citem-itemno = ls_header-itemno.

    ls_citem-uom = ls_header-Uom.
    try.
    ls_citem-createdby = cl_abap_context_info=>get_user_description(  ).
    CATCH cx_abap_context_info_error INTO DATA(lv_error).
        DATA(lv_1) = 1.
    ENDTRY.
    GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA'
            INTO DATE DATA(lv_date) TIME DATA(lv_time).
    ls_citem-indt = lv_date.
    ls_citem-intim = lv_time.
    ls_citem-invoice = ls_gplsno-invoice.
    ls_citem-maktx = ls_header-maktx.
    ls_citem-matnr = ls_header-matnr.
    ls_citem-quantity = ls_header-quantity.
    ls_citem-recvqty = ls_gplsno-recvqty.

**********************************************************************
    SELECT SINGLE itemno, MAX( sno ) AS sno FROM zmm_app15_tb1
    WHERE uuid = @ls_header-uuid AND itemno = @ls_header-itemno
    GROUP BY itemno INTO @DATA(ls_itm).
    IF sy-subrc = 0 AND NOT ls_itm IS INITIAL.
      ls_citem-sno = ls_itm-sno + 1.
    ELSE.
      ls_citem-sno = 1.
    ENDIF.

    APPEND ls_citem TO lt_citem.
    zbp_mm_app15_rv=>gt_crtgpls = lt_citem.

  ENDMETHOD.

  METHOD upditem.


*
*
*    DATA: lt_updated_hdr   TYPE TABLE OF zmm_app12_tb2,
*          wa_updated_hdr   TYPE zmm_app12_tb2,
*          lt_item_data     TYPE STANDARD TABLE OF zmm_app15_iv1,
*          lv_pending_qty   TYPE p DECIMALS 3,
*          lv_total_recvqty TYPE p DECIMALS 3.
*
*    " Read header and item data into local tables
*    READ ENTITIES OF zmm_app15_rv IN LOCAL MODE
*      ENTITY gpline
*        ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(rt_hdr_data)  " <-- name changed
*      ENTITY gpline BY \_item
*        ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(rt_item_data). " <-- name changed
*
*    LOOP AT rt_hdr_data INTO DATA(ls_hdr_data).
*
*
*      SELECT SUM( recvqty )
*        FROM zmm_app15_tb1
*        WHERE uuid   = @ls_hdr_data-uuid
*          AND itemno = @ls_hdr_data-itemno
*          INTO @lv_total_recvqty.
*
*      READ TABLE rt_item_data INTO DATA(ls_item_data)
*        WITH KEY uuid = ls_hdr_data-uuid itemno = ls_hdr_data-itemno.
*      IF sy-subrc = 0.
*        lv_total_recvqty = lv_total_recvqty + ls_item_data-recvqty.
*      ENDIF.
*
*      " Calculate pending quantity
*      lv_pending_qty = ls_hdr_data-quantity - lv_total_recvqty.
*
*      wa_updated_hdr-createdat = ls_hdr_data-Createdat.
*       wa_updated_hdr-createdby = ls_hdr_data-Createdby.
*        wa_updated_hdr-curky  = ls_hdr_data-Curky.
*         wa_updated_hdr-hsncode = ls_hdr_data-Hsncode.
*          wa_updated_hdr-itemno = ls_hdr_data-Itemno.
*           wa_updated_hdr-lastchangedat = ls_hdr_data-Lastchangedat.
*            wa_updated_hdr-lastchangedby = ls_hdr_data-Lastchangedby.
*             wa_updated_hdr-maktx = ls_hdr_data-Maktx.
*              wa_updated_hdr-mark = ls_hdr_data-Mark.
*               wa_updated_hdr-matnr = ls_hdr_data-Matnr.
*                wa_updated_hdr-netprice = ls_hdr_data-Netprice.
*                 wa_updated_hdr-quantity = ls_hdr_data-Quantity.
*                  wa_updated_hdr-totopnqty = lv_pending_qty.
*      wa_updated_hdr-totrcvqty = lv_total_recvqty.
*      wa_updated_hdr-totvalue = ls_hdr_data-Totvalue.
*       wa_updated_hdr-uom = ls_hdr_data-Uom.
*        wa_updated_hdr-uuid = ls_hdr_data-Uuid.
*
*        APPEND wa_updated_hdr to lt_updated_hdr.
*
*    ENDLOOP.
*
*    " Assign updated header table to global update table
*    zbp_mm_app15_rv=>gt_updgpl = lt_updated_hdr.

  DATA: lt_updated_hdr   TYPE TABLE OF zmm_app12_tb2,
        wa_updated_hdr   TYPE zmm_app12_tb2,
        lv_pending_qty   TYPE p DECIMALS 3,
        lv_total_recvqty TYPE p DECIMALS 3.

  " Read header and item data into local tables
  READ ENTITIES OF zmm_app15_rv IN LOCAL MODE
    ENTITY gpline
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(rt_hdr_data)
    ENTITY gpline BY \_item
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(rt_item_data).

  LOOP AT rt_hdr_data INTO DATA(ls_hdr_data).

    CLEAR: lv_total_recvqty.

    " Sum recvqty from all item lines that match this header
    LOOP AT rt_item_data INTO DATA(ls_item_data)
      WHERE uuid = ls_hdr_data-uuid AND itemno = ls_hdr_data-itemno.
      lv_total_recvqty = lv_total_recvqty + ls_item_data-recvqty.
    ENDLOOP.

    " Calculate pending quantity
    lv_pending_qty = ls_hdr_data-quantity - lv_total_recvqty.

    " Update the header structure
    MOVE-CORRESPONDING ls_hdr_data TO wa_updated_hdr.
    wa_updated_hdr-totrcvqty = lv_total_recvqty.
    wa_updated_hdr-totopnqty = lv_pending_qty.

    APPEND wa_updated_hdr TO lt_updated_hdr.

  ENDLOOP.

  zbp_mm_app15_rv=>gt_updgpl = lt_updated_hdr.




  ENDMETHOD.


  METHOD ValiRecqty.
  DATA:   lv_pending_qty   TYPE p DECIMALS 3,
          lv_total_recvqty TYPE p DECIMALS 3.
     READ ENTITIES OF zmm_app15_rv IN LOCAL MODE
      ENTITY gpline
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(rt_hdr_data)
      ENTITY gpline BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(rt_item_data).
        DATA(ls_item_data) = rt_item_data[ 1 ].
        DATA(ls_hdr_data) = rt_hdr_data[ 1 ].
  SELECT SUM( recvqty )
        FROM zmm_app15_tb1
        WHERE uuid   = @ls_hdr_data-uuid
          AND itemno = @ls_hdr_data-itemno
          INTO @lv_total_recvqty.

           IF lv_total_recvqty IS INITIAL.
          lv_total_recvqty = 0.
          ENDIF.
          lv_total_recvqty = lv_total_recvqty + ls_item_data-recvqty.
          lv_pending_qty = ls_hdr_data-quantity - lv_total_recvqty.

            IF ls_item_data-recvqty > ( ls_hdr_data-quantity - ( lv_total_recvqty - ls_item_data-recvqty ) )..
           APPEND VALUE #( %tky = ls_item_data-%tky ) to failed-gplsno.

           APPEND value #( %tky = keys[ 1 ]-%tky
           %msg = new_message_with_text(
           severity = if_abap_behv_message=>severity-error
           text = 'Entered quantity exceeds pending quantity'
            )
            ) to reported-gplsno.

           ENDIF.





  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app15_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app15_rv IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-gplsno IS NOT INITIAL.
      IF zbp_mm_app15_rv=>gt_crtgpls IS NOT INITIAL.
        DATA(lt_gplsno) = zbp_mm_app15_rv=>gt_crtgpls.
        MODIFY zmm_app15_tb1 FROM TABLE @lt_gplsno.
      ENDIF.
    ENDIF.
**********************************************************************
 if zbp_mm_app15_rv=>gt_updgpl is not INITIAL.
 data(lt_gplitm) = zbp_mm_app15_rv=>gt_updgpl.
 MODIFY zmm_app12_tb2 from table @lt_gplitm.
 ENDIF.
**************************************************************************
  IF DELETE-gplsno IS NOT INITIAL.
    LOOP AT delete-gplsno INTO DATA(ls_gipentry).
    DELETE FROM zmm_app15_tb1 WHERE uuid = @ls_gipentry-Uuid AND itemno = @ls_gipentry-Itemno and sno = @ls_gipentry-Sno .
    ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
