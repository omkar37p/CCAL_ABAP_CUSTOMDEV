CLASS zsd_app11_print_imp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZSD_APP11_PRINT_IMP IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    if not io_request->is_data_requested(  ).
        RETURN.
    endif.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'BILLINGDOCUMENT' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA rt_table TYPE TABLE OF ZSD_APP11_HEAD_CE.
    DATA: lv_billing TYPE ZSD_APP11_HEAD_CE-BillingDocument.
*    "" ++ 28.07.25 BY SP
    data lvgateno type c length 10 .
    DATA: lv_billno TYPE ZSD_APP11_HEAD_CE-BillingDocument.
*    DATA : lv_grnno1 TYPE i_materialdocumentitemtp-materialdocument.

    LOOP AT lt_range[ name = 'BILLINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).

      DATA(lv_bill) = <ls_range>-low.
      SELECT SINGLE * FROM ZSD_APP11_HEADER
        WHERE BillingDocument = @lv_bill
         INTO @DATA(ls_bill).

        INSERT VALUE ZSD_APP11_HEAD_CE(
                    BillingDocument = ls_bill-BillingDocument
                    BillingDocumentDate = ls_bill-BillingDocumentDate
                    BillingDocumentType = ls_bill-BillingDocumentType
                    CompanyCode = ls_bill-CompanyCode
                    DistributionChannel = ls_bill-DistributionChannel
                    Division = ls_bill-Division
                    attachment = ls_bill-attachment
                    mimetype = ls_bill-mimetype
                    filename = ls_bill-filename )
                    into table rt_table.

    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
