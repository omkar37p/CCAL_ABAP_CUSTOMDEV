CLASS zbp_mm_app02_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_app02_rv.
  PUBLIC SECTION.
    CLASS-DATA: gt_hdrdata TYPE TABLE OF zmm_app02_tb1,
                gt_hdrupd  TYPE TABLE OF zmm_app02_tb1,
                gt_itmdata TYPE TABLE OF zmm_app02_tb2,
                gt_itmupd  TYPE TABLE OF zmm_app02_tb2.
    CLASS-DATA: cv_pr_doc  TYPE RESPONSE FOR MAPPED  i_purchaserequisitiontp.
ENDCLASS.



CLASS ZBP_MM_APP02_RV IMPLEMENTATION.
ENDCLASS.
