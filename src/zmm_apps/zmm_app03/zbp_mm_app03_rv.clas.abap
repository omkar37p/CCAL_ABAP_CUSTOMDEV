CLASS zbp_mm_app03_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_app03_rv.
  PUBLIC SECTION.
    CLASS-DATA: gt_hdrdata TYPE TABLE OF zmm_app03_tb1,
                gt_hdrupd  TYPE TABLE OF zmm_app03_tb1,
                gt_itmdata TYPE TABLE OF zmm_app03_tb2,
                gt_itmupd  TYPE TABLE OF zmm_app03_tb2,
                gt_bdgupd  TYPE TABLE OF zmm_app01_tb2.
    CLASS-DATA: cv_po_doc  TYPE RESPONSE FOR MAPPED  I_PurchaseOrderTP_2.

ENDCLASS.



CLASS ZBP_MM_APP03_RV IMPLEMENTATION.
ENDCLASS.
