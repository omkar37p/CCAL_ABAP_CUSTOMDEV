CLASS lhc__citem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS crtcitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR _citem~crtcitem.
    METHODS upcitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR _citem~upcitem.
    METHODS recvqt FOR VALIDATE ON SAVE
      IMPORTING keys FOR _citem~recvqt.
    METHODS recpen FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _citem~recpen.

ENDCLASS.

CLASS lhc__citem IMPLEMENTATION.

  METHOD crtcitem.
    DATA : lt_citem TYPE TABLE OF zmm_app14_tb1,
           ls_citem TYPE zmm_app14_tb1.
    READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    ENTITY _item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item)
    ENTITY _citem
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_citem).

    DATA(ls_item) = lt_item[ 1 ].
    DATA(ls_header) = lt_header[ 1 ].
    DATA(wa_citem) = it_citem[ 1 ].
**********************************************************************
    SELECT SINGLE itemno, MAX( itemo ) as itemo FROM zmm_app14_tb1 WHERE uuid = @wa_citem-uuid and itemno = @wa_citem-Itemno GROUP BY itemno INTO @DATA(ls_itm).
    IF sy-subrc = 0 AND NOT ls_itm IS INITIAL.
      ls_citem-itemo = ls_itm + 10.
    ELSE.
      ls_citem-itemo = 10.
    ENDIF.

**********************************************************************
    ls_citem-itemno = ls_item-Itemno.
    ls_citem-itemn = wa_citem-Itemn.
*    ls_citem-itemo = wa_citem-Itemo.
    ls_citem-uuid = wa_citem-uuid.
    ls_citem-createdat = wa_citem-createdat.
    ls_citem-createdby = wa_citem-createdby.
    GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA'
            INTO DATE DATA(lv_date) TIME DATA(lv_time).
    ls_citem-indt = lv_date.
    ls_citem-intim = lv_time.
    ls_citem-invoice = wa_citem-invoice.
    ls_citem-maktx = ls_item-maktx.
    ls_citem-matnr = ls_item-matnr.

    ls_citem-quantity = ls_item-quantity.
    ls_citem-recvqty = wa_citem-recvqty.
   SELECT SUM( recvqty )
  FROM zmm_app14_tb1
  WHERE uuid = @ls_item-uuid AND itemno = @ls_item-itemno
  INTO @DATA(lv_total_recvqty).

IF sy-subrc <> 0 OR lv_total_recvqty IS INITIAL.
  lv_total_recvqty = 0.
ENDIF.

ls_citem-penqty = ls_item-quantity - lv_total_recvqty.
    ls_citem-uom = ls_item-uom.
