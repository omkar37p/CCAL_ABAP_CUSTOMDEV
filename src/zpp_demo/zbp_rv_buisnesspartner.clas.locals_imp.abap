CLASS lhc_zrv_buisnesspartner DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validate_business_partner
      IMPORTING
        iv_bp           TYPE c
      RETURNING
        VALUE(rv_valid) TYPE abap_bool.

    METHODS get_main_bp_from_altbp
      IMPORTING
        iv_altbp     TYPE c
      RETURNING
        VALUE(rv_bp) TYPE string.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrv_buisnesspartner RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zrv_buisnesspartner.

    METHODS read FOR READ
      IMPORTING keys FOR READ zrv_buisnesspartner RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zrv_buisnesspartner.

    METHODS rba_child FOR READ
      IMPORTING keys_rba FOR READ zrv_buisnesspartner\_child FULL result_requested RESULT result LINK association_links.

    METHODS cba_child FOR MODIFY
      IMPORTING entities_cba FOR CREATE zrv_buisnesspartner\_child.

    METHODS validatebp FOR MODIFY
      IMPORTING keys FOR ACTION zrv_buisnesspartner~validatebp RESULT result.

    METHODS fetcheligibility FOR MODIFY
      IMPORTING keys FOR ACTION zrv_buisnesspartner~fetcheligibility RESULT result.





ENDCLASS.

CLASS lhc_zrv_buisnesspartner IMPLEMENTATION.

  METHOD validate_business_partner.

    SELECT SINGLE businesspartner
      FROM i_businesspartner
      WHERE businesspartner = @iv_bp
      INTO @DATA(lv_bp).

    rv_valid = xsdbool( sy-subrc = 0 ).

  ENDMETHOD.

  METHOD get_main_bp_from_altbp.

*--------------------------------------------------------------------
* PUBLIC CLOUD VERSION
* USING CUSTOM TABLE ZBP_REL
*--------------------------------------------------------------------

    SELECT SINGLE bp_main
      FROM zbp_rel
      WHERE bp_alt = @iv_altbp
      INTO @rv_bp.

*--------------------------------------------------------------------
* CLIENT PRIVATE CLOUD VERSION
*--------------------------------------------------------------------

* SELECT SINGLE partner1
*   FROM but050
*   WHERE partner2 = @iv_altbp
*   INTO @rv_bp.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_child.
  ENDMETHOD.

  METHOD cba_child.
  ENDMETHOD.

  METHOD validatebp.

    DATA:
      lv_bp      TYPE c LENGTH 10,
      lv_altbp   TYPE c LENGTH 10,
      lv_bp_name TYPE string.

    LOOP AT keys INTO DATA(ls_key).

*--------------------------------------------------------------------
* READ INPUT
*--------------------------------------------------------------------

      lv_bp    = ls_key-%key-businesspartner.
      lv_altbp = ls_key-%param-alternatebusinesspartner.

*--------------------------------------------------------------------
* BOTH EMPTY
*--------------------------------------------------------------------

      IF lv_bp IS INITIAL
      AND lv_altbp IS INITIAL.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Enter Business Partner or Alternate Business Partner'
                 )
        ) TO reported-zrv_buisnesspartner.

        CONTINUE.

      ENDIF.

*--------------------------------------------------------------------
* BOTH ENTERED
*--------------------------------------------------------------------

      IF lv_bp IS NOT INITIAL
      AND lv_altbp IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Enter either BP or Alternate BP, not both'
                 )
        ) TO reported-zrv_buisnesspartner.

        CONTINUE.

      ENDIF.

*--------------------------------------------------------------------
* ALT BP -> MAIN BP
*--------------------------------------------------------------------

      IF lv_bp IS INITIAL
      AND lv_altbp IS NOT INITIAL.

        lv_bp = get_main_bp_from_altbp( lv_altbp ).

        IF lv_bp IS INITIAL.

          APPEND VALUE #(
            %tky = ls_key-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = 'Alternate BP not found'
                   )
          ) TO reported-zrv_buisnesspartner.

          CONTINUE.

        ENDIF.

      ENDIF.

*--------------------------------------------------------------------
* VALIDATE BUSINESS PARTNER
*--------------------------------------------------------------------

      IF NOT validate_business_partner( lv_bp ).

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Business Partner is invalid'
                 )
        ) TO reported-zrv_buisnesspartner.

        CONTINUE.

      ENDIF.

*--------------------------------------------------------------------
* READ BP NAME
*--------------------------------------------------------------------

      SELECT SINGLE businesspartnerfullname
        FROM i_businesspartner
        WHERE businesspartner = @lv_bp
        INTO @lv_bp_name.

