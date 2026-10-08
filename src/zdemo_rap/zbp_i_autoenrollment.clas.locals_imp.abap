CLASS lhc_zi_autoenrollment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_autoenrollment RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_autoenrollment RESULT result.

    METHODS validateeligibility FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_autoenrollment~validateeligibility.

ENDCLASS.

CLASS lhc_zi_autoenrollment IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validateeligibility.

   READ ENTITIES OF zi_autoenrollment
    IN LOCAL MODE
    ENTITY zi_autoenrollment
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).

  LOOP AT lt_data INTO DATA(ls_data).

    "=================================================
    " Validate Business Partner
    "=================================================

    SELECT SINGLE BusinessPartner
      FROM I_BusinessPartner
      WHERE BusinessPartner = @ls_data-BusinessPartner
      INTO @DATA(lv_businesspartner).

    IF sy-subrc <> 0.

      APPEND VALUE #(
        %tky = ls_data-%tky
        %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Invalid Business Partner'
               )
      ) TO reported-zi_autoenrollment.

      APPEND VALUE #(
        %tky = ls_data-%tky
      ) TO failed-zi_autoenrollment.

      CONTINUE.

    ENDIF.

    "=================================================
    " Validate Contract Account
    "=================================================

    SELECT SINGLE ContractAccount
      FROM I_ContractAccountPartner
      WHERE ContractAccount = @ls_data-ContractAccount
      INTO @DATA(lv_contractaccount).

    IF sy-subrc <> 0.

      APPEND VALUE #(
        %tky = ls_data-%tky
        %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Invalid Contract Account'
               )
      ) TO reported-zi_autoenrollment.

      APPEND VALUE #(
        %tky = ls_data-%tky
      ) TO failed-zi_autoenrollment.

      CONTINUE.

    ENDIF.

    "=================================================
    " Validate Contract Account belongs to BP
    "=================================================

    SELECT SINGLE ContractAccount
      FROM I_ContractAccountPartner
      WHERE ContractAccount = @ls_data-ContractAccount
        AND BusinessPartner = @ls_data-BusinessPartner
      INTO @DATA(lv_ca_bp).

    IF sy-subrc <> 0.

      APPEND VALUE #(
        %tky = ls_data-%tky
        %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Contract Account does not belong to Business Partner'
               )
      ) TO reported-zi_autoenrollment.

      APPEND VALUE #(
        %tky = ls_data-%tky
      ) TO failed-zi_autoenrollment.

      CONTINUE.

    ENDIF.

    "=================================================
    " Already Enrolled Validation
    "=================================================

    SELECT SINGLE enrollment_status
      FROM zautopay_hdr
      WHERE contractaccount = @ls_data-ContractAccount
        AND enrollment_status = 'E'
      INTO @DATA(lv_status).

    IF sy-subrc = 0.

      APPEND VALUE #(
        %tky = ls_data-%tky
        %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Contract Account already enrolled'
               )
      ) TO reported-zi_autoenrollment.

      APPEND VALUE #(
        %tky = ls_data-%tky
      ) TO failed-zi_autoenrollment.

      CONTINUE.

    ENDIF.

        "=================================================
    " Validate Bank Details Exist
    "=================================================

    READ ENTITIES OF zi_autoenrollment
      IN LOCAL MODE
      ENTITY zi_autoenrollment BY \_Bank
      ALL FIELDS
      WITH VALUE #(
        ( %tky = ls_data-%tky )
      )
      RESULT DATA(lt_bank).

    IF lt_bank IS INITIAL.

      APPEND VALUE #(
        %tky = ls_data-%tky
        %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Bank details are mandatory'
               )
      ) TO reported-zi_autoenrollment.

      APPEND VALUE #(
        %tky = ls_data-%tky
      ) TO failed-zi_autoenrollment.

      CONTINUE.

    ENDIF.

    "=================================================
    " Validate Enrollment Status
    "=================================================

    IF ls_data-EnrollmentStatus IS INITIAL.

      APPEND VALUE #(
        %tky = ls_data-%tky
        %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Enrollment Status is mandatory'
               )
      ) TO reported-zi_autoenrollment.

      APPEND VALUE #(
        %tky = ls_data-%tky
      ) TO failed-zi_autoenrollment.

      CONTINUE.

    ENDIF.

  ENDLOOP.



  ENDMETHOD.

ENDCLASS.
