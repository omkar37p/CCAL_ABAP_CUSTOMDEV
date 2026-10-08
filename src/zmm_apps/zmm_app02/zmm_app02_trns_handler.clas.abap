CLASS zmm_app02_trns_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
**********************************************************************
    CLASS-DATA: go_instance TYPE REF TO zmm_app02_trns_handler.

    CLASS-METHODS: get_instance RETURNING VALUE(result)
                                            TYPE REF TO zmm_app02_trns_handler.

    TYPES: BEGIN OF ty_temp_key,
             cid TYPE abp_behv_cid,
             pid TYPE abp_behv_pid,
           END OF ty_temp_key,
           tt_temp_key TYPE STANDARD TABLE OF ty_temp_key WITH DEFAULT KEY,

           BEGIN OF ty_final_key,
             cid       TYPE abp_behv_cid,
             purreqnum TYPE zmm_app02_tb1-purreqnum,
           END OF ty_final_key,

           tt_final_key TYPE STANDARD TABLE OF ty_final_key WITH DEFAULT KEY,
           tt_header    TYPE STANDARD TABLE OF zmm_app02_tb1 WITH DEFAULT KEY.

    DATA: temp_key     TYPE tt_temp_key.
**********************************************************************

    METHODS: set_temp_key IMPORTING it_temp_key TYPE tt_temp_key,
      convert_temp_to_final RETURNING VALUE(result) TYPE tt_final_key,
      additional_save IMPORTING it_create TYPE tt_header
                                it_delete TYPE tt_header,
      clean_up.
**********************************************************************
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMM_APP02_TRNS_HANDLER IMPLEMENTATION.


  METHOD additional_save.

    DATA: lt_create TYPE TABLE OF zmm_app02_tb1.

    DATA(lt_je_key) = convert_temp_to_final(  ).

    LOOP AT it_create INTO DATA(ls_create).
      READ TABLE lt_je_key INTO DATA(ls_je_key) WITH KEY cid = ls_create-uuid.
      IF sy-subrc = 0.
        ls_create-purreqnum = ls_je_key-purreqnum.
        APPEND ls_create TO lt_create.
      ENDIF.
    ENDLOOP.

    IF lt_create IS NOT INITIAL.
      INSERT zmm_app02_tb1 FROM TABLE @lt_create.
    ENDIF.

    IF it_delete IS NOT INITIAL.
      DELETE zmm_app02_tb1 FROM TABLE @it_delete.
    ENDIF.

  ENDMETHOD.


  METHOD clean_up.
    CLEAR temp_key.
  ENDMETHOD.


  METHOD convert_temp_to_final.
    DATA: ls_final_key TYPE ty_final_key.
    IF temp_key IS NOT INITIAL.
      LOOP AT temp_key INTO DATA(ls_temp_key).
        CONVERT KEY OF i_purchaserequisitiontp
          FROM ls_temp_key-pid
          TO FINAL(lv_root_key).

        ls_final_key-cid = ls_temp_key-cid.
        ls_final_key-purreqnum = lv_root_key-PurchaseRequisition.

        APPEND ls_final_key TO result.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    result = go_instance.
  ENDMETHOD.


  METHOD set_temp_key.
    temp_key = it_temp_key.
  ENDMETHOD.
ENDCLASS.