*--------------------------------------------------------------------
* SUCCESS MESSAGE
*--------------------------------------------------------------------

      APPEND VALUE #(
        %tky = ls_key-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-success
                 text     = 'Business Partner validated successfully'
               )
      ) TO reported-zrv_buisnesspartner.

*--------------------------------------------------------------------
* SUCCESS RESULT
*--------------------------------------------------------------------

      APPEND VALUE #(
    %tky = ls_key-%tky

    %param = VALUE #(
      businesspartner          = lv_bp
      alternatebusinesspartner = lv_altbp
      businesspartnername      = lv_bp_name
      apisource                = 'RAP'
      paymentchannel           = 'A'
    )

  ) TO result.

    ENDLOOP.
  ENDMETHOD.

******************************************************************************

*  METHOD validatebp.
*
*    DATA:
*      lv_bp    TYPE string,
*      lv_altbp TYPE string.
*
*    LOOP AT keys INTO DATA(ls_key).
*
**--------------------------------------------------------------------
** READ INPUT
**--------------------------------------------------------------------
*
*      lv_bp    = ls_key-%key-businesspartner.
*      lv_altbp = ls_key-%param-alternatebusinesspartner.
*
**--------------------------------------------------------------------
** BOTH EMPTY
**--------------------------------------------------------------------
*
*      IF lv_bp IS INITIAL
*      AND lv_altbp IS INITIAL.
*
*        APPEND VALUE #(
*          %tky = ls_key-%tky
*          %msg = new_message_with_text(
*
*                   severity = if_abap_behv_message=>severity-error
*                   text     = 'Enter Business Partner or Alternate Business Partner'
*
*                 )
*        ) TO reported-zrv_buisnesspartner.
*
*        CONTINUE.
*
*      ENDIF.
*
**--------------------------------------------------------------------
** BOTH ENTERED
**--------------------------------------------------------------------
*
*      IF lv_bp IS NOT INITIAL
*      AND lv_altbp IS NOT INITIAL.
*
*        APPEND VALUE #(
*          %tky = ls_key-%tky
*          %msg = new_message_with_text(
*
*                   severity = if_abap_behv_message=>severity-error
*                   text     = 'Enter either BP or Alternate BP, not both'
*
*                 )
*        ) TO reported-zrv_buisnesspartner.
*
*        CONTINUE.
*
*      ENDIF.
*
**--------------------------------------------------------------------
** ALT BP -> MAIN BP
**--------------------------------------------------------------------
*
*      IF lv_bp IS INITIAL
*      AND lv_altbp IS NOT INITIAL.
*
*        lv_bp = get_main_bp_from_altbp( lv_altbp ).
*
**--------------------------------------------------------------------
** ALT BP NOT FOUND
**--------------------------------------------------------------------
*
*        IF lv_bp IS INITIAL.
*
*          APPEND VALUE #(
*            %tky = ls_key-%tky
*            %msg = new_message_with_text(
*
*                     severity = if_abap_behv_message=>severity-error
*                     text     = 'Alternate BP not found'
*
*                   )
*          ) TO reported-zrv_buisnesspartner.
*
*          CONTINUE.
*
*        ENDIF.
*
*      ENDIF.
*
**--------------------------------------------------------------------
** VALIDATE BUSINESS PARTNER
**--------------------------------------------------------------------
*
*      IF NOT validate_business_partner( lv_bp ).
*
*        APPEND VALUE #(
*          %tky = ls_key-%tky
*          %msg = new_message_with_text(
*
*                   severity = if_abap_behv_message=>severity-error
*                   text     = 'Business Partner is invalid'
*
*                 )
*        ) TO reported-zrv_buisnesspartner.
*
*        CONTINUE.
*
*      ENDIF.
*
**--------------------------------------------------------------------
** SUCCESS MESSAGE
**--------------------------------------------------------------------
*      APPEND VALUE #(
*           %tky = ls_key-%tky
*           %msg = new_message_with_text(
*
*                    severity = if_abap_behv_message=>severity-success
*                    text     = 'Business Partner validated successfully'
*
*                  )
*         ) TO reported-zrv_buisnesspartner.
*
**--------------------------------------------------------------------
** SUCCESS RESULT
**--------------------------------------------------------------------
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*      ) TO result.
*
*    ENDLOOP.
*
*  ENDMETHOD.

****************************************************************************