**********************************************************************

    APPEND ls_citem TO lt_citem.
    zbp_mm_app14_rv=>gt_gpcitm = lt_citem.


  ENDMETHOD.

  METHOD upcitem.

  data : it_cupdate type table of zmm_app14_tb1,
          wa_cupdate type zmm_app14_tb1.
    READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    ENTITY _item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item)
    ENTITY _citem
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_citem).

    DATA(ls_item) = lt_item[ 1 ].
    DATA(ls_header) = lt_header[ 1 ].
    "DATA(wa_citem) = it_citem[ 1 ].
    loop at it_citem into data(wa_citem).
     wa_cupdate-itemn = wa_citem-Itemn.
      wa_cupdate-itemo = wa_citem-Itemo.
      wa_cupdate-itemno = ls_item-Itemno.
      wa_cupdate-uuid = wa_citem-uuid.
    wa_cupdate-createdat = wa_citem-createdat.
    wa_cupdate-createdby = wa_citem-createdby.
    GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA'
            INTO DATE DATA(lv_date) TIME DATA(lv_time).
    wa_cupdate-indt = lv_date.
    wa_cupdate-intim = lv_time.
    wa_cupdate-invoice = wa_citem-invoice.
    wa_cupdate-maktx = ls_item-maktx.
    wa_cupdate-matnr = ls_item-matnr.

    wa_cupdate-quantity = ls_item-quantity.
    wa_cupdate-recvqty = wa_citem-recvqty.
    wa_cupdate-penqty = wa_cupdate-quantity - wa_cupdate-recvqty.
    wa_cupdate-uom = ls_item-uom.
    APPEND wa_cupdate TO it_cupdate.
    ENDLOOP.

    zbp_mm_app14_rv=>gt_upcitm = it_cupdate.




  ENDMETHOD.

  METHOD recvqt.""Validataion
  READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
  ENTITY _CItem
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(IT_CITEM)
  ENTITY _item
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT data(lt_item).
  data(lsitem) = lt_item[ 1 ].

  loop at it_citem into data(wa_citem).
  if   wa_citem-Recvqty > lsitem-Quantity.
  APPEND value #( %tky = wa_citem-%tky ) to failed-_citem.
  append value #( %tky = keys[ 1 ]-%tky
  %msg = new_message_with_text(
  severity = if_abap_behv_message=>severity-error
  text = 'quantity is more then issued quanity '
  )
   ) to reported-_citem.

  ENDIF.

  ENDLOOP.


  ENDMETHOD.

  METHOD recpen.
  READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
  ENTITY _item
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT data(lt_item)
  ENTITY _item by \_itmch
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT data(lt_citem).
  data(ls_item) = lt_item[ 1 ].
  DATA lv_pendqty TYPE p LENGTH 7 DECIMALS 3.

  loop at lt_citem into data(ls_citem).
  select SINGLE sum( recvqty ) from zmm_app14_tb1 where uuid  = @ls_item-Uuid and  itemno  = @ls_item-Itemno into @data(ls_amt) .
  MODIFY ENTITIES OF zmm_app14_rv IN LOCAL MODE
  ENTITY _item
  UPDATE FIELDS ( Recvqty ) WITH VALUE #( ( %tky = ls_citem-%tky  Recvqty = ls_amt ) ).

  lv_pendqty  = ls_item-Quantity - ls_amt.

  MODIFY ENTITIES OF zmm_app14_rv IN LOCAL MODE
  ENTITY _item
  UPDATE FIELDS ( Penqty ) WITH VALUE #( ( %tky = ls_citem-%tky   Penqty = lv_pendqty ) ).

  ENDLOOP.


  ENDMETHOD.

ENDCLASS.

CLASS lhc__item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS crtitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~crtitem.

    METHODS upditm FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~upditm.

ENDCLASS.

CLASS lhc__item IMPLEMENTATION.

  METHOD crtitem.
    DATA : lt_gpientry TYPE TABLE OF zmm_app14_itb1,
           ls_gpientry TYPE zmm_app14_itb1.
    READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    ENTITY _item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

    DATA(ls_header) = lt_header[ 1 ].
    DATA(ls_item) =  lt_item[ 1 ].
**********************************************************************
    SELECT SINGLE MAX( itemno ) FROM zmm_app14_itb1
             WHERE uuid = @ls_item-uuid
             INTO @DATA(ls_sno).
**********************************************************************
    IF sy-subrc = 0 AND NOT ls_sno IS INITIAL.
      ls_gpientry-itemno = ls_sno + 1.
    ELSE.
      ls_gpientry-itemno = 10.
    ENDIF.
    ls_gpientry-createdat = ls_item-createdat.
    ls_gpientry-createdby = ls_item-createdby.
    ls_gpientry-curky = ls_item-curky.
    ls_gpientry-hsncode = ls_item-hsncode.
    ls_gpientry-lastchangedat = ls_item-lastchangedat.
    ls_gpientry-lastchangedby = ls_item-lastchangedby.
    ls_gpientry-uuid = ls_item-uuid.
    ls_gpientry-uom = ls_item-uom.
    ls_gpientry-totvalue = ls_item-quantity * ls_item-netprice.
    ls_gpientry-quantity = ls_item-quantity.
    ls_gpientry-netprice = ls_item-netprice.
    ls_gpientry-matnr = ls_item-matnr.
    ls_gpientry-maktx = ls_item-maktx.
