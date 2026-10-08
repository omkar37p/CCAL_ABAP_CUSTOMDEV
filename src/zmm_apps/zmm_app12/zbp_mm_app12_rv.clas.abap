CLASS zbp_mm_app12_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_app12_rv.
  PUBLIC SECTION.
    CLASS-DATA: gt_gphdr TYPE TABLE OF zmm_app12_tb1,
                gt_gpitm TYPE TABLE OF zmm_app12_tb2,
                gt_upitm type table of zmm_app12_tb2,
                gt_uphdr type table of zmm_app12_tb1,
                gt_uptot type table of zmm_app12_tb1,
                gt_checkd type table of zmm_app12_tb1,
                gt_att type table of zmm_app12_chtb,
***********************************temp***********************************
                gv_gpnum type zmm_app12_rv-Gpnum,
                gv_gptype type zmm_app12_rv-Gptype,
                gs_xmldata    TYPE string,
                  gv_print_data TYPE xstring,
                  gv_qitem_id   TYPE sysuuid_c32.

**********************************************************************
ENDCLASS.



CLASS ZBP_MM_APP12_RV IMPLEMENTATION.
ENDCLASS.