*METHOD fetcheligibility.
*
**--------------------------------------------------------------------
** PUBLIC CLOUD VERSION
**--------------------------------------------------------------------
**
** TABLES USED:
**
** ZBP_REL
**   BP_MAIN
**   BP_ALT
**
** ZTABLE2
**   PARTNER
**   CONTRACT_ACCOUNT
**   CUST_TOKEN
**   PAYMENT_TOKEN
**   BANK_ACCOUNT
**   ROUTING_NUMBER
**   ACCOUNT_TYPE
**   IS_ELIGIBLE
**   HAS_ENROLLED
**   PROCESS_STATUS
**   PROCESS_MSG
**
**--------------------------------------------------------------------
*
*  DATA:
*    lv_bp           TYPE c LENGTH 10,
*    lv_altbp        TYPE c LENGTH 10,
*    lv_identifier   TYPE c LENGTH 1,
*    lv_input_ca     TYPE vkont_kk,
*    lv_bp_name      TYPE string.
*
*  DATA:
*    lt_token TYPE TABLE OF ztable2,
*    ls_token TYPE ztable2.
*
*  LOOP AT keys INTO DATA(ls_key).
*
**--------------------------------------------------------------------
** READ INPUT
**--------------------------------------------------------------------
*
*    lv_bp         = ls_key-%key-businesspartner.
*    lv_altbp      = ls_key-%param-alternatebusinesspartner.
*    lv_identifier = ls_key-%param-contractaccountidentifier.
*    lv_input_ca   = ls_key-%param-contractaccount.
*
**--------------------------------------------------------------------
** CHECK INPUT
**--------------------------------------------------------------------
*
*    IF lv_bp IS INITIAL
*    AND lv_altbp IS INITIAL.
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text     = 'Enter BP or Alternate BP'
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*      CONTINUE.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** BOTH ENTERED
**--------------------------------------------------------------------
*
*    IF lv_bp IS NOT INITIAL
*    AND lv_altbp IS NOT INITIAL.
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text     = 'Enter either BP or Alternate BP'
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*      CONTINUE.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** ALT BP -> MAIN BP
**--------------------------------------------------------------------
*
*    IF lv_bp IS INITIAL
*    AND lv_altbp IS NOT INITIAL.
*
*      SELECT SINGLE bp_main
*        FROM zbp_rel
*        WHERE bp_alt = @lv_altbp
*        INTO @lv_bp.
*
**--------------------------------------------------------------------
** PRIVATE CLOUD CLIENT VERSION
**--------------------------------------------------------------------
*
**     SELECT SINGLE partner1
**       FROM but050
**       WHERE partner2 = @lv_altbp
**       INTO @lv_bp.
*
*      IF sy-subrc <> 0.
*
*        APPEND VALUE #(
*          %tky = ls_key-%tky
*          %msg = new_message_with_text(
*                   severity = if_abap_behv_message=>severity-error
*                   text     = 'Alternate BP not found'
*                 )
*        ) TO reported-zrv_buisnesspartner.
*
*        CONTINUE.
*
*      ENDIF.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** VALIDATE BUSINESS PARTNER
**--------------------------------------------------------------------
*
*    IF NOT validate_business_partner( lv_bp ).
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text     = 'Invalid Business Partner'
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*      CONTINUE.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** READ BP NAME
**--------------------------------------------------------------------
*
*    SELECT SINGLE businesspartnerfullname
*      FROM i_businesspartner
*      WHERE businesspartner = @lv_bp
*      INTO @lv_bp_name.
*
**--------------------------------------------------------------------
** IDENTIFIER = A
**--------------------------------------------------------------------
*
*    IF lv_identifier = 'A'.
*
*      SELECT *
*        FROM ztable2
*        WHERE partner = @lv_bp
*        INTO TABLE @lt_token.
*
**--------------------------------------------------------------------
** PRIVATE CLOUD CLIENT VERSION
**--------------------------------------------------------------------
*
**     SELECT vkont AS contract_account
**       FROM fkkvkp
**       WHERE gpart = @lv_bp
**       INTO CORRESPONDING FIELDS OF TABLE @lt_token.
*
**--------------------------------------------------------------------
** IDENTIFIER = S
**--------------------------------------------------------------------
*
*    ELSEIF lv_identifier = 'S'.
*
*      IF lv_input_ca IS INITIAL.
*
*        APPEND VALUE #(
*          %tky = ls_key-%tky
*          %msg = new_message_with_text(
*                   severity = if_abap_behv_message=>severity-error
*                   text     = 'Enter Contract Account'
*                 )
*        ) TO reported-zrv_buisnesspartner.
*
*        CONTINUE.
*
*      ENDIF.
*
*      SELECT *
*        FROM ztable2
*        WHERE partner          = @lv_bp
*          AND contract_account = @lv_input_ca
*        INTO TABLE @lt_token.
*
**--------------------------------------------------------------------
** PRIVATE CLOUD CLIENT VERSION
**--------------------------------------------------------------------
*
**     SELECT vkont AS contract_account
**       FROM fkkvkp
**       WHERE gpart = @lv_bp
**         AND vkont = @lv_input_ca
**       INTO CORRESPONDING FIELDS OF TABLE @lt_token.
*
**--------------------------------------------------------------------
** INVALID IDENTIFIER
**--------------------------------------------------------------------
*
*    ELSE.
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text     = 'Invalid Contract Account Identifier'
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*      CONTINUE.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** NO CONTRACT ACCOUNT FOUND
**--------------------------------------------------------------------
*
*    IF lt_token IS INITIAL.
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text     = 'No Contract Accounts found'
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*      CONTINUE.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** RESULT HEADER (ONLY KEY FIELDS)
**--------------------------------------------------------------------
*
*    APPEND VALUE #(
*      %tky              = ls_key-%tky
*      BusinessPartner   = lv_bp
*    ) TO result.
*
**--------------------------------------------------------------------
** CHILD DATA RESPONSE
**--------------------------------------------------------------------
*
*    LOOP AT lt_token INTO ls_token.
*
**--------------------------------------------------------------------
** HARDCODE TEST DATA
**--------------------------------------------------------------------
*
**     ls_token-is_eligible    = 'Y'.
**     ls_token-has_enrolled   = 'N'.
**     ls_token-process_status = 'S'.
**     ls_token-process_msg    = 'Success'.
*
**------------------------------------------------------------
** CHILD RESULT (CORRECT WAY)
**------------------------------------------------------------
*    LOOP AT lt_token INTO ls_token.
*
*      APPEND VALUE #(
*        %tky = VALUE #(
*          businesspartner = lv_bp
*          contractaccount  = ls_token-contract_account
*        )
*
*        %assoc-_child = VALUE #(
*          businesspartner = lv_bp
*          contractaccount  = ls_token-contract_account
*        )
*
*        iseligible      = ls_token-is_eligible
*        hasenrolled     = ls_token-has_enrolled
*        bankaccountnumber = ls_token-bank_account
*        bankroutingnumber = ls_token-routing_number
*        bankaccounttype   = ls_token-account_type
*        paymenttoken      = ls_token-payment_token
*
*      ) TO result.
*
*    ENDLOOP.
*
**--------------------------------------------------------------------
** SUCCESS MESSAGE
**--------------------------------------------------------------------
*
*    APPEND VALUE #(
*      %tky = ls_key-%tky
*      %msg = new_message_with_text(
*               severity = if_abap_behv_message=>severity-success
*               text     = 'Eligibility fetched successfully'
*             )
*    ) TO reported-zrv_buisnesspartner.
*
*  ENDLOOP.
*
*
*ENDMETHOD.

