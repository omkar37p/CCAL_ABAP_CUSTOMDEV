CLASS zbp_mm_app07_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_app07_rv.
  PUBLIC SECTION.
    CLASS-DATA: gt_hdrdata TYPE TABLE OF zmm_app07_tb1,
                gt_hdrupd  TYPE TABLE OF zmm_app07_tb1,
                gt_hdrupd2 TYPE TABLE OF zmm_app07_tb1,
                gt_itmdata TYPE TABLE OF zmm_app07_tb2,
                gt_upitmdata TYPE TABLE OF zmm_app07_tb2,
                gt_itmupd  TYPE TABLE OF zmm_app07_tb2,
                gv_userid  TYPE zmm_app07_tb1-createdby.
    CLASS-DATA: cv_pr_doc  TYPE RESPONSE FOR MAPPED  I_PurchaseRequisitionTP.

ENDCLASS.



CLASS ZBP_MM_APP07_RV IMPLEMENTATION.
ENDCLASS.
