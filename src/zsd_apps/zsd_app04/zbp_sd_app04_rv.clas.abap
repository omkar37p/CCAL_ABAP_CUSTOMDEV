CLASS zbp_sd_app04_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zsd_app04_rv.
  PUBLIC SECTION.
    CLASS-DATA: gt_itmupd  TYPE TABLE OF zsd_app02_tb2,
                gt_itmupd2 TYPE TABLE OF zsd_app02_tb2,
                gt_itmupd3 TYPE TABLE OF zsd_app02_tb2.
    CLASS-DATA: cv_dlv_doc TYPE RESPONSE FOR MAPPED  I_OutboundDeliveryTP,
                cv_mat_doc TYPE RESPONSE FOR MAPPED I_MaterialDocumentTP.
ENDCLASS.



CLASS ZBP_SD_APP04_RV IMPLEMENTATION.
ENDCLASS.