****************************************************************************

*METHOD fetcheligibility.
*
*  DATA:
*    lv_bp         TYPE c LENGTH 10,
*    lv_altbp      TYPE c LENGTH 10,
*    lv_identifier TYPE c LENGTH 1,
*    lv_input_ca   TYPE vkont_kk.
*
**--------------------------------------------------------------------
** PUBLIC CLOUD
**--------------------------------------------------------------------
*  DATA:
*    lt_ca TYPE TABLE OF i_contractaccountpartner,
*    ls_ca TYPE i_contractaccountpartner.
*
**--------------------------------------------------------------------
** WORK VARIABLES
**--------------------------------------------------------------------
*  DATA:
*    lv_eligible TYPE c LENGTH 1,
*    lv_enrolled TYPE c LENGTH 1,
*    lv_msg      TYPE string,
*    lv_status   TYPE c LENGTH 1.
*
*  LOOP AT keys INTO DATA(ls_key).
*
**--------------------------------------------------------------------
** INPUT
**--------------------------------------------------------------------
*
*    CLEAR:
*      lv_bp,
*      lv_altbp,
*      lv_identifier,
*      lv_input_ca.
*
*    lv_bp         = ls_key-%key-businesspartner.
*    lv_altbp      = ls_key-%param-alternatebusinesspartner.
*    lv_identifier = ls_key-%param-contractaccountidentifier.
*    lv_input_ca   = ls_key-%param-contractaccount.
*
**--------------------------------------------------------------------
** ALT BP -> MAIN BP
**--------------------------------------------------------------------
*
*    IF lv_bp IS INITIAL
*    AND lv_altbp IS NOT INITIAL.
*
**--------------------------------------------------------------------
** PUBLIC CLOUD
**--------------------------------------------------------------------
*
*      SELECT SINGLE bp_main
*        FROM zbp_rel
*        WHERE bp_alt = @lv_altbp
*        INTO @lv_bp.
*
**--------------------------------------------------------------------
** PRIVATE CLOUD
**--------------------------------------------------------------------
*
**     SELECT SINGLE partner1
**       FROM but050
**       WHERE partner2 = @lv_altbp
**       INTO @lv_bp.
*
*      IF sy-subrc <> 0.
*
*        APPEND VALUE #(
*          %tky = ls_key-%tky
*          %msg = new_message_with_text(
*                   severity = if_abap_behv_message=>severity-error
*                   text     = 'Alternate BP not found'
*                 )
*        ) TO reported-zrv_buisnesspartner.
*
*        CONTINUE.
*
*      ENDIF.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** VALIDATE BP
**--------------------------------------------------------------------
*
*    SELECT SINGLE businesspartner
*      FROM i_businesspartner
*      WHERE businesspartner = @lv_bp
*      INTO @DATA(lv_check_bp).
*
*    IF sy-subrc <> 0.
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text     = 'Invalid Business Partner'
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*      CONTINUE.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** FETCH CONTRACT ACCOUNT
**--------------------------------------------------------------------
*
*    CLEAR lt_ca.
*
*    IF lv_identifier = 'A'.
*
*      SELECT *
*        FROM i_contractaccountpartner
*        WHERE businesspartner = @lv_bp
*        INTO TABLE @lt_ca.
*
**--------------------------------------------------------------------
** PRIVATE CLOUD
**--------------------------------------------------------------------
*
**     SELECT *
**       FROM fkkvkp
**       WHERE gpart = @lv_bp
**       INTO TABLE @lt_ca.
*
*    ELSEIF lv_identifier = 'S'.
*
*      SELECT *
*        FROM i_contractaccountpartner
*        WHERE businesspartner = @lv_bp
*          AND contractaccount = @lv_input_ca
*        INTO TABLE @lt_ca.
*
**--------------------------------------------------------------------
** PRIVATE CLOUD
**--------------------------------------------------------------------
*
**     SELECT *
**       FROM fkkvkp
**       WHERE gpart = @lv_bp
**         AND vkont = @lv_input_ca
**       INTO TABLE @lt_ca.
*
*    ELSE.
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text     = 'Invalid Contract Account Identifier'
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*      CONTINUE.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** NO CONTRACT ACCOUNT
**--------------------------------------------------------------------
*
*    IF lt_ca IS INITIAL.
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text     = 'No Contract Account Found'
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*      CONTINUE.
*
*    ENDIF.
*
**--------------------------------------------------------------------
** LOOP CONTRACT ACCOUNT
**--------------------------------------------------------------------
*
*    LOOP AT lt_ca INTO ls_ca.
*
*      CLEAR:
*        lv_eligible,
*        lv_enrolled,
*        lv_msg,
*        lv_status.
*
**--------------------------------------------------------------------
** HARDCODE ELIGIBILITY
**--------------------------------------------------------------------
*
*      IF ls_ca-contractaccount+11(1) CO '02468'.
*
*        lv_eligible = 'Y'.
*
*      ELSE.
*
*        lv_eligible = 'N'.
*
*      ENDIF.
*
**--------------------------------------------------------------------
** HARDCODE ENROLLMENT
**--------------------------------------------------------------------
*
*      IF ls_ca-contractaccount+10(1) CO '13579'.
*
*        lv_enrolled = 'Y'.
*
*      ELSE.
*
*        lv_enrolled = 'N'.
*
*      ENDIF.
*
**--------------------------------------------------------------------
** MESSAGE LOGIC
**--------------------------------------------------------------------
*
*      IF lv_eligible = 'Y'
*      AND lv_enrolled = 'Y'.
*
*        lv_msg    = |CA { ls_ca-contractaccount } : Eligible and Enrolled|.
*        lv_status = 'S'.
*
*      ELSEIF lv_eligible = 'Y'
*      AND lv_enrolled = 'N'.
*
*        lv_msg    = |CA { ls_ca-contractaccount } : Eligible but Not Enrolled|.
*        lv_status = 'E'.
*
*      ELSEIF lv_eligible = 'N'
*      AND lv_enrolled = 'N'.
*
*        lv_msg    = |CA { ls_ca-contractaccount } : Not Eligible and Not Enrolled|.
*        lv_status = 'E'.
*
*      ELSE.
*
*        lv_msg    = |CA { ls_ca-contractaccount } : Invalid Enrollment State|.
*        lv_status = 'E'.
*
*      ENDIF.
*
**--------------------------------------------------------------------
** SAVE INTO ZTABLE2
**--------------------------------------------------------------------
*
*UPDATE ztable2
*   SET is_eligible    = @lv_eligible,
*       has_enrolled   = @lv_enrolled,
*       process_status = @lv_status,
*       process_msg    = @lv_msg
* WHERE partner          = @lv_bp
*   AND contract_account = @ls_ca-contractaccount.
*
**DATA ls_update TYPE ztable2.
**
**CLEAR ls_update.
**
**ls_update-mandt            = sy-mandt.
**ls_update-partner          = lv_bp.
**ls_update-contract_account = ls_ca-contractaccount.
**
**ls_update-is_eligible    = lv_eligible.
**ls_update-has_enrolled   = lv_enrolled.
**ls_update-process_status = lv_status.
**ls_update-process_msg    = lv_msg.
**
**MODIFY ztable2 FROM ls_update.
*
**--------------------------------------------------------------------
** SUCCESS / ERROR MESSAGE
**--------------------------------------------------------------------
*
*      APPEND VALUE #(
*        %tky = ls_key-%tky
*        %msg = new_message_with_text(
*
*                 severity = COND #(
*                   WHEN lv_status = 'S'
*                   THEN if_abap_behv_message=>severity-success
*                   ELSE if_abap_behv_message=>severity-error
*                 )
*
*                 text = lv_msg
*               )
*      ) TO reported-zrv_buisnesspartner.
*
*    ENDLOOP.
*
**--------------------------------------------------------------------
** ROOT RESULT ONLY
**--------------------------------------------------------------------
*
*    APPEND VALUE #(
*
*      %tky = ls_key-%tky
*
*      %param = VALUE #(
*
*        businesspartner          = lv_bp
*        alternatebusinesspartner = lv_altbp
*        contractaccountidentifier = lv_identifier
*
*      )
*
*    ) TO result.
*
*  ENDLOOP.
*
*ENDMETHOD.