**********************************************************************
    IF ls_item-matnr IS NOT INITIAL.
      SELECT SINGLE p~product AS matnr, p~baseunit AS uom, d~productdescription AS maktx,v~inventoryvaluationprocedure AS ivp
      ,CAST( v~standardprice AS CURR( 13,2 ) )  AS stdamt , v~movingaverageprice AS map,
       CAST( b~consumptiontaxctrlcode AS CHAR( 30 ) )  AS hsn
        FROM i_product WITH PRIVILEGED ACCESS AS p
      INNER JOIN i_productdescription_2 WITH PRIVILEGED ACCESS AS d
      ON d~product = p~product AND d~language = 'E'
      INNER JOIN i_productvaluationbasic WITH PRIVILEGED ACCESS AS v  "for standard price of material
      ON v~product = p~product AND v~valuationarea = @ls_header-plant
      INNER JOIN i_productplantbasic WITH PRIVILEGED ACCESS AS b " For hsn code
      ON b~product = p~product AND b~plant = @ls_header-plant
      WHERE p~product = @ls_item-matnr  INTO @DATA(ls_mat).
      ls_gpientry-maktx = ls_mat-maktx.
      ls_gpientry-uom = ls_mat-uom.
      ls_gpientry-hsncode = ls_mat-hsn.
      IF ls_mat-ivp = 'S'.
        ls_gpientry-netprice = ls_mat-stdamt.
      ELSE.
        ls_gpientry-netprice = ls_mat-map.
      ENDIF.
      ls_gpientry-totvalue = ls_item-quantity * ls_gpientry-netprice.
    ENDIF.
**********************************************************************
    APPEND ls_gpientry TO lt_gpientry.
    zbp_mm_app14_rv=>gt_gpitm = lt_gpientry.
  ENDMETHOD.

  METHOD upditm.
    DATA : it_update TYPE TABLE OF zmm_app14_itb1,
           wa_update TYPE zmm_app14_itb1.

    READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    ENTITY _item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

    DATA(ls_item) = lt_item[ 1 ].
    DATA(ls_header) = lt_header[ 1 ].

    wa_update-createdat = ls_item-createdat.
    wa_update-createdby = ls_item-createdby.
    wa_update-curky = ls_item-curky.
    wa_update-hsncode = ls_item-hsncode.
    wa_update-lastchangedat = ls_item-lastchangedat.
    wa_update-lastchangedby = ls_item-lastchangedby.
    wa_update-uuid = ls_item-uuid.
    wa_update-itemno = ls_item-itemno.
    wa_update-uom = ls_item-uom.
    wa_update-totvalue = ls_item-quantity * ls_item-netprice.
    wa_update-quantity = ls_item-quantity.
    wa_update-netprice = ls_item-netprice.
    wa_update-matnr = ls_item-matnr.
    wa_update-maktx = ls_item-maktx.
**********************************************************************
    IF ls_item-matnr IS NOT INITIAL.
      SELECT SINGLE p~product AS matnr, p~baseunit AS uom, d~productdescription AS maktx,v~inventoryvaluationprocedure AS ivp
      ,CAST( v~standardprice AS CURR( 13,2 ) )  AS stdamt , v~movingaverageprice AS map, CAST( b~consumptiontaxctrlcode AS CHAR( 30 ) )  AS hsn  FROM i_product WITH PRIVILEGED ACCESS AS p
      INNER JOIN i_productdescription_2 WITH PRIVILEGED ACCESS AS d
      ON d~product = p~product AND d~language = 'E'
      INNER JOIN i_productvaluationbasic WITH PRIVILEGED ACCESS AS v  "for standard price of material
      ON v~product = p~product AND v~valuationarea = @ls_header-plant
      INNER JOIN i_productplantbasic WITH PRIVILEGED ACCESS AS b " For hsn code
      ON b~product = p~product AND b~plant = @ls_header-plant
      WHERE p~product = @ls_item-matnr  INTO @DATA(ls_mat).
      wa_update-maktx = ls_mat-maktx.
      wa_update-uom = ls_mat-uom.
      wa_update-hsncode = ls_mat-hsn.
      IF ls_mat-ivp = 'S'.
        wa_update-netprice = ls_mat-stdamt.
      ELSE.
        wa_update-netprice = ls_mat-map.
      ENDIF.
      wa_update-totvalue = ls_item-quantity * wa_update-netprice.
    ENDIF.
