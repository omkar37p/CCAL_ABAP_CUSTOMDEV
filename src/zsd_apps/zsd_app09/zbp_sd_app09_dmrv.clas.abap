CLASS zbp_sd_app09_dmrv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zsd_app09_dmrv.
  PUBLIC SECTION.
****--- PDF Print view Data Declaration---------------
    CLASS-DATA: gs_xmldata       TYPE string,
                gs_print_data_oc TYPE xstring,
                gs_pqitem_id_oc  TYPE sysuuid_c32,
                gs_print_data_dc TYPE xstring,
                gs_pqitem_id_dc  TYPE sysuuid_c32,
                gs_print_data_tc TYPE xstring,
                gs_pqitem_id_tc  TYPE sysuuid_c32,
                gv_invnum        TYPE vbeln,
                gv_tag_oc        TYPE string,
                gv_tag_dc        TYPE string,
                gv_tag_tc        TYPE string,
                gv_printq        TYPE c LENGTH 32,

                up_attach type table of ZSD_DSC_FILE_DB,
                up_email type table of ZSD_DSC_FILE_DB.

ENDCLASS.



CLASS ZBP_SD_APP09_DMRV IMPLEMENTATION.
ENDCLASS.