******************************************************************************

  METHOD fetcheligibility.

*--------------------------------------------------------------------
* PURPOSE
*--------------------------------------------------------------------
* 1. Validate BP / Alternate BP
* 2. Fetch Contract Accounts
* 3. Determine Eligibility / Enrollment
* 4. Future logic place for:
*      - Enroll
*      - Unenroll
*      - Update Token
* 5. Store response in ZTABLE2
* 6. Return ROOT entity only
* 7. Child data comes from CHILD READ method
*--------------------------------------------------------------------

    DATA:
      lv_bp         TYPE c LENGTH 10,
      lv_altbp      TYPE c LENGTH 10,
      lv_identifier TYPE c LENGTH 1,
      lv_input_ca   TYPE vkont_kk.

*--------------------------------------------------------------------
* PUBLIC CLOUD
*--------------------------------------------------------------------

    DATA:
      lt_ca TYPE TABLE OF i_contractaccountpartner,
      ls_ca TYPE i_contractaccountpartner.

*--------------------------------------------------------------------
* PRIVATE CLOUD CLIENT
*--------------------------------------------------------------------

* DATA:
*   lt_ca TYPE TABLE OF fkkvkp,
*   ls_ca TYPE fkkvkp.

*--------------------------------------------------------------------
* UPDATE STRUCTURE
*--------------------------------------------------------------------

    DATA:
      ls_update TYPE ztable2.

