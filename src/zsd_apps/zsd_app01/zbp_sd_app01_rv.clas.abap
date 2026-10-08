CLASS zbp_sd_app01_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zsd_app01_rv.
  PUBLIC SECTION.
    CLASS-DATA: gt_hdrdata TYPE TABLE OF zsd_app01_tb1,
                gt_hdrupd  TYPE TABLE OF zsd_app01_tb1,
                gt_hdrupd2 TYPE TABLE OF zsd_app01_tb1,
                gt_hdrupd3 TYPE TABLE OF zsd_app01_tb1,
                gt_itmdata TYPE TABLE OF zsd_app01_tb2,
                gt_itmupd  TYPE TABLE OF zsd_app01_tb2.
    CLASS-DATA: cv_dlv_doc TYPE RESPONSE FOR MAPPED  I_OutboundDeliveryTP,
                cv_mat_doc TYPE RESPONSE FOR MAPPED I_MaterialDocumentTP.
ENDCLASS.



CLASS ZBP_SD_APP01_RV IMPLEMENTATION.
ENDCLASS.
