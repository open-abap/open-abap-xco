CLASS cl_xco_uuid DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_uuid.

    METHODS constructor
      IMPORTING
        iv_value TYPE sysuuid_x16.
ENDCLASS.

CLASS cl_xco_uuid IMPLEMENTATION.
  METHOD constructor.
    if_xco_uuid~value = iv_value.
  ENDMETHOD.

  METHOD if_xco_uuid~as.
    ro_string = xco_cp=>string( io_format->from_uuid( me ) ).
  ENDMETHOD.
ENDCLASS.