*--------------------------------------------------------------------
* LOOP
*--------------------------------------------------------------------

    LOOP AT keys INTO DATA(ls_key).

*--------------------------------------------------------------------
* INPUT
*--------------------------------------------------------------------

      CLEAR:
        lv_bp,
        lv_altbp,
        lv_identifier,
        lv_input_ca.

      lv_bp         = ls_key-%key-businesspartner.
      lv_altbp      = ls_key-%param-alternatebusinesspartner.
      lv_identifier = ls_key-%param-contractaccountidentifier.
      lv_input_ca   = ls_key-%param-contractaccount.

*--------------------------------------------------------------------
* VALIDATE INPUT
*--------------------------------------------------------------------

      IF lv_bp IS INITIAL
      AND lv_altbp IS INITIAL.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Enter Business Partner or Alternate BP'
                 )
        ) TO reported-zrv_buisnesspartner.

        CONTINUE.

      ENDIF.

*--------------------------------------------------------------------
* BOTH ENTERED
*--------------------------------------------------------------------

      IF lv_bp IS NOT INITIAL
      AND lv_altbp IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Enter either BP or Alternate BP'
                 )
        ) TO reported-zrv_buisnesspartner.

        CONTINUE.

      ENDIF.

*--------------------------------------------------------------------
* ALT BP -> MAIN BP
*--------------------------------------------------------------------

      IF lv_bp IS INITIAL
      AND lv_altbp IS NOT INITIAL.

