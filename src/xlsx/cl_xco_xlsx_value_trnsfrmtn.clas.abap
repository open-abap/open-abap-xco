" the value transformations of read and write access, see the SAP Help Portal,
" "XLSX Read Access" and "XLSX Write Access", section "Value Transformations":
" - identity: the value as stored in the file, assigned to the field as it is
" - string value: the text of the cell, for character-like fields only
" - best effort: converted to the type of the field, dates and times also from their
"   Excel serial numbers, booleans to abap_bool; raises if that is not possible
" Excel stores numbers as doubles: INT8 beyond 2^53 and packed numbers with more
" than 15 significant digits are written as numbers all the same, Excel rounds them
CLASS cl_xco_xlsx_value_trnsfrmtn DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_cp_xlsx_ra_vt_factory cl_xco_cp_xlsx_wa_vt_factory.

  PUBLIC SECTION.
    INTERFACES if_xco_xlsx_ra_vt_identity.
    INTERFACES if_xco_xlsx_ra_vt_string_value.
    INTERFACES if_xco_xlsx_ra_vt_best_effort.
    INTERFACES if_xco_xlsx_wa_vt_best_effort.

    TYPES ty_kind TYPE c LENGTH 1.

    CONSTANTS:
      BEGIN OF gc_kind,
        identity     TYPE ty_kind VALUE 'I',
        string_value TYPE ty_kind VALUE 'S',
        best_effort  TYPE ty_kind VALUE 'B',
      END OF gc_kind.

    METHODS constructor
      IMPORTING
        iv_kind TYPE ty_kind.

    " writes the value of a cell to an ABAP field, raises cx_xco_runtime_exception if
    " the field cannot take the value
    METHODS read
      IMPORTING
        is_cell  TYPE cl_xco_xlsx_file=>ty_cell
      CHANGING
        cv_field TYPE any.

    " the cell type, value and style for an ABAP field, without type if nothing is
    " written; raises cx_xco_runtime_exception for types the transformation does not support
    METHODS write
      IMPORTING
        iv_field       TYPE any
      RETURNING
        VALUE(rs_cell) TYPE cl_xco_xlsx_file=>ty_cell.

  PRIVATE SECTION.
    " Excel counts 1900-01-01 as day 1 and has a 1900-02-29, day 60, that did not exist
    CONSTANTS gc_day_zero TYPE d VALUE '18991231'.
    CONSTANTS gc_day_zero_from_march TYPE d VALUE '18991230'.
    CONSTANTS gc_first_of_march TYPE d VALUE '19000301'.
    CONSTANTS gc_first_day TYPE d VALUE '19000101'.
    CONSTANTS gc_fictitious_day TYPE i VALUE 60.
    CONSTANTS gc_seconds_per_day TYPE i VALUE 86400.

    DATA mv_kind TYPE ty_kind.

    CLASS-METHODS read_best_effort
      IMPORTING
        is_cell  TYPE cl_xco_xlsx_file=>ty_cell
        io_type  TYPE REF TO cl_abap_typedescr
      CHANGING
        cv_field TYPE any.

    CLASS-METHODS date_from_cell
      IMPORTING
        is_cell        TYPE cl_xco_xlsx_file=>ty_cell
      RETURNING
        VALUE(rv_date) TYPE d.

    CLASS-METHODS time_from_cell
      IMPORTING
        is_cell        TYPE cl_xco_xlsx_file=>ty_cell
      RETURNING
        VALUE(rv_time) TYPE t.

    CLASS-METHODS serial_of_date
      IMPORTING
        iv_date          TYPE d
      RETURNING
        VALUE(rv_serial) TYPE i.

    CLASS-METHODS fraction_of_time
      IMPORTING
        iv_time            TYPE t
      RETURNING
        VALUE(rv_fraction) TYPE string.

    " raises if the digits are no valid date
    CLASS-METHODS valid_date
      IMPORTING
        iv_digits      TYPE string
      RETURNING
        VALUE(rv_date) TYPE d.

    " raises if the digits are no valid time
    CLASS-METHODS valid_time
      IMPORTING
        iv_digits      TYPE string
      RETURNING
        VALUE(rv_time) TYPE t.
ENDCLASS.

