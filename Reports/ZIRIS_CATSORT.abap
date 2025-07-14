*&---------------------------------------------------------------------*
*& Report ZIRIS_CATSORT
*&---------------------------------------------------------------------*
*& Konverter tabell med kategorier fra gammelt EIC-system til IC-skjema
*&---------------------------------------------------------------------*
REPORT ziris_catsort.

TYPES: BEGIN OF ty_excel_input,
         col1_id       TYPE string, " EIC-kategori = id for kategorien
         col2_endda    TYPE string, " Gyldig til
         col3_begda    TYPE string, " Gyldig fra
         col4_cat      TYPE string, " EIC-kategori = overordnet kategori som denne er underordnet
         col5_stilling TYPE string, " Stilling
         col6_niv      TYPE string, " Nivå
         col7_besk     TYPE string, " Beskrivelse = navn på kategorien
       END OF ty_excel_input,

       BEGIN OF ty_excel_output,
         col1  TYPE string,
         col2  TYPE string,
         col3  TYPE string,
         col4  TYPE string,
         col5  TYPE string,
         col6  TYPE string,
         col7  TYPE string,
         col8  TYPE string,
         col9  TYPE string,
         col10 TYPE string,
         col11 TYPE string,
         col12 TYPE string,
         col13 TYPE string,
       END OF ty_excel_output,
       tt_excel_output TYPE TABLE OF ty_excel_output,
       tt_excel_input  TYPE TABLE OF ty_excel_input.

DATA: lo_table        TYPE REF TO cl_salv_table,
      lt_raw_data     TYPE truxs_t_text_data,
      lt_excel_data   TYPE TABLE OF ty_excel_input,
      lt_excel_input  TYPE TABLE OF ty_excel_input,
      lt_excel_output TYPE TABLE OF ty_excel_output,
      ls_output_row   TYPE ty_excel_output.

SELECTION-SCREEN: BEGIN OF BLOCK b001 WITH FRAME TITLE TEXT-001.
PARAMETERS: cat_file TYPE rlgrap-filename OBLIGATORY,
            out_file TYPE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK b001.

* F4 hjelp for kategorifil
AT SELECTION-SCREEN ON VALUE-REQUEST FOR cat_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'CAT_FILE'
    IMPORTING
      file_name  = cat_file.

* F4 hjelp for utfil
AT SELECTION-SCREEN ON VALUE-REQUEST FOR out_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'OUT_FILE'
    IMPORTING
      file_name  = out_file.

START-OF-SELECTION.
  PERFORM process_file.
*--------------------------------------------------------------------*
* Subdivisions
*--------------------------------------------------------------------*
* Hent ut gyldig data
*--------------------------------------------------------------------*
FORM get_valid_posts USING lt_data TYPE tt_excel_input.

  DATA:
        lv_converted_date TYPE sy-datum.
  LOOP AT lt_data INTO DATA(ls_input_row).

    CALL FUNCTION 'CONVERT_DATE_INPUT'
      EXPORTING
        input                     = ls_input_row-col2_endda
      IMPORTING
        output                    = lv_converted_date
      EXCEPTIONS
        plausibility_check_failed = 1
        wrong_format_in_input     = 2.

    IF sy-subrc = 0 AND lv_converted_date GE sy-datum.
      APPEND ls_input_row TO lt_excel_data.
    ENDIF.
  ENDLOOP.
ENDFORM.
*--------------------------------------------------------------------*
* Behandle fil
*--------------------------------------------------------------------*
FORM process_file.

  DATA:
    lt_niv1 TYPE TABLE OF ty_excel_input,
    lt_niv2 TYPE TABLE OF ty_excel_input,
    lt_niv3 TYPE TABLE OF ty_excel_input,
    lt_niv4 TYPE TABLE OF ty_excel_input.

* Konverter excel fil til SAP format
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = 'X'
      i_tab_raw_data       = lt_raw_data
      i_filename           = cat_file
    TABLES
      i_tab_converted_data = lt_excel_input
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Opplastning feilet' TYPE 'E'.
  ENDIF.

* Få sortert ut gyldig data
  PERFORM get_valid_posts USING lt_excel_input.

