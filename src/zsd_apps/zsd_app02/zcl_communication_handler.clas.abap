CLASS zcl_communication_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    """ HTTP Communication via URL   """
    METHODS :
      send_request_by_url
        IMPORTING url                TYPE string
        RETURNING VALUE(lo_response) TYPE REF TO if_web_http_response
        RAISING   cx_web_http_client_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COMMUNICATION_HANDLER IMPLEMENTATION.


  METHOD send_request_by_url.
    """ HTTP Communication via URL   """

    DATA: lo_http_destination TYPE REF TO if_http_destination,
          lo_http_client      TYPE REF TO if_web_http_client,
          lv_response         TYPE string.
**********************************************************************
    TRY.





      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error).
        RAISE EXCEPTION TYPE cx_web_http_client_error.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
