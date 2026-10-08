CLASS lhc_zi_autoenroll DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_autoenroll RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_autoenroll RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_autoenroll.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_autoenroll.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_autoenroll.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_autoenroll RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_autoenroll.

    METHODS rba_ca FOR READ
      IMPORTING keys_rba FOR READ zi_autoenroll\_ca FULL result_requested RESULT result LINK association_links.

    METHODS cba_ca FOR MODIFY
      IMPORTING entities_cba FOR CREATE zi_autoenroll\_ca.

    METHODS enroll FOR MODIFY
      IMPORTING keys FOR ACTION zi_autoenroll~enroll RESULT result.

ENDCLASS.

CLASS lhc_zi_autoenroll IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

    LOOP AT entities INTO DATA(ls_entity).

      "========================================
      " Validation - BP Mandatory
      "========================================

      IF ls_entity-businesspartner IS INITIAL.

        APPEND VALUE #(
          %cid = ls_entity-%cid
        ) TO failed-zi_autoenroll.

        CONTINUE.

      ENDIF.

      "========================================
      " Buffer Header Data
      "========================================

      APPEND VALUE #(
  businesspartner        = ls_entity-businesspartner
  channel                = ls_entity-channel
  entity                 = ls_entity-entity
  businesspartnername    = ls_entity-businesspartnername
  businesspartneraddress = ls_entity-businesspartneraddress
  companycode            = ls_entity-companycode
  customertoken          = ls_entity-customertoken
  overallstatus          = ls_entity-overallstatus
  overallmessage         = ls_entity-overallmessage
) TO zcl_autoenroll_buffer=>gt_header.

      "========================================
      " Mapping
      "========================================

      APPEND VALUE #(
        %cid = ls_entity-%cid
        businesspartner = ls_entity-businesspartner
      ) TO mapped-zi_autoenroll.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    LOOP AT entities INTO DATA(ls_entity).

      READ TABLE zcl_autoenroll_buffer=>gt_header
        ASSIGNING FIELD-SYMBOL(<fs_header>)
        WITH KEY businesspartner = ls_entity-businesspartner.

      IF sy-subrc = 0.

        <fs_header>-channel = ls_entity-channel.
        <fs_header>-companycode = ls_entity-companycode.
        <fs_header>-customertoken = ls_entity-customertoken.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    LOOP AT keys INTO DATA(ls_key).

      DELETE zcl_autoenroll_buffer=>gt_header
        WHERE businesspartner = ls_key-businesspartner.

    ENDLOOP.

  ENDMETHOD.

  METHOD read.

    LOOP AT keys INTO DATA(ls_key).

      READ TABLE zcl_autoenroll_buffer=>gt_header
        INTO DATA(ls_header)
        WITH KEY businesspartner = ls_key-businesspartner.

      IF sy-subrc = 0.
        APPEND VALUE #(
  businesspartner        = ls_header-businesspartner
  channel                = ls_header-channel
  entity                 = ls_header-entity
  businesspartnername    = ls_header-businesspartnername
  businesspartneraddress = ls_header-businesspartneraddress
  companycode            = ls_header-companycode
  customertoken          = ls_header-customertoken
  overallstatus          = ls_header-overallstatus
  overallmessage         = ls_header-overallmessage
) TO result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_ca.

    LOOP AT keys_rba INTO DATA(ls_rba).

      LOOP AT zcl_autoenroll_buffer=>gt_child
        INTO DATA(ls_child)
        WHERE businesspartner = ls_rba-businesspartner.

        APPEND VALUE #(
       contractaccount   = ls_child-contractaccount
       businesspartner   = ls_child-businesspartner
       iseligible        = ls_child-iseligible
       isenrolled        = ls_child-isenrolled
       bankaccountnumber = ls_child-bankaccountnumber
       bankroutingnumber = ls_child-bankroutingnumber
       bankaccounttype   = ls_child-bankaccounttype
       eligibilitymsg    = ls_child-eligibilitymsg
       actionstatus      = ls_child-actionstatus
       actionmessage     = ls_child-actionmessage
     ) TO result.

        APPEND VALUE #(
      source-businesspartner = ls_rba-businesspartner
      target-businesspartner = ls_child-businesspartner
      target-contractaccount = ls_child-contractaccount
    ) TO association_links.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD cba_ca.

    LOOP AT entities_cba INTO DATA(ls_group).

      LOOP AT ls_group-%target INTO DATA(ls_child).

        "========================================
        " Validation
        "========================================

        IF ls_child-contractaccount IS INITIAL.

          APPEND VALUE #(
  %key-contractaccount = ls_child-%key-contractaccount
  %key-businesspartner = ls_child-%key-businesspartner
) TO failed-zcv_autoenroll.

          CONTINUE.

        ENDIF.

        "========================================
        " Buffer Child
        "========================================

        APPEND VALUE #(
  contractaccount   = ls_child-contractaccount
  businesspartner   = ls_child-businesspartner
  iseligible        = ls_child-iseligible
  isenrolled        = ls_child-isenrolled
  bankaccountnumber = ls_child-bankaccountnumber
  bankroutingnumber = ls_child-bankroutingnumber
  bankaccounttype   = ls_child-bankaccounttype
  eligibilitymsg    = ls_child-eligibilitymsg
  actionstatus      = ls_child-actionstatus
  actionmessage     = ls_child-actionmessage
) TO zcl_autoenroll_buffer=>gt_child.

        "========================================
        " Mapping
        "========================================

        APPEND VALUE #(
          contractaccount = ls_child-contractaccount
          businesspartner = ls_child-businesspartner
        ) TO mapped-zcv_autoenroll.

      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.

  METHOD enroll.

    LOOP AT keys INTO DATA(ls_key).

      READ TABLE zcl_autoenroll_buffer=>gt_header
        ASSIGNING FIELD-SYMBOL(<fs_header>)
        WITH KEY businesspartner = ls_key-businesspartner.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      "========================================
      " Validation - Already Enrolled
      "========================================

      IF <fs_header>-overallstatus = 'S'.

        APPEND VALUE #(
   businesspartner = ls_key-businesspartner
 ) TO failed-zi_autoenroll.

        APPEND VALUE #(
          businesspartner = ls_key-businesspartner
          %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Already Enrolled'
                 )
        ) TO reported-zi_autoenroll.

        CONTINUE.

      ENDIF.

      "========================================
      " Success
      "========================================

      <fs_header>-overallstatus = 'S'.

      <fs_header>-overallmessage =
        |Enrollment successful for { <fs_header>-businesspartner }|.

      APPEND VALUE #(
        %tky = ls_key-%tky
      ) TO result.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zcv_autoenroll DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcv_autoenroll.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zcv_autoenroll.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcv_autoenroll RESULT result.

    METHODS rba_hdr FOR READ
      IMPORTING keys_rba FOR READ zcv_autoenroll\_hdr FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zcv_autoenroll IMPLEMENTATION.

  METHOD update.

    LOOP AT entities INTO DATA(ls_child).

      READ TABLE zcl_autoenroll_buffer=>gt_child
        ASSIGNING FIELD-SYMBOL(<fs_child>)
        WITH KEY
          contractaccount = ls_child-contractaccount
          businesspartner = ls_child-businesspartner.

      IF sy-subrc = 0.

        <fs_child>-bankaccountnumber = ls_child-bankaccountnumber.
        <fs_child>-bankroutingnumber = ls_child-bankroutingnumber.
        <fs_child>-bankaccounttype   = ls_child-bankaccounttype.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    LOOP AT keys INTO DATA(ls_key).

      DELETE zcl_autoenroll_buffer=>gt_child
        WHERE contractaccount = ls_key-contractaccount
          AND businesspartner = ls_key-businesspartner.

    ENDLOOP.

  ENDMETHOD.

  METHOD read.

    LOOP AT keys INTO DATA(ls_key).

      READ TABLE zcl_autoenroll_buffer=>gt_child
        INTO DATA(ls_child)
        WITH KEY
          contractaccount = ls_key-contractaccount
          businesspartner = ls_key-businesspartner.

      IF sy-subrc = 0.
        APPEND VALUE #(
  contractaccount   = ls_child-contractaccount
  businesspartner   = ls_child-businesspartner
  iseligible        = ls_child-iseligible
  isenrolled        = ls_child-isenrolled
  bankaccountnumber = ls_child-bankaccountnumber
  bankroutingnumber = ls_child-bankroutingnumber
  bankaccounttype   = ls_child-bankaccounttype
  eligibilitymsg    = ls_child-eligibilitymsg
  actionstatus      = ls_child-actionstatus
  actionmessage     = ls_child-actionmessage
) TO result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD rba_hdr.

    LOOP AT keys_rba INTO DATA(ls_key).

      READ TABLE zcl_autoenroll_buffer=>gt_header
        INTO DATA(ls_header)
        WITH KEY businesspartner = ls_key-businesspartner.

      IF sy-subrc = 0.

        APPEND VALUE #(
  businesspartner        = ls_header-businesspartner
  channel                = ls_header-channel
  entity                 = ls_header-entity
  businesspartnername    = ls_header-businesspartnername
  businesspartneraddress = ls_header-businesspartneraddress
  companycode            = ls_header-companycode
  customertoken          = ls_header-customertoken
  overallstatus          = ls_header-overallstatus
  overallmessage         = ls_header-overallmessage
) TO result.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_autoenroll DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_autoenroll IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

* Save Header Data

* INSERT zautopay_hdr FROM TABLE ...

* Save Child Data

* INSERT zautopay_item FROM TABLE ...


  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