**********************************************************************
    APPEND wa_update TO it_update.
    zbp_mm_app14_rv=>gt_upitm = it_update.

  ENDMETHOD.

ENDCLASS.

CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.
    METHODS getdata1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~getdata1.

    METHODS updhdr FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~updhdr.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _hdr RESULT result.

    METHODS issueout FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~issueout RESULT result.

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getdata1.
    DATA : lt_gphentry TYPE TABLE OF zmm_app14_htb1,
           ls_gphentry TYPE zmm_app14_htb1.
**********************************************************************
    READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).
    DATA(ls_header)  = lt_header[ 1 ].

**********************************************************************
    IF  ls_header-plant IS NOT INITIAL .
      SELECT SINGLE MAX( gpnum ) FROM zmm_app14_htb1 INTO @DATA(ls_gnum).
      IF sy-subrc = 0 AND ls_gnum IS NOT INITIAL.
        ls_gphentry-gpnum = ls_gnum + 1.
      ELSE.
        ls_gphentry-gpnum = '9000000000'.
      ENDIF.
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
**********************************************************************
    APPEND ls_gphentry TO lt_gphentry.
    zbp_mm_app14_rv=>gt_gphdr = lt_gphentry.
  ENDMETHOD.

  METHOD updhdr.
    DATA : lt_uphdr TYPE TABLE OF zmm_app14_htb1,
           ls_uphrd TYPE zmm_app14_htb1.

    READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr).

    LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<ls_hdr>).
      MOVE-CORRESPONDING <ls_hdr> TO ls_uphrd.
      APPEND ls_uphrd TO lt_uphdr.


    ENDLOOP.
    zbp_mm_app14_rv=>gt_uphdr = lt_uphdr.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD issueout.
  DATA: lv_system_date TYPE d.
lv_system_date = cl_abap_context_info=>get_system_date( ).
READ ENTITIES OF zmm_app14_rv IN LOCAL MODE
ENTITY  _hdr
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT FINAL(lt_data)
ENTITY _hdr by \_itm
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT FINAL(lt_item).
DATA(lt_items) = lt_item[].
    SORT lt_items BY Itemno ASCENDING.

    DATA(ls_data1) = lt_data[ 1 ].
    zbp_mm_app14_rv=>gv_gpnum = ls_data1-Gpnum.
 DATA : lv_xml TYPE string.
*    REPLACE ALL OCCURRENCES OF '&' IN ls_data1-Costname WITH 'and'.
**********************************************************************
lv_xml = |<?xml version="1.0" encoding="UTF-8"?>| &&
               |<form1>| &&
               |<Mainpage>| &&
               |<Header>| &&
               |<Plant>| && ls_data1-Plant && |</Plant>| &&
               |<Dispatch>| && ls_data1-Dispby && |</Dispatch>| &&
               |<Issuedby>| && ls_data1-Issuedby && |</Issuedby>| &&
               |<Docno>| && ls_data1-Gpnum && |</Docno>| &&
               |<Vehno>| && ls_data1-Vehicleno && |</Vehno>| &&
               |<Remark>| && ls_data1-Remarks && |</Remark>| &&
               |</Header>| .

