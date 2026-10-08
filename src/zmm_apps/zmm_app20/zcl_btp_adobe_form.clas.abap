CLASS zcl_btp_adobe_form DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    class-METHODS get_ouath_token
        IMPORTING
            im_oauth_url TYPE string
            im_client_id TYPE string
            im_clientsecret TYPE string
        EXPORTING
            ex_token TYPE string
            ex_message type string.

    CLASS-METHODS get_pdf_api
        IMPORTING
            im_url TYPE string
            im_url_path type string
            im_client_id type string
            im_clientsecret type string
            im_token type string
            im_base64_encode type string OPTIONAL
            im_xdp_template type string OPTIONAL
        EXPORTING
            ex_base64_decode TYPE xstring
            ex_message type string.

  PROTECTED SECTION.

        CLASS-DATA: gv_clientid type string,
                    gv_clientsecret type string.

        CLASS-METHODS get_default_values
            IMPORTING
                im_client_id type string OPTIONAL
                im_clientsecret type string OPTIONAL
                im_ouath_url type string OPTIONAL
                im_url type string OPTIONAL
            EXPORTING
                ex_client_id type string
                ex_clientsecret type string
                ex_ouath_url type string
                ex_url type string.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTP_ADOBE_FORM IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.


  METHOD get_default_values.

    SELECT parameters, value
    FROM zbtp_adobe_db
    where parameters is not INITIAL
    INTO TABLE @DATA(it_default_values).

    IF it_default_values[] IS NOT INITIAL.

      ex_client_id = VALUE #( it_default_values[ parameters = im_client_id ]-value OPTIONAL )  .
      ex_clientsecret = VALUE #( it_default_values[ parameters = im_clientsecret ]-value OPTIONAL ) .
      ex_url = VALUE #( it_default_values[ parameters = im_url ]-value OPTIONAL )  .
      ex_ouath_url = VALUE #( it_default_values[ parameters = im_ouath_url ]-value OPTIONAL )  .

    ENDIF.
  ENDMETHOD.


  METHOD get_ouath_token.

**********************************************************************
    TYPES: BEGIN OF lty_token_data,
             access_token TYPE string,
           END OF lty_token_data.

    DATA: lv_ouath_url   TYPE string,
          lwa_token_data TYPE lty_token_data.

    CLEAR: gv_clientid,gv_clientsecret,lv_ouath_url.

**********************************************************************
        get_default_values(
          EXPORTING
            im_client_id    = im_client_id
            im_clientsecret = im_clientsecret
            im_ouath_url    = im_oauth_url
*            im_url          =
          IMPORTING
            ex_client_id    = gv_clientid
            ex_clientsecret = gv_clientsecret
            ex_ouath_url    = lv_ouath_url
*            ex_url          =
        ).
**********************************************************************
        if ( lv_ouath_url is initial or gv_clientid is INITIAL or gv_clientsecret is INITIAL ).

            ex_message = 'Maintain Service Key in default table'.
        ELSE.
**********************************************************************
      TRY.
          DATA(lo_http_destin) =
            cl_http_destination_provider=>create_by_url(
            i_url = lv_ouath_url ).

          DATA(lo_web_http_clnt) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_http_destin ).
          DATA(lo_web_req) = lo_web_http_clnt->get_http_request( ).
          lo_web_req->set_header_fields( VALUE #( ( name = 'Content-Type' value = 'application/json' )
                                                  ( name = 'Accept'       value = 'application/json' ) ) ).

          lo_web_req->set_authorization_basic(
            EXPORTING
              i_username = gv_clientid
              i_password = gv_clientsecret
          ).
**********************************************************************
          DATA(lo_web_http_response1) = lo_web_http_clnt->execute( if_web_http_client=>post ).
          DATA(lv_response1) = lo_web_http_response1->get_text( ).

          /ui2/cl_json=>deserialize( EXPORTING json = lv_response1
                                     CHANGING  data = lwa_token_data
                                             ).
          ex_token = lwa_token_data-access_token.
