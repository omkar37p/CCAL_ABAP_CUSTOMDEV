CLASS zbtp_form_insert_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBTP_FORM_INSERT_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    data: wa_db TYPE TABLE of zbtp_adobe_db.

        " Populate the structure with data
        wa_db = VALUE #( (
                         parameters = 'ADS_URL'
                         value = 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'
                         )
                         (
                         parameters = 'ADS_OAUTH_URL'
                         value = 'https://chemfab-developmet-nhcca2e9.authentication.eu10.hana.ondemand.com/oauth/token?grant_type=client_credentials'
                         )
                         (
                         parameters = 'ADS_CLIENTSECRET'
                         value = '25b1abe9-b8a2-4e3a-999a-23817138141f$gd26867-c915rXIe5cCxZz6QDtnhK4Sgs75qb6vo2iU='
                         )
                         (
                         parameters = 'ADS_CLIENTID'
                         value = 'sb-b29f14ab-c956-4ac2-9285-84b7763d980d!b522600|ads-xsappname!b102452'
                         )
                          ).

        " Delete the data into the database table
            DELETE FROM zbtp_adobe_db WHERE parameters is iNITIAL.

        " Insert the data into the database table
            INSERT zbtp_adobe_db from table @wa_db.

        " Fetch the data from database table
            "select * from zbtp_adobe_db into table @wa_db.

        " this is used to display the inserted records in the table as output.
            "out->write( EXPORTING data = wa_db ).

  ENDMETHOD.
ENDCLASS.