*--------------------------------------------------------------------
* PUBLIC CLOUD
*--------------------------------------------------------------------

        SELECT SINGLE bp_main
          FROM zbp_rel
          WHERE bp_alt = @lv_altbp
          INTO @lv_bp.

*--------------------------------------------------------------------
* PRIVATE CLOUD CLIENT
*--------------------------------------------------------------------

*     SELECT SINGLE partner1
*       FROM but050
*       WHERE partner2 = @lv_altbp
*       INTO @lv_bp.

        IF sy-subrc <> 0.

          APPEND VALUE #(
            %tky = ls_key-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = 'Alternate BP not found'
                   )
          ) TO reported-zrv_buisnesspartner.

          CONTINUE.

        ENDIF.

      ENDIF.

*--------------------------------------------------------------------
* VALIDATE BUSINESS PARTNER
*--------------------------------------------------------------------

      SELECT SINGLE businesspartner
        FROM i_businesspartner
        WHERE businesspartner = @lv_bp
        INTO @DATA(lv_bp_check).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Invalid Business Partner'
                 )
        ) TO reported-zrv_buisnesspartner.

        CONTINUE.

      ENDIF.

*--------------------------------------------------------------------
* FETCH CONTRACT ACCOUNT
*--------------------------------------------------------------------

      CLEAR lt_ca.

*--------------------------------------------------------------------
* ALL CONTRACT ACCOUNT
*--------------------------------------------------------------------

      IF lv_identifier = 'A'.

*--------------------------------------------------------------------
* PUBLIC CLOUD
*--------------------------------------------------------------------

        SELECT *
          FROM i_contractaccountpartner
          WHERE businesspartner = @lv_bp
          INTO TABLE @lt_ca.

*--------------------------------------------------------------------
* PRIVATE CLOUD CLIENT
*--------------------------------------------------------------------

*     SELECT *
*       FROM fkkvkp
*       WHERE gpart = @lv_bp
*       INTO TABLE @lt_ca.

*--------------------------------------------------------------------
* SINGLE CONTRACT ACCOUNT
*--------------------------------------------------------------------

      ELSEIF lv_identifier = 'S'.

        IF lv_input_ca IS INITIAL.

          APPEND VALUE #(
            %tky = ls_key-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = 'Enter Contract Account'
                   )
          ) TO reported-zrv_buisnesspartner.

          CONTINUE.

        ENDIF.

*--------------------------------------------------------------------
* PUBLIC CLOUD
*--------------------------------------------------------------------

        SELECT *
          FROM i_contractaccountpartner
          WHERE businesspartner = @lv_bp
            AND contractaccount = @lv_input_ca
          INTO TABLE @lt_ca.

*--------------------------------------------------------------------
* PRIVATE CLOUD CLIENT
*--------------------------------------------------------------------

*     SELECT *
*       FROM fkkvkp
*       WHERE gpart = @lv_bp
*         AND vkont = @lv_input_ca
*       INTO TABLE @lt_ca.

*--------------------------------------------------------------------
* INVALID IDENTIFIER
*--------------------------------------------------------------------

      ELSE.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Invalid Contract Account Identifier'
                 )
        ) TO reported-zrv_buisnesspartner.

        CONTINUE.

      ENDIF.

*--------------------------------------------------------------------
* NO CONTRACT ACCOUNT FOUND
*--------------------------------------------------------------------

      IF lt_ca IS INITIAL.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'No Contract Account Found'
                 )
        ) TO reported-zrv_buisnesspartner.

        CONTINUE.

      ENDIF.

*--------------------------------------------------------------------
* PROCESS EACH CONTRACT ACCOUNT
*--------------------------------------------------------------------

      LOOP AT lt_ca INTO ls_ca.

*--------------------------------------------------------------------
* LOCAL VARIABLES
*--------------------------------------------------------------------

        DATA:
          lv_eligible TYPE c LENGTH 1,
          lv_enrolled TYPE c LENGTH 1,
          lv_status   TYPE c LENGTH 1,
          lv_msg      TYPE string.

*--------------------------------------------------------------------
* HARDCODE ELIGIBILITY LOGIC
*--------------------------------------------------------------------

        IF ls_ca-contractaccount+11(1) CO '02468'.

          lv_eligible = 'Y'.

        ELSE.

          lv_eligible = 'N'.

        ENDIF.

*--------------------------------------------------------------------
* HARDCODE ENROLLMENT LOGIC
*--------------------------------------------------------------------

        IF ls_ca-contractaccount+10(1) CO '13579'.

          lv_enrolled = 'Y'.

        ELSE.

          lv_enrolled = 'N'.

        ENDIF.

