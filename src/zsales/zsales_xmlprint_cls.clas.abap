CLASS zsales_xmlprint_cls DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZSALES_XMLPRINT_CLS IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

  IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
        DATA(lo_error) = 1.
    ENDTRY.
**********************************************************************
    IF NOT line_exists( lt_range[ name = 'SALESDOCUMENT' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.
**********************************************************************
    DATA rt_table TYPE TABLE OF zsales_CusEntity.

**********************************************************************
    LOOP AT lt_range[ name = 'SALESDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).

      DATA(LV_SALES) = <ls_range>-low.

      SELECT SINGLE * FROM ZSALES_HDR WITH PRIVILEGED ACCESS
      WHERE SALESDOCUMENT = @LV_SALES
      INTO @DATA(wa_sales).

*      SELECT SINGLE * FROM zmm_migo_head WITH PRIVILEGED ACCESS
*      WHERE MaterialDocument = @wa_uuid-materialdocument
*      and MaterialDocumentYear = @wa_uuid-materialdocumentyear
*      INTO @DATA(wa_rejc).
*     DATA(wa_postal) = |{ wa_rejc-CityName } { wa_rejc-PostalCode }|.
**********************************************************************
      IF wa_sales IS NOT INITIAL.

        INSERT VALUE zsales_CusEntity(     SalesDocument   = wa_sales-SalesDocument
                                SalesDocumentDate  =   wa_sales-SalesDocumentDate
  SalesDocumentDescription = wa_sales-SalesDocumentDescription
  SoldToParty          = wa_sales-SoldToParty
  DistributionChannel  = wa_sales-DistributionChannel
  CreatedByUser           = wa_sales-CreatedByUser
  CreationDate            = wa_sales-CreationDate
  )

  INTO TABLE rt_table.
        io_response->set_data( rt_table ).
        io_response->set_total_number_of_records( lines( rt_table ) ).

      ENDIF.


    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
