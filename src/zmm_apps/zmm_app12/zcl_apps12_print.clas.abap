CLASS zcl_apps12_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_APPS12_PRINT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
        DATA(lver) = 1.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'UUID' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA rt_table TYPE TABLE OF zmm_app12_ce.


    LOOP AT lt_range[ name = 'UUID' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).

      DATA(lv_uuid) = <ls_range>-low.

      SELECT SINGLE * FROM zmm_app12_chtb WHERE
      uuid = @lv_uuid INTO  @DATA(lt_hdr).

      IF sy-subrc = 0.


          INSERT CORRESPONDING #( lt_hdr )
            INTO TABLE rt_table.


      ENDIF.

      io_response->set_data( rt_table ).
      io_response->set_total_number_of_records( lines( rt_table ) ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