DATA(lv_counter) = 1.
LOOP AT lt_items INTO DATA(ls_item).
  lv_xml = lv_xml &&
           |<Item>| &&
           |<Table1>| &&
           |<HeaderRow/>| &&
           |<body>| &&
           |<Sno>| && lv_counter && |</Sno>| &&
           |<Material>| && ls_item-Matnr && |</Material>| &&
           |<Materialdec>| && ls_item-Maktx && |</Materialdec>| &&
           |<Hsn>| && ls_item-Hsncode && |</Hsn>| &&
           |<Uom>| && ls_item-Uom && |</Uom>| &&
           |<Quantity>| && ls_item-Quantity && |</Quantity>| &&
           |<Itemval>| && ls_item-Netprice && |</Itemval>| &&
           |<Totvalue>| && ls_item-Totvalue && |</Totvalue>| &&
           |<Rc>| && ls_item-Recvqty && |</Rc>| &&
           |<Pe>| && ls_item-Penqty && |</Pe>| &&
           |</body>| &&
           |</Table1>| &&
           |</Item>|.

  lv_counter += 1.
ENDLOOP.

lv_xml = lv_xml &&

         |</Mainpage>| &&
         |</form1>|.
**********************************************************************

zbp_mm_app14_rv=>gs_xmldata = lv_xml.

 DATA: ls_data     TYPE ztestt_s_binding,
          ls_req      TYPE zmm_s_body,
          ls_response TYPE zmm_rp_body.
           TRY.

        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
        comm_scenario = 'ZADS_CS'
        comm_system_id = 'ZADS'
        service_id = 'ZADS_OUT_REST'

        ).
           CATCH cx_http_dest_provider_error INTO DATA(lx_error).
    ENDTRY.
    TRY.

        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

      CATCH cx_web_http_client_error INTO DATA(lx_client_error).
     ENDTRY.
    DATA(lo_request) = lo_client->get_http_request(  ).
    lo_request->set_header_fields( VALUE #(
    ( name = 'Accept' value = 'application/json, text/plain, */*' )
    ( name = 'Content-Type' value = 'application/json;charset=utf-8' )
     ) ).
DATA(lv_base64_data) = cl_web_http_utility=>encode_base64( unencoded = zbp_mm_app14_rv=>gs_xmldata ).
ls_req-xdp_template = 'ZRGPF/RGPF'.
*    ls_req-xdp_template = 'ZINDENT/Test'.
    ls_req-xml_data     = lv_base64_data.
    ls_req-form_type    = 'print'.
    ls_req-form_locale  = 'en_US'.
    ls_req-tagged_pdf = 1.
    ls_req-embed_font = 0.
    ls_req-change_not_allowed = abap_false.
    ls_req-print_not_allowed = abap_false.

       TRY.
        CALL METHOD /ui2/cl_json=>serialize
          EXPORTING
            data        = ls_req
            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
          RECEIVING
            r_json      = DATA(lv_body).

      CATCH cx_root INTO DATA(lx_root).
    ENDTRY.
    lo_request->set_text(
    EXPORTING
    i_text = lv_body ).

     TRY.

        DATA(lo_response) = lo_client->execute(
        i_method = if_web_http_client=>post
        i_timeout = 0  ).

      CATCH cx_web_http_client_error INTO lx_client_error.
    ENDTRY.
    DATA(lv_response) = lo_response->get_text(  ).
    DATA(ls_status) = lo_response->get_status(  ).

    TRY.
        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json          = lv_response
            assoc_arrays  = abap_true
            name_mappings = VALUE #( ( json = 'filecontent' abap = 'FILECONTENT' ) )
          CHANGING
            data          = ls_response.
      CATCH cx_root INTO lx_root.

    ENDTRY.

        DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_response-filecontent  ).
    DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).

    zbp_mm_app14_rv=>gv_print_data = lv_print_data.
    zbp_mm_app14_rv=>gv_qitem_id = lv_qitem_id.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app14_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app14_rv IMPLEMENTATION.

  METHOD save_modified.
