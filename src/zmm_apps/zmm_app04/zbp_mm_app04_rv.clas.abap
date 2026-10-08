CLASS zbp_mm_app04_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_app04_rv.
  PUBLIC SECTION.
    CLASS-DATA: gt_gidata   TYPE TABLE OF zmm_app04_tb1,
                gt_giupd    TYPE TABLE OF zmm_app04_tb1,
                gt_itmdata  TYPE TABLE OF zmm_app04_tb2,
                gt_itmupd   TYPE TABLE OF zmm_app04_tb2,
                gt_updinsp  TYPE TABLE OF zmm_app04_tb2,
                gt_godata   TYPE TABLE OF zmm_app04_tb3,
                gt_goupd    TYPE TABLE OF zmm_app04_tb3,
                gt_goupd2    TYPE TABLE OF zmm_app04_tb3,
                cv_mat_doc  TYPE RESPONSE FOR MAPPED I_MaterialDocumentTP,
                cv_insp_lot TYPE RESPONSE FOR MAPPED I_InspectionLotTP_2.
ENDCLASS.



CLASS ZBP_MM_APP04_RV IMPLEMENTATION.
ENDCLASS.