* Legg til header
  ls_output_row-col1 = 'Språk'.
  ls_output_row-col2 = 'NO'.
  APPEND ls_output_row TO lt_excel_output.
  CLEAR ls_output_row.

  ls_output_row-col1 = 'Skjema-ID'.
  ls_output_row-col2 = 'ZHRR'.
  APPEND ls_output_row TO lt_excel_output.
  CLEAR ls_output_row.

  ls_output_row-col1 = 'Navn'.
  ls_output_row-col2 = 'HR'.
  APPEND ls_output_row TO lt_excel_output.
  CLEAR ls_output_row.

  ls_output_row-col1 = 'Beskrivelse'.
  ls_output_row-col2 = 'HR'.
  APPEND ls_output_row TO lt_excel_output.
  CLEAR ls_output_row.

  APPEND ls_output_row TO lt_excel_output.

* Sorter på nivå
  LOOP AT lt_excel_data INTO DATA(ls_input_row).
    IF ls_input_row-col6_niv = '1'.
      APPEND ls_input_row TO lt_niv1.
    ELSEIF ls_input_row-col6_niv = '2'.
      APPEND ls_input_row TO lt_niv2.
    ELSEIF ls_input_row-col6_niv = '3'.
      APPEND ls_input_row TO lt_niv3.
    ELSEIF ls_input_row-col6_niv = '4'.
      APPEND ls_input_row TO lt_niv4.
    ENDIF.
  ENDLOOP.

* Loop på alle objekter på nivå 1
  LOOP AT lt_niv1 INTO DATA(ls_niv1_row).
    CLEAR ls_output_row.
    ls_output_row-col1 = ls_niv1_row-col1_id.
    ls_output_row-col5 = ls_niv1_row-col7_besk.
    APPEND ls_output_row TO lt_excel_output.

* For hver kategori på øverste nivå, legg til og finn hver kategori på andre nivå
    LOOP AT lt_niv2 INTO DATA(ls_niv2_row) WHERE col4_cat = ls_niv1_row-col1_id.
      CLEAR ls_output_row.
      ls_output_row-col2 = ls_niv2_row-col1_id.
      ls_output_row-col5 = ls_niv2_row-col7_besk.
      APPEND ls_output_row TO lt_excel_output.

* For hver kategori på andre nivå under hovedkategorien, finn hver kategori på tredje nivå
      LOOP AT lt_niv3 INTO DATA(ls_niv3_row) WHERE col4_cat = ls_niv2_row-col1_id.
        CLEAR ls_output_row.
        ls_output_row-col3 = ls_niv3_row-col1_id.
        ls_output_row-col5 = ls_niv3_row-col7_besk.
        APPEND ls_output_row TO lt_excel_output.

* For hver kategori på tredje nivå, finn hver kategori på fjerde nivå
        LOOP AT lt_niv4 INTO DATA(ls_niv4_row) WHERE col4_cat = ls_niv3_row-col1_id.
          CLEAR ls_output_row.
          ls_output_row-col4 = ls_niv4_row-col1_id.
          ls_output_row-col5 = ls_niv4_row-col7_besk.
          APPEND ls_output_row TO lt_excel_output.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDLOOP.

  PERFORM show_table.
  PERFORM export_to_txt USING lt_excel_output.

ENDFORM.

*--------------------------------------------------------------------*
* Vis behandlet data i tabellform
*--------------------------------------------------------------------*
FORM show_table.
  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = lo_table
        CHANGING
          t_table = lt_excel_output ).

      lo_table->display( ).

    CATCH cx_salv_msg.
      MESSAGE 'Feil ved tabellvisning' TYPE 'I'.
  ENDTRY.
ENDFORM.

*--------------------------------------------------------------------*
* Eksporter resultat til tekstfil
*--------------------------------------------------------------------*
FORM export_to_txt USING lt_data TYPE tt_excel_output.

  DATA: lv_line         TYPE string,
        lt_output_lines TYPE TABLE OF string,
        lv_filename     TYPE string.

* Konverter filnavn til string
  lv_filename = out_file.

* Formater data
  LOOP AT lt_data INTO DATA(ls_row).
    CONCATENATE ls_row-col1 ls_row-col2 ls_row-col3 ls_row-col4 ls_row-col5 ls_row-col6
    INTO lv_line SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
    APPEND lv_line TO lt_output_lines.
  ENDLOOP.

* Last ned med den valgte filbanen
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_filename
      filetype                = 'ASC'
    TABLES
      data_tab                = lt_output_lines
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.