CLASS cl_xco_xlsx_value_trnsfrmtn IMPLEMENTATION.
  METHOD constructor.
    mv_kind = iv_kind.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_vt_cell_value~get_implementation.
    ro_implementation = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_vt_row_value~get_implementation.
    ro_implementation = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_vt_cell_value~get_implementation.
    ro_implementation = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_vt_row_value~get_implementation.
    ro_implementation = me.
  ENDMETHOD.

  METHOD read.
    IF is_cell-type IS INITIAL.
      CLEAR cv_field.
      RETURN.
    ENDIF.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( cv_field ).
    TRY.
        CASE mv_kind.
          WHEN gc_kind-identity.
            cv_field = is_cell-value.
          WHEN gc_kind-string_value.
            IF lo_type->type_kind <> cl_abap_typedescr=>typekind_char
                AND lo_type->type_kind <> cl_abap_typedescr=>typekind_string.
              RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
            ENDIF.
            IF is_cell-type = cl_xco_xlsx_file=>gc_type-boolean.
              cv_field = COND string( WHEN is_cell-value = `1` THEN `TRUE` ELSE `FALSE` ).
            ELSE.
              cv_field = is_cell-value.
            ENDIF.
          WHEN OTHERS.
            read_best_effort( EXPORTING is_cell  = is_cell
                                        io_type  = lo_type
                              CHANGING  cv_field = cv_field ).
        ENDCASE.
      CATCH cx_sy_conversion_error cx_sy_arithmetic_error INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.
  ENDMETHOD.

  METHOD read_best_effort.
    DATA lv_number TYPE decfloat34.

    IF io_type->relative_name = 'ABAP_BOOL' AND is_cell-type = cl_xco_xlsx_file=>gc_type-boolean.
      cv_field = xsdbool( is_cell-value = `1` ).
      RETURN.
    ENDIF.

    CASE io_type->type_kind.
      WHEN cl_abap_typedescr=>typekind_date.
        cv_field = date_from_cell( is_cell ).
      WHEN cl_abap_typedescr=>typekind_time.
        cv_field = time_from_cell( is_cell ).
      WHEN cl_abap_typedescr=>typekind_int OR cl_abap_typedescr=>typekind_int1 OR cl_abap_typedescr=>typekind_int2
          OR cl_abap_typedescr=>typekind_int8 OR cl_abap_typedescr=>typekind_packed OR cl_abap_typedescr=>typekind_float
          OR cl_abap_typedescr=>typekind_decfloat16 OR cl_abap_typedescr=>typekind_decfloat34.
        " via decfloat, which also takes the exponent notation of a file, 1.5E-3
        lv_number = is_cell-value.
        cv_field = lv_number.
      WHEN OTHERS.
        cv_field = is_cell-value.
    ENDCASE.
  ENDMETHOD.

  METHOD date_from_cell.
    DATA lv_serial TYPE decfloat34.
    DATA lv_days TYPE i.

    IF is_cell-type <> cl_xco_xlsx_file=>gc_type-number.
      " YYYYMMDD or ISO 8601, YYYY-MM-DD with an optional time
      IF matches( val   = is_cell-value
                  regex = `\d{8}` ).
        rv_date = valid_date( is_cell-value ).
      ELSEIF matches( val   = is_cell-value
                      regex = `\d{4}-\d{2}-\d{2}(T.*)?` ).
        rv_date = valid_date( replace( val  = substring( val = is_cell-value
                                                         len = 10 )
                                       sub  = `-`
                                       with = ``
                                       occ  = 0 ) ).
      ELSE.
        RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
      ENDIF.
      RETURN.
    ENDIF.

    lv_serial = is_cell-value.
    lv_days = floor( lv_serial ).
    IF lv_days < 1 OR lv_days = gc_fictitious_day.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ELSEIF lv_days < gc_fictitious_day.
      rv_date = gc_day_zero + lv_days.
    ELSE.
      rv_date = gc_day_zero_from_march + lv_days.
    ENDIF.
  ENDMETHOD.

  METHOD time_from_cell.
    DATA lv_serial TYPE decfloat34.
    DATA lv_seconds TYPE i.
    DATA lv_text TYPE string.

    IF is_cell-type <> cl_xco_xlsx_file=>gc_type-number.
      " HHMMSS, HH:MM:SS or the time of ISO 8601, YYYY-MM-DDTHH:MM:SS
      lv_text = is_cell-value.
      IF lv_text CS `T`.
        lv_text = substring_after( val = lv_text
                                   sub = `T` ).
      ENDIF.
      IF matches( val   = lv_text
                  regex = `\d{6}` ).
        rv_time = valid_time( lv_text ).
      ELSEIF matches( val   = lv_text
                      regex = `\d{2}:\d{2}:\d{2}(\.\d*)?` ).
        rv_time = valid_time( replace( val  = substring( val = lv_text
                                                         len = 8 )
                                       sub  = `:`
                                       with = ``
                                       occ  = 0 ) ).
      ELSE.
        RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
      ENDIF.
      RETURN.
    ENDIF.

    " the fraction of the day, a date part is ignored
    lv_serial = is_cell-value.
    lv_seconds = ( lv_serial - floor( lv_serial ) ) * gc_seconds_per_day.
    lv_seconds = lv_seconds MOD gc_seconds_per_day.
    rv_time = |{ lv_seconds DIV 3600 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|
           && |{ lv_seconds MOD 3600 DIV 60 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|
           && |{ lv_seconds MOD 60 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
  ENDMETHOD.

  METHOD write.
    DATA lv_date TYPE d.
    DATA lv_number TYPE decfloat34.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( iv_field ).

    IF lo_type->relative_name = 'ABAP_BOOL'.
      rs_cell-type = cl_xco_xlsx_file=>gc_type-boolean.
      rs_cell-value = COND #( WHEN iv_field = abap_true THEN `1` ELSE `0` ).
      RETURN.
    ENDIF.

    CASE lo_type->type_kind.
      WHEN cl_abap_typedescr=>typekind_char OR cl_abap_typedescr=>typekind_num OR cl_abap_typedescr=>typekind_string.
        rs_cell-value = |{ iv_field }|.
        IF rs_cell-value IS NOT INITIAL.
          rs_cell-type = cl_xco_xlsx_file=>gc_type-string.
        ENDIF.
      WHEN cl_abap_typedescr=>typekind_int OR cl_abap_typedescr=>typekind_int1 OR cl_abap_typedescr=>typekind_int2
          OR cl_abap_typedescr=>typekind_int8 OR cl_abap_typedescr=>typekind_packed.
        rs_cell-type = cl_xco_xlsx_file=>gc_type-number.
        rs_cell-value = |{ iv_field }|.
      WHEN cl_abap_typedescr=>typekind_float OR cl_abap_typedescr=>typekind_decfloat16
          OR cl_abap_typedescr=>typekind_decfloat34.
        " decfloat gives the shortest decimal text
        lv_number = iv_field.
        rs_cell-type = cl_xco_xlsx_file=>gc_type-number.
        rs_cell-value = |{ lv_number }|.
      WHEN cl_abap_typedescr=>typekind_date.
        lv_date = iv_field.
        IF lv_date IS NOT INITIAL.
          rs_cell-type = cl_xco_xlsx_file=>gc_type-number.
          rs_cell-value = |{ serial_of_date( lv_date ) }|.
          rs_cell-style = cl_xco_xlsx_file=>gc_style-date.
        ENDIF.
      WHEN cl_abap_typedescr=>typekind_time.
        rs_cell-type = cl_xco_xlsx_file=>gc_type-number.
        rs_cell-value = fraction_of_time( iv_field ).
        rs_cell-style = cl_xco_xlsx_file=>gc_style-time.
      WHEN OTHERS.
        RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDCASE.
  ENDMETHOD.

  METHOD serial_of_date.
    " Excel has no dates before 1900-01-01
    DATA(lv_date) = valid_date( CONV string( iv_date ) ).
    IF lv_date < gc_first_day.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ELSEIF lv_date < gc_first_of_march.
      rv_serial = lv_date - gc_day_zero.
    ELSE.
      rv_serial = lv_date - gc_day_zero_from_march.
    ENDIF.
  ENDMETHOD.

  METHOD fraction_of_time.
    DATA lv_fraction TYPE decfloat34.

    " the seconds from the digits, which are validated first
    DATA(lv_time) = valid_time( CONV string( iv_time ) ).
    lv_fraction = ( lv_time(2) * 3600 + lv_time+2(2) * 60 + lv_time+4(2) ) / gc_seconds_per_day.
    rv_fraction = |{ lv_fraction }|.
  ENDMETHOD.

  METHOD valid_date.
    " a date that does not exist does not survive the way to days and back
    DATA lv_back TYPE d.

    IF NOT matches( val   = iv_digits
                    regex = `\d{8}` ) OR iv_digits = `00000000`.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    rv_date = iv_digits.
    DATA(lv_days) = rv_date - gc_day_zero.
    lv_back = gc_day_zero + lv_days.
    IF lv_back <> rv_date.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
  ENDMETHOD.

  METHOD valid_time.
    IF NOT matches( val   = iv_digits
                    regex = `([01]\d|2[0-3])[0-5]\d[0-5]\d` ).
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    rv_time = iv_digits.
  ENDMETHOD.
ENDCLASS.