**********************************************************************
          IF lwa_token_data-access_token IS INITIAL.
            ex_message = 'Error in Token generation'.
          ENDIF.

        CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.
          ex_message = 'Error in Token generation'.
      ENDTRY.
    ENDIF.

    CLEAR: gv_clientid,gv_clientsecret,lv_ouath_url.
**********************************************************************

  ENDMETHOD.


  METHOD get_pdf_api.

**********************************************************************

    TYPES: BEGIN OF ty_body,
             change_not_allowed TYPE string,
             embed_font         TYPE i,
             form_locale        TYPE string,
             form_type          TYPE string,
             print_not_allowed  TYPE string,
             tagged_pdf         TYPE i,
             xdp_template       TYPE string,
             xml_data           TYPE string,
           END OF ty_body.

    TYPES: BEGIN OF ty_response,
             filename    TYPE string,
             filecontent TYPE string,
             tracestring TYPE string,
           END OF ty_response.


    DATA: lv_url       TYPE string,
          lv_url_path  TYPE string,
          lv_token     TYPE string,
          lwa_body     TYPE ty_body,
          lwa_response TYPE ty_response.

    CLEAR: gv_clientid,gv_clientsecret,lv_url, lv_token,lv_url_path.

**********************************************************************
        get_default_values(
          EXPORTING
            im_client_id    = im_client_id
            im_clientsecret = im_clientsecret
*            im_ouath_url    = im_oauth_url
            im_url          = im_url
          IMPORTING
            ex_client_id    = gv_clientid
            ex_clientsecret = gv_clientsecret
*            ex_ouath_url    =
            ex_url          = lv_url

        ).

**********************************************************************
        if ( lv_url is INITIAL or gv_clientid is initial or gv_clientsecret is initial ).

            ex_message = 'Maintain Service Key in default table'.
            ELSE.

      lv_token = im_token.

      IF lv_token IS INITIAL.
        ex_message = 'Oauth 2.0 token is blank'.
      ELSE.

        TRY.

            DATA(lo_http_destination) =   cl_http_destination_provider=>create_by_url( i_url = lv_url ).
            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_http_destination ).
            DATA(lo_request) = lo_http_client->get_http_request( ).

            lo_request->set_authorization_basic(
              EXPORTING
                i_username = gv_clientid
                i_password = gv_clientsecret ).


            lo_request->set_header_fields( VALUE #(
                           ( name = 'Accept'       value = 'application/json' )
                           ( name = 'Content-Type' value = 'application/json' )
            ) ).


            lo_request->set_authorization_bearer(
              EXPORTING
                i_bearer = lv_token ).

            DATA(lv_base64_encode) = im_base64_encode.

            lwa_body = VALUE #( change_not_allowed = 'false'
                                embed_font         = 0
                                form_locale        = 'en_US'
                                form_type          = 'print'
                                print_not_allowed  = 'false'
                                tagged_pdf         = 1
                                xdp_template       = im_xdp_template
                                xml_data           = lv_base64_encode
                              ).

            DATA(lv_json) = /ui2/cl_json=>serialize(
              data        = lwa_body
              compress    = abap_true
              pretty_name = /ui2/cl_json=>pretty_mode-camel_case
            ).

            lo_request->set_text(
              EXPORTING
                i_text = lv_json ).

            lv_url_path = im_url_path.

            lo_request->set_uri_path(
              EXPORTING
                i_uri_path = lv_url_path ).

            DATA(http_response_2) = lo_http_client->execute(
              i_method = if_web_http_client=>post
            ).

            http_response_2->get_text(
              RECEIVING
                r_value = DATA(lv_value) ).

            DATA(http_status_code)   = http_response_2->get_status( ).

            CLEAR: lwa_response.

            /ui2/cl_json=>deserialize(
              EXPORTING
                json        = lv_value
                pretty_name = /ui2/cl_json=>pretty_mode-camel_case
              CHANGING
                data        = lwa_response
            ).

            ex_base64_decode = cl_web_http_utility=>decode_x_base64( encoded = lwa_response-filecontent ).

          CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.
          data(lv_error) = 1.

        ENDTRY.

      ENDIF.

        ENDIF.
  ENDMETHOD.
ENDCLASS.
