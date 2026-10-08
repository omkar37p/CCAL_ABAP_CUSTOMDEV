CLASS zcl_autoenroll_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AUTOENROLL_QUERY IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA:
      lt_result          TYPE STANDARD TABLE OF zi_autoenroll,
      lt_final           TYPE STANDARD TABLE OF zi_autoenroll,
      ls_result          TYPE zi_autoenroll,
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
        " Read Buffer Data
        "========================================

        IF zcl_autoenroll_buffer=>gt_header IS NOT INITIAL.

          LOOP AT zcl_autoenroll_buffer=>gt_header
            INTO DATA(ls_buffer).

            IF lv_businesspartner IS NOT INITIAL
            AND ls_buffer-businesspartner <>
                lv_businesspartner.
              CONTINUE.
            ENDIF.

            CLEAR ls_result.

            ls_result-businesspartner =
              ls_buffer-businesspartner.

            ls_result-channel =
              ls_buffer-channel.

            ls_result-entity =
              ls_buffer-entity.

            ls_result-businesspartnername =
              ls_buffer-businesspartnername.

            ls_result-businesspartneraddress =
              ls_buffer-businesspartneraddress.

            ls_result-companycode =
              ls_buffer-companycode.

            ls_result-customertoken =
              ls_buffer-customertoken.

            ls_result-overallstatus =
              ls_buffer-overallstatus.

            ls_result-overallmessage =
              ls_buffer-overallmessage.

            APPEND ls_result TO lt_result.

          ENDLOOP.

        ELSE.

          "========================================
          " Dummy Data
          "========================================

          ls_result-businesspartner = '1000001'.
          ls_result-channel = 'CSR'.
          ls_result-entity = 'B'.
          ls_result-businesspartnername = 'CUSTOMER'.
          ls_result-businesspartneraddress = 'BANGALORE'.
          ls_result-companycode = '1000'.
          ls_result-customertoken = 'TOKEN123'.
          ls_result-overallstatus = 'S'.
          ls_result-overallmessage = 'SUCCESS'.

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
