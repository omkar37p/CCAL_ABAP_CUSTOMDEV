CLASS zbp_pp_qm_coa01_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zpp_qm_coa01_rv.

PUBLIC SECTION.
    CLASS-DATA: gt_header TYPE TABLE OF ZPP_QM_COA_TB1,
                gt_item TYPE TABLE OF ZPP_QM_COA_TB2,
                gt_uphead TYPE TABLE of ZPP_QM_COA_TB1,
                gt_upitem TYPE TABLE of ZPP_QM_COA_TB2,

****---These one PDF Print view Data Declaration---------------
                gs_xmldata TYPE string,
                gs_print_data TYPE xstring,
                gs_pqitem_id TYPE sysuuid_c32,
                gs_inspno TYPE zpp_qm_coa01_rv-Inspection.

ENDCLASS.



CLASS ZBP_PP_QM_COA01_RV IMPLEMENTATION.
ENDCLASS.
