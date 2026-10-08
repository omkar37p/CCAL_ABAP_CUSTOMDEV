CLASS zbp_qm_head_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zqm_head_rv.

PUBLIC SECTION.
    CLASS-DATA: gt_header TYPE TABLE OF ZQM_HEAD_DB,
                gt_uphead TYPE table of ZQM_HEAD_DB,
                gt_formcoa TYPE table of ZQM_HEAD_DB,
                gt_formlabel TYPE table of ZQM_HEAD_DB,

****---These one PDF Print view Data Declaration---------------
                gs_xmldata TYPE string,
                gs_print_data TYPE xstring,
                gs_pqitem_id TYPE sysuuid_c32,
*                gs_inspno TYPE ZQM_HEAD_RV-Inspection.
                gs_inspno TYPE c LENGTH 100,

****---These one PDF Label Print view Data Declaration---------------
                gs_labelxml TYPE string,
                gs_labelprint TYPE xstring,
                gs_labelpqitem_id TYPE sysuuid_c32,
*                gs_inspno TYPE ZQM_HEAD_RV-Inspection.
                gs_labelno TYPE c LENGTH 100,

***---Get Result for Printing Purpose--------------
                get_result type table of zqm_result_db.


ENDCLASS.



CLASS ZBP_QM_HEAD_RV IMPLEMENTATION.
ENDCLASS.
