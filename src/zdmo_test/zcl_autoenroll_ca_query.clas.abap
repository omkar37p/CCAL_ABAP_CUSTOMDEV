CLASS zcl_autoenroll_ca_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AUTOENROLL_CA_QUERY IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

     DATA:
      lt_result TYPE STANDARD TABLE OF zcv_autoenroll,
      lt_final  TYPE STANDARD TABLE OF zcv_autoenroll,
      ls_result TYPE zcv_autoenroll.

    DATA:
      lv_businesspartner TYPE gpart_kk,
      lv_offset          TYPE i,
      lv_page_size       TYPE i,
      lv_from            TYPE i,
      lv_to              TYPE i.

    TRY.

        "========================================
        " Paging Mandatory for RAP
        "========================================

        lv_offset =
          io_request->get_paging( )->get_offset( ).

        lv_page_size =
          io_request->get_paging( )->get_page_size( ).

        "========================================
        " Read Filters
        "========================================

        DATA(lt_filter_cond) =
          io_request->get_filter( )->get_as_ranges( ).

        LOOP AT lt_filter_cond INTO DATA(ls_filter).

          CASE ls_filter-name.

            WHEN 'BUSINESSPARTNER'.

              lv_businesspartner =
                ls_filter-range[ 1 ]-low.

          ENDCASE.

        ENDLOOP.

        "========================================
        " Buffer Data
        "========================================

        IF zcl_autoenroll_buffer=>gt_child IS NOT INITIAL.

          LOOP AT zcl_autoenroll_buffer=>gt_child
            INTO DATA(ls_buffer).

            IF lv_businesspartner IS NOT INITIAL
            AND ls_buffer-businesspartner <>
               lv_businesspartner.
              CONTINUE.
            ENDIF.

            CLEAR ls_result.

            ls_result-contractaccount =
              ls_buffer-contractaccount.

            ls_result-businesspartner =
              ls_buffer-businesspartner.

            ls_result-iseligible =
              ls_buffer-iseligible.

            ls_result-isenrolled =
              ls_buffer-isenrolled.

            ls_result-bankaccountnumber =
              ls_buffer-bankaccountnumber.

            ls_result-bankroutingnumber =
              ls_buffer-bankroutingnumber.

            ls_result-bankaccounttype =
              ls_buffer-bankaccounttype.

            ls_result-eligibilitymsg =
              ls_buffer-eligibilitymsg.

            ls_result-actionstatus =
              ls_buffer-actionstatus.

            ls_result-actionmessage =
              ls_buffer-actionmessage.

            APPEND ls_result TO lt_result.

          ENDLOOP.

        ELSE.

          "========================================
          " Dummy Data
          "========================================

          ls_result-contractaccount = '2000001'.
          ls_result-businesspartner = '1000001'.
          ls_result-iseligible = 'Y'.
          ls_result-isenrolled = 'N'.
          ls_result-bankaccountnumber = '123456789'.
          ls_result-bankroutingnumber = '110000'.
          ls_result-bankaccounttype = 'SAVINGS'.
          ls_result-eligibilitymsg = 'Eligible'.
          ls_result-actionstatus = 'S'.
          ls_result-actionmessage = 'Success'.

          APPEND ls_result TO lt_result.

        ENDIF.

        "========================================
        " Paging Logic
        "========================================

        lv_from = lv_offset + 1.

        IF lv_page_size > 0.
          lv_to = lv_offset + lv_page_size.
        ELSE.
          lv_to = lines( lt_result ).
        ENDIF.

        LOOP AT lt_result INTO ls_result
          FROM lv_from TO lv_to.

          APPEND ls_result TO lt_final.

        ENDLOOP.

        "========================================
        " Response
        "========================================

        io_response->set_total_number_of_records(
          lines( lt_result ) ).

        io_response->set_data( lt_final ).

      CATCH cx_root INTO DATA(lx_root).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
