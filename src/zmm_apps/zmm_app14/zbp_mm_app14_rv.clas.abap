CLASS zbp_mm_app14_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_app14_rv.
 CLASS-DATA: gt_gphdr TYPE TABLE OF zmm_app14_htb1,
                gt_gpitm TYPE TABLE OF zmm_app14_itb1,
                gt_upitm type table of zmm_app14_itb1,
                gt_uphdr type table of zmm_app14_htb1,
                gt_gpcitm type table of zmm_app14_tb1,
                gt_upcitm type table of zmm_app14_tb1,

**********************************************************************

                gv_gpnum type zmm_app15_rv-Gpnum,
                gs_xmldata    TYPE string,
                  gv_print_data TYPE xstring,
                  gv_qitem_id   TYPE sysuuid_c32.
ENDCLASS.



CLASS ZBP_MM_APP14_RV IMPLEMENTATION.
ENDCLASS.
