CLASS zmm_print_item_cls DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMM_PRINT_ITEM_CLS IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
**********************************************************************
    if not io_request->is_data_requested(  ).
        RETURN.
    endif.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
      data(lo_error) = 1.
    ENDTRY.
**********************************************************************
    IF NOT line_exists( lt_range[ name = 'UUID' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.
**********************************************************************

    DATA rt_item type table of ZMM_FORM_ITEM_CE.
**********************************************************************
    LOOP AT lt_range[ name = 'UUID' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
    data(lv_inuuid) = <ls_range>-low.

    SELECT single Uuid, Materialdocument from zmm_app20_head_rv wiTH PRIVILEGED ACCESS
    where Uuid = @lv_inuuid
    into @data(ls_head).

**********************************************************************
    select * from ZMM_ITEM_PRINT WITH PRIVILEGED ACCESS
    where Uuid = @ls_head-Uuid
    into table @data(lt_item).

    if lt_item is not INITIAL.
        sort lt_item ASCENDING BY Materialdocumentitem.
              loop at lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).
              if <ls_item> is ASSIGNED.
              INSERT VALUE ZMM_FORM_ITEM_CE( uuid = <ls_item>-Uuid
                                        Materialdocument = <ls_item>-Materialdocument
                                        Materialdocumentitem = <ls_item>-Materialdocumentitem
                                        Materialdocumentyear = <ls_item>-Materialdocumentyear
                                        Plant = <ls_item>-Plant
                                        Companycode = <ls_item>-Companycode
                                        Companycodecurrency = <ls_item>-Companycodecurrency
                                        Material = <ls_item>-Material
                                        Productdescription = <ls_item>-Productdescription
                                        Materialbaseunit = <ls_item>-Materialbaseunit
                                        Migoqty = <ls_item>-Migoqty
                                        Poqty = <ls_item>-Poqty
                                        Invoiceqty = <ls_item>-Invoiceqty
                                        Receivedqty = <ls_item>-Receivedqty
                                        Acceptedqty = <ls_item>-Acceptedqty
                                        Rejectedqty = <ls_item>-Rejectedqty )
                                        into table rt_item.

              endif.
              endloop.
            io_response->set_data( rt_item ).
            io_response->set_total_number_of_records( lines( rt_item ) ).
    endif.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