*--------------------------------------------------------------------
* MESSAGE LOGIC
*--------------------------------------------------------------------

        IF lv_eligible = 'Y'
        AND lv_enrolled = 'Y'.

          lv_status = 'S'.
          lv_msg    = 'Eligible and Enrolled'.

        ELSEIF lv_eligible = 'Y'
        AND lv_enrolled = 'N'.

          lv_status = 'E'.
          lv_msg    = 'Eligible but Not Enrolled'.

        ELSEIF lv_eligible = 'N'
        AND lv_enrolled = 'N'.

          lv_status = 'E'.
          lv_msg    = 'Not Eligible and Not Enrolled'.

        ELSE.

          lv_status = 'E'.
          lv_msg    = 'Invalid Enrollment State'.

        ENDIF.

*--------------------------------------------------------------------
* FUTURE ENROLL / UNENROLL / TOKEN UPDATE PLACE
*--------------------------------------------------------------------

*     CASE ls_ca-actiontype.
*
*       WHEN 'E'.
*         " ENROLL LOGIC
*
*       WHEN 'U'.
*         " UNENROLL LOGIC
*
*       WHEN 'T'.
*         " UPDATE TOKEN LOGIC
*
*     ENDCASE.

*--------------------------------------------------------------------
* STORE RESPONSE IN ZTABLE2
*--------------------------------------------------------------------

        CLEAR ls_update.

        ls_update-mandt            = sy-mandt.
        ls_update-partner          = lv_bp.
        ls_update-contract_account = ls_ca-contractaccount.

        ls_update-is_eligible    = lv_eligible.
        ls_update-has_enrolled   = lv_enrolled.

        ls_update-process_status = lv_status.
        ls_update-process_msg    = lv_msg.

*--------------------------------------------------------------------
* FUTURE TOKEN/BANK DETAILS
*--------------------------------------------------------------------

*     ls_update-payment_token = ...
*     ls_update-bank_account  = ...
*     ls_update-routing_number = ...
*     ls_update-account_type   = ...

        MODIFY ztable2 FROM @ls_update.
*----------------------------------------------------
*        UPDATE ztable2
*           SET is_eligible    = @lv_eligible,
*               has_enrolled   = @lv_enrolled,
*               process_status = @lv_status,
*               process_msg    = @lv_msg
*         WHERE partner          = @lv_bp
*           AND contract_account = @ls_ca-contractaccount.
*----------------------------------------------------------

*--------------------------------------------------------------------
* SUCCESS / ERROR MESSAGE
*--------------------------------------------------------------------

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(

                   severity =
                     COND #(
                       WHEN lv_status = 'S'
                       THEN if_abap_behv_message=>severity-success
                       ELSE if_abap_behv_message=>severity-error
                     )

                   text = lv_msg

                 )
        ) TO reported-zrv_buisnesspartner.

      ENDLOOP.

*--------------------------------------------------------------------
* RETURN ROOT ONLY
*--------------------------------------------------------------------

      APPEND VALUE #(
        %tky = ls_key-%tky
        businesspartner = lv_bp
      ) TO result.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

CLASS lhc_zcv_contractaccountpartner DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcv_contractaccountpartner.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcv_contractaccountpartner RESULT result.

    METHODS rba_parent FOR READ
      IMPORTING keys_rba FOR READ zcv_contractaccountpartner\_parent FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zcv_contractaccountpartner IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD read.

    DATA:
      lt_token TYPE TABLE OF ztable2,
      ls_token TYPE ztable2.

    LOOP AT keys INTO DATA(ls_key).

*--------------------------------------------------------------------
* FETCH CHILD DATA
*--------------------------------------------------------------------

      SELECT *
        FROM ztable2
        WHERE partner          = @ls_key-businesspartner
          AND contract_account = @ls_key-contractaccount
        INTO TABLE @lt_token.

*--------------------------------------------------------------------
* RETURN CHILD RESPONSE
*--------------------------------------------------------------------

      LOOP AT lt_token INTO ls_token.

        APPEND VALUE #(

          %tky = VALUE #(
            businesspartner = ls_token-partner
            contractaccount = ls_token-contract_account
          )

          businesspartner = ls_token-partner
          contractaccount = ls_token-contract_account

          iseligible      = ls_token-is_eligible
          hasenrolled     = ls_token-has_enrolled

          companycode     = ''
          companycodedescription = ''

          bankaccountnumber = ls_token-bank_account
          bankroutingnumber = ls_token-routing_number
          bankaccounttype   = ls_token-account_type

          paymenttoken    = ls_token-payment_token
          actiontype      = 'F'

          processstatus   = ls_token-process_status
          processmessage  = ls_token-process_msg

        ) TO result.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD rba_parent.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zrv_buisnesspartner DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zrv_buisnesspartner IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