*******************************CREATE******************************************************
********************************header**************************************
    IF create-_hdr IS NOT INITIAL.
      IF zbp_mm_app14_rv=>gt_gphdr IS NOT INITIAL.
        DATA(lt_gpentry) = zbp_mm_app14_rv=>gt_gphdr.
        MODIFY zmm_app14_htb1 FROM TABLE @lt_gpentry.
      ENDIF.
    ENDIF.
**********************************************************************

********************************item**************************************
    IF create-_item IS NOT INITIAL.
      IF zbp_mm_app14_rv=>gt_gpitm IS NOT INITIAL.
        DATA(lt_gpitmentry) = zbp_mm_app14_rv=>gt_gpitm.
        MODIFY zmm_app14_itb1 FROM TABLE @lt_gpitmentry.
      ENDIF.
    ENDIF.
**********************************************************************
    IF create-_citem IS NOT INITIAL.
      IF zbp_mm_app14_rv=>gt_gpcitm IS NOT INITIAL.
        DATA(lt_gpcitmentry) = zbp_mm_app14_rv=>gt_gpcitm.
        MODIFY zmm_app14_tb1 FROM TABLE @lt_gpcitmentry.
      ENDIF.
    ENDIF.



**********************************************************************

********************************************************************************************

*******************************UPDATE***************************************
    IF update-_hdr IS NOT INITIAL.
      IF zbp_mm_app14_rv=>gt_uphdr IS NOT INITIAL.
        DATA(it_uphdr) = zbp_mm_app14_rv=>gt_uphdr.
        MODIFY zmm_app14_htb1 FROM TABLE @it_uphdr.
      ENDIF.
    ENDIF.
**********************************************************************
    IF update-_item IS NOT INITIAL.
      IF zbp_mm_app14_rv=>gt_upitm IS NOT INITIAL.
        DATA(it_upitm) = zbp_mm_app14_rv=>gt_gpitm.
        MODIFY zmm_app14_itb1 FROM TABLE @it_upitm.
      ENDIF.
    ENDIF.
**********************************************************************

IF update-_citem IS NOT INITIAL.
IF zbp_mm_app14_rv=>gt_upcitm IS NOT INITIAL.
data(it_upcitm) = zbp_mm_app14_rv=>gt_upcitm.
MODIFY zmm_app14_tb1 from table @it_upcitm.
endif.
ENDIF.

**********************************************************************

********************************Delete**************************************
    IF delete-_hdr IS NOT INITIAL.
      LOOP AT delete-_hdr INTO DATA(ls_gpentry).
        DELETE FROM zmm_app14_htb1 WHERE uuid = @ls_gpentry-uuid.
        DELETE FROM zmm_app14_itb1 WHERE uuid = @ls_gpentry-uuid.
      ENDLOOP.
    ENDIF.
**********************************************************************
    IF delete-_item IS NOT INITIAL.
      LOOP AT delete-_item INTO DATA(ls_gipentry).
        DELETE FROM zmm_app14_itb1 WHERE uuid = @ls_gipentry-uuid AND itemno = @ls_gipentry-itemno.
      ENDLOOP.
    ENDIF.


**********************************************************************
       IF zbp_mm_app14_rv=>gv_print_data IS NOT INITIAL.
      DATA(lv_print_data) = zbp_mm_app14_rv=>gv_print_data.
      DATA(lv_qitem_id) = zbp_mm_app14_rv=>gv_qitem_id.
      DATA(lv_docno) = zbp_mm_app14_rv=>gv_gpnum.

        cl_print_queue_utils=>create_queue_item_by_data(
          EXPORTING
            iv_qname            = 'ZPRINT'
            iv_print_data       =  lv_print_data
            iv_name_of_main_doc = 'RGB' && lv_docno
            iv_itemid           = lv_qitem_id
*            iv_pages            =
*            iv_number_of_copies =
*            it_attachment_data  =
          IMPORTING
            ev_err_msg          = DATA(gs_error_msg)
*          RECEIVING
*            rv_itemid           =
        ).

    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
