CLASS lhc_zi_autopay_enroll DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_autopay_enroll RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_autopay_enroll RESULT result.

    METHODS enroll FOR MODIFY
      IMPORTING keys FOR ACTION zi_autopay_enroll~enroll RESULT result.

    METHODS unenroll FOR MODIFY
      IMPORTING keys FOR ACTION zi_autopay_enroll~unenroll RESULT result.

    METHODS validate_bank FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_autopay_enroll~validate_bank.

    METHODS validate_bp FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_autopay_enroll~validate_bp.

ENDCLASS.

CLASS lhc_zi_autopay_enroll IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " Implementation for instance-based authorization if needed
  ENDMETHOD.

  METHOD get_global_authorizations.
    " Implementation for global authorization if needed
  ENDMETHOD.

  METHOD enroll.
    " Action implementation: Enroll logic
    " Ensure the result is mapped correctly to the action output parameter
    result = VALUE #( FOR key IN keys
                       ( %tky   = key-%tky
                         %param = VALUE #( status  = 'E'
                                           message = 'Enrollment Successful' ) ) ).
  ENDMETHOD.

  METHOD unenroll.
    " Action implementation: Unenroll logic
    result = VALUE #( FOR key IN keys
                       ( %tky   = key-%tky
                         %param = VALUE #( status  = 'U'
                                           message = 'Unenrolled Successfully' ) ) ).
  ENDMETHOD.

  METHOD validate_bank.
    " Read data from the buffer
    READ ENTITIES OF zi_autopay_enroll
      ENTITY zi_autopay_enroll
      FIELDS ( bankaccount routingnumber )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).
      IF ls_data-bankaccount IS INITIAL OR ls_data-routingnumber IS INITIAL.

        APPEND VALUE #( %tky = ls_data-%tky ) TO failed-zi_autopay_enroll.

        APPEND VALUE #( %tky = ls_data-%tky
                        %msg = new_message( id       = 'ZMSG'
                                            number   = '003'
                                            severity = if_abap_behv_message=>severity-error )
                        " Note: Use v1/v2 only if your message &001 contains placeholders
                        %element-bankaccount   = if_abap_behv=>mk-on
                        %element-routingnumber = if_abap_behv=>mk-on
                      ) TO reported-zi_autopay_enroll.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validate_bp.
    " Read data from the buffer
    READ ENTITIES OF zi_autopay_enroll
      ENTITY zi_autopay_enroll
      FIELDS ( bpid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).
      " 1. Check if Business Partner ID is provided
      IF ls_data-bpid IS INITIAL.
        APPEND VALUE #( %tky = ls_data-%tky ) TO failed-zi_autopay_enroll.
        APPEND VALUE #( %tky = ls_data-%tky
                        %msg = new_message( id       = 'ZMSG'
                                            number   = '001'
                                            severity = if_abap_behv_message=>severity-error )
                        %element-bpid = if_abap_behv=>mk-on
                      ) TO reported-zi_autopay_enroll.
        CONTINUE.
      ENDIF.

      " 2. Validate against external Business Partner master data
      " Optimization: SELECT SINGLE check is okay as long as no COMMIT follows.
      SELECT SINGLE businesspartner FROM i_businesspartner
        WHERE businesspartner = @ls_data-bpid
        INTO @DATA(lv_bp).

      IF sy-subrc <> 0.
        APPEND VALUE #( %tky = ls_data-%tky ) TO failed-zi_autopay_enroll.
        APPEND VALUE #( %tky = ls_data-%tky
                        %msg = new_message( id       = 'ZMSG'
                                            number   = '002'
                                            severity = if_abap_behv_message=>severity-error )
                        %element-bpid = if_abap_behv=>mk-on
                      ) TO reported-zi_autopay_enroll.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
