CLASS zpp_qm_dumy_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZPP_QM_DUMY_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
        " Delete the data into the database table
**            DELETE FROM zmm_app04_tb2 where  uuid = '42010A0B60A11FD0BAF52FBBEBDE551B'
**                                            and ebelp = '00010'.
**            DELETE FROM zqm_app01_idb.
  ENDMETHOD.
ENDCLASS.